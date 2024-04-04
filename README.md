# Calmboard Reporter
A Rails engine that serves encrypted reports about your app for Calmboard.

## Usage
Just add this gem to any Rails app, and it will gather metrics on the app, encrypt them and make them available via a request from Calmboard.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "calmboard_reporter"
```

And then run:
```bash
$ bundle
```
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
