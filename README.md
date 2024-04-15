# Calmboard Reporter
A Rails engine that serves encrypted reports about your app for Calmboard.

## Usage
Just add this gem to any Rails app, and it will gather metrics on the app, encrypt them and make them available via a request from Calmboard.

As of now, this gem only gathers two metrics:
- the version of Ruby that the app is currently running on
- the version of Rails that the app is

In the future, additional metrics could be added by adding modules to `lib/calmboard_reporter/metrics`.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "calmboard_reporter", git: 'https://github.com/NeomindLabs/calmboard_reporter.git'
```

And then run:
```bash
$ bundle
```

Finaly, don't forget to set the encryption key on the app using an environment variable:
```bash
export CALMBOARD_REPORTER_ENCRYPTION_KEY="the encryption key"
```
You can find the key in [1Password](https://start.1password.com/open/i?a=LCFHDJUCGBGTDBRVBXHMLAL2IU&v=dyxwv6ymobah7m3rf5prichiqq&i=e3yma4g4mokk5alzb2si2s5mdi&h=neomindlabs.1password.com).

## Encrypted Reporting
This app uses its own unique encryption key to encrypt all apps' metrics reports. You can find the key in [1Password](https://start.1password.com/open/i?a=LCFHDJUCGBGTDBRVBXHMLAL2IU&v=dyxwv6ymobah7m3rf5prichiqq&i=e3yma4g4mokk5alzb2si2s5mdi&h=neomindlabs.1password.com). 

### Setting Up a New Encryption Key
You can generate a new encryption key by running:

```bash
openssl rand -base64 32
```

After you update it, don't forget to:
- update it in [1Password](https://start.1password.com/open/i?a=LCFHDJUCGBGTDBRVBXHMLAL2IU&v=dyxwv6ymobah7m3rf5prichiqq&i=e3yma4g4mokk5alzb2si2s5mdi&h=neomindlabs.1password.com)
- update it in Calmboard's encrypted credentials
- update it as stored in environment variables for any apps using this gem

### Decrypting the Metrics
Once this gem is installed and running in an app, Calmboard can then send a GET request to `/calmboard_reporter` (see `lib/calmboard_reporter/engine.rb`). The response will be JSON, like this:
```json
{
  "encrypted_metrics" => "[a long encrypted string]"
}
```
Once you decrypt and parse that long encrypted string value, you'll have a Hash like this:
```ruby
{
  "rails_version" => "7.1.3.2", 
  "ruby_version" => "3.1.4"
}
```
To see a working decryption process in detail, see `spec/requests/calmboard_reporter_spec.rb`. 

### Why didn't you use `ActiveSupport::KeyGenerator` and `ActiveSupport::MessageEncryptor`? 
I agree, this would have been simpler and more Rails-y! But as it turns out, different versions of Rails use different default encryption settings for the same methods (`SHA1` vs `SHA256`, `AEAD` mode `true` vs `false`, etc). Many of these settings are not easily changeable without monkey patching. This makes it very difficult to ensure that a message encrypted by one Rails version will be decryptable by another Rails version. 

Instead, I decided to rely on an explicitly configured implementation of OpenSSL (see: `lib/calmboard_reporter/encryption.rb`), without any Rails specific methods used. 
