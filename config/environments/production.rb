Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.headers = {
    'Cache-Control' => 'public, s-maxage=31536000, max-age=31536000',
    'Expires' => (1.year.from_now.utc.to_fs(:rfc822))
  }

  config.assets.compile = false
  config.log_level = :debug
  config.log_tags = [ :request_id ]

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  config.active_record.dump_schema_after_migration = false
end