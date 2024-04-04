# lib/calmboard_reporter/encryption.rb

require "active_support"

module CalmboardReporter
  class Encryption
    def self.encrypt(data)
      key = ActiveSupport::KeyGenerator.new(
        ENV.fetch("CALMBOARD_REPORTER_ENCRYPTION_KEY") { "default key if not set" }
      ).generate_key("encrypted key salt", 32)

      encryptor = ActiveSupport::MessageEncryptor.new(key)
      encryptor.encrypt_and_sign(data)
    end
  end
end
