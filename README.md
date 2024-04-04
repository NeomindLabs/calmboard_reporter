# Calmboard Reporter
A Rails engine that serves encrypted reports about your app for Calmboard.

## Usage
Just add this gem to any Rails app, and it will gather metrics on the app, encrypt them and make them available via a request from Calmboard.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "calmboard_reporter"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install calmboard_reporter
```

### Setting Up the Encryption Key
For the security of your data, calmboard_reporter requires an encryption key to encrypt and decrypt the metrics data. It is essential to generate a strong encryption key and set it as an environment variable in your application environment.
Generating an Encryption Key

You can generate a strong encryption key using a tool like OpenSSL. Open your terminal and run the following command to generate a 32-byte key:

```bash
openssl rand -base64 32
```

Copy the generated key as you will need it to set the environment variable.

### Setting the Environment Variable
Once you have generated the encryption key, you need to set it as an environment variable on your system. The environment variable is accessed by calmboard_reporter to encrypt and decrypt the metrics data securely.

For a UNIX-like operating system, you can set the environment variable temporarily in your current shell session:

```bash
export CALMBOARD_REPORTER_ENCRYPTION_KEY='your_generated_key_here'
```

To make this change permanent, add the export statement to your shell's profile script (e.g., `~/.bash_profile` or `~/.bashrc`).

For deployment environments (like Heroku, AWS, etc.), please refer to the specific documentation on setting environment variables for your hosting service.

### Accessing the Encryption Key in Your Application
`calmboard_reporter` will automatically retrieve the encryption key from the environment variable `CALMBOARD_REPORTER_ENCRYPTION_KEY`. Ensure this variable is set in every environment where the engine is deployed.