require "openssl"
require "base64"

module CalmboardReporter
  class Encryption
    # Simplified encryption method that uses a single key for both encryption key and IV generation
    def self.encrypt(data)
      raise StandardError, "CALMBOARD_REPORTER_ENCRYPTION_KEY is not set" unless ENV.key?("CALMBOARD_REPORTER_ENCRYPTION_KEY")
      raise StandardError, "Must pass a String (received a #{data.class}): #{data}" unless data.is_a?(String)

      cipher = OpenSSL::Cipher.new("AES-256-CBC")
      cipher.encrypt

      secret_key = ENV.fetch("CALMBOARD_REPORTER_ENCRYPTION_KEY")
      key = OpenSSL::Digest.new("SHA256").digest(secret_key)
      iv = OpenSSL::Digest.new("SHA256").digest(secret_key)[0...16] # Truncate to 16 bytes for AES-256-CBC IV. This isn't themost secure way to generate an IV, but it's good enough for the purpose of obfuscating basic app metrics.

      cipher.key = key
      cipher.iv = iv

      encrypted_data = cipher.update(data) + cipher.final

      # Base64 encode the encrypted data to make it easier to store/transmit
      Base64.encode64(encrypted_data)
    end
  end
end
