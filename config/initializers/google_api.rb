ENV["GOOGLE_ACCOUNT_TYPE"] = Rails.application.credentials.dig(:google, :service_account, :type)
ENV["GOOGLE_CLIENT_ID"] = Rails.application.credentials.dig(:google, :service_account, :client_id)
ENV["GOOGLE_CLIENT_EMAIL"] = Rails.application.credentials.dig(:google, :service_account, :client_email)
ENV["GOOGLE_PRIVATE_KEY"] = Rails.application.credentials.dig(:google, :service_account, :private_key)
