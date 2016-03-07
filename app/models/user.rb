class User < ActiveRecord::Base
  has_secure_password

  def self.from_omniauth(auth_info)
    find_or_create_by(uid: auth_info[:extra][:raw_info][:user_id]) do |new_user|
      new_user.uid                = auth_info.extra.raw_info.user_id
      new_user.name               = auth_info.extra.raw_info.name
      new_user.screen_name        = auth_info.extra.raw_info.screen_name
      new_user.oauth_token        = auth_info.credentials.token
      new_user.oauth_token_secret = auth_info.credentials.secret
      new_user.provider           = auth_info.provider
      new_user.password           = "password"
    end
  end

  def summoner_name_and_region_absent?
    summoner_name.nil? || region.nil?
  end

end
