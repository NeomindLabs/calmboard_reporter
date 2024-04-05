require "rails_helper"
require "base64"
require "openssl"
require "json"

RSpec.describe "CalmboardReporter", type: :request do
  before do
    # Generate a secure random key and save it to an instance variable
    @encryption_key = OpenSSL::Random.random_bytes(32)
    # Base64 encode the key to simulate environment variable storage
    ENV["CALMBOARD_REPORTER_ENCRYPTION_KEY"] = Base64.strict_encode64(@encryption_key).strip
  end

  after do
    # Clean up the environment variable after each test
    ENV.delete("CALMBOARD_REPORTER_ENCRYPTION_KEY")
  end

  it "responds with a helpful error message when CALMBOARD_REPORTER_ENCRYPTION_KEY is not set" do
    # Unset the environment variable to simulate a missing key
    ENV.delete("CALMBOARD_REPORTER_ENCRYPTION_KEY")
    get "/calmboard_reporter"
    # Check if the response is unsuccessful and contains the error message
    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)).to have_key("error")
    expect(JSON.parse(response.body)["error"]).to eq("CALMBOARD_REPORTER_ENCRYPTION_KEY is not set")
  end

  it "responds with encrypted metrics when CALMBOARD_REPORTER_ENCRYPTION_KEY is set" do
    get "/calmboard_reporter"
    expect(response).to have_http_status(:ok)
    expect { JSON.parse(response.body) }.not_to raise_error
    expect(JSON.parse(response.body)).to have_key("encrypted_metrics")
  end

  it "responds with encrypted metrics that can be decrypted with the correct key" do
    get "/calmboard_reporter"
    encrypted_metrics = JSON.parse(response.body)["encrypted_metrics"]

    # Decryption process using the correct key and derived IV
    cipher = OpenSSL::Cipher.new("AES-256-CBC")
    cipher.decrypt
    key = OpenSSL::Digest.new("SHA256").digest(ENV["CALMBOARD_REPORTER_ENCRYPTION_KEY"])
    cipher.key = key
    cipher.iv = key[0...16] # Use the first 16 bytes of the key as the IV

    decrypted_data = cipher.update(Base64.decode64(encrypted_metrics)) + cipher.final
    parsed_data = JSON.parse(decrypted_data)

    expect(parsed_data).to have_key("ruby_version").and have_key("rails_version")
  end
end
