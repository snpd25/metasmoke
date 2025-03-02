# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = true

  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600',
    'Expires' => 1.week.from_now.to_formatted_s(:rfc822).to_s
  }

  # Compress JavaScripts and CSS.
  # config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :memory_store, { size: 10.megabytes }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  AppConfig = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'email-smtp.us-east-1.amazonaws.com',
    port: 587, # Port 25 is throttled on AWS
    user_name: AppConfig['ses_smtp_credentials']['username'],
    password: AppConfig['ses_smtp_credentials']['password'],
    authentication: :login
  }
  config.action_mailer.default_url_options = { host: 'metasmoke.erwaysoftware.com', port: 80 }

  config.web_console.development_only = false
  config.web_console.permissions = '82.69.87.121'

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = [I18n.default_locale]

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.action_cable.disable_request_forgery_protection = true

  config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      bucket: 'erwaysoftware.metasmokedumps',
      access_key_id: AppConfig['aws']['access_token'],
      secret_access_key: AppConfig['aws']['secret_token']
    },
    s3_region: 'us-east-2'
  }

  Aws.config.update(region: 'us-east-1',
                    credentials: Aws::Credentials.new(AppConfig['aws']['access_token'], AppConfig['aws']['secret_token']))
end
