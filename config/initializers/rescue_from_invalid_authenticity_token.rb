Rails.application.config.middleware.insert_before(OmniAuth::Builder, RescueFromInvalidAuthenticityToken)
