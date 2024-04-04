require "rails_helper"
require "active_support"
require "openssl"
require "base64"
require "digest"

RSpec.describe "CalmboardReporter", type: :request do
  before do
    # Generate a secure random key and save it to an instance variable
    @encryption_key = `openssl rand -base64 32`.strip
    # Set the generated key as an environment variable for the test's duration
    ENV["CALMBOARD_REPORTER_ENCRYPTION_KEY"] = @encryption_key
  end

  it "responds with encrypted metrics" do
    get "/calmboard_reporter"
    # Check if the response is successful and contains the encrypted metrics
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to have_key("encrypted_metrics")
    # Decrypt the encrypted metrics and check if the decrypted data contains the expected keys
    encrypted_metrics = JSON.parse(response.body)["encrypted_metrics"]
    key = ActiveSupport::KeyGenerator.new(
      @encryption_key
    ).generate_key("encrypted key salt", 32)
    decryptor = ActiveSupport::MessageEncryptor.new(key)
    decrypted_data = decryptor.decrypt_and_verify(encrypted_metrics)
    parsed_data = JSON.parse(decrypted_data)
    expect(parsed_data).to have_key("ruby_version").and have_key("rails_version")
  end
end
