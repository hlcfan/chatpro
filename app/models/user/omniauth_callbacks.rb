# coding: utf-8
class User
  module OmniauthCallbacks
    ["github","google","twitter","douban","weibo", "tqq2"].each do |provider|
      define_method "find_or_create_for_#{provider}" do |response|
        uid = response["uid"]
        data = response["info"]
        credentials = response['credentials']
        logger.info "======================#{credentials}"
        auth_token = credentials.token
        openid = credentials.openid || ""
        if user = User.where("authorizations.provider" => provider , "authorizations.uid" => uid).first
          user.auth_token = auth_token
          user.openid = openid
          user.save(:validate => false)
          user
        elsif user = User.find_by_username(data["email"])
          user.bind_service(response)
          user.auth_token = auth_token
          user.openid = openid
          user.save(:validate => false)
          user
        else
          user = User.new_from_provider_data(provider, uid, data)
          user.auth_token = auth_token
          user.openid = openid
          if user.save(:validate => false)
            user.authorizations << Authorization.new(:provider => provider, :uid => uid )
            return user
          else
            Rails.logger.warn("User.create_from_hash 失败，#{user.errors.inspect}")
            return nil
          end
        end
      end
    end

    def new_from_provider_data(provider, uid, data)
      User.new do |user|
        user.email = data["email"]
        user.weibo_id = data['name'] if provider == "weibo"
        #user.email = "twitter+#{uid}@example.com" if provider == "twitter"
        user.email = "douban+#{uid}@example.com" if provider == "douban"
        user.username = data['name']
        user.email = "weibo+#{uid}@example.com" if provider == "weibo"

        user.login = data["nickname"]
        user.login = data["name"] if provider == "google"
        user.login.gsub!(/[^\w]/, "_")        
        #user.github = data['nickname'] if provider == "github"

        if User.where(:login => user.login).count > 0 || user.login.blank?
          user.login = "u#{Time.now.to_i}" # TODO: possibly duplicated user login here. What should we do?
        end

        user.password = Devise.friendly_token[0, 20]
        user.location = data["location"]
        user.intro = data["description"]
        #user.password_flag = "0"  for some reason
      end
    end
  end
end
