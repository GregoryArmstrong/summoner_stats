Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "ULEBb6sBeDUo6EMv7WJMdKtqR", "IIwApsMzJbvvCfO2t4FyjxjvqzHwgMqVQeF3qCc4jKhnes3odO"
end

def stub_omniauth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
    provider: 'twitter',
    extra: {
      raw_info: {
        user_id: "704373422701178882",
        name: "Gregory Armstrong",
        screen_name: "GregTArmstrong"
      }
    },
    credentials: {
      token: "704373422701178882-tuoiZiNmfPaK6QpkOlqjoWJA3DcUoLM",
      secret: "bU5IsKxhusiZT9iMkZSs9gcZ054teuRlRHusaOFi92nDw"
    }
  })
end
