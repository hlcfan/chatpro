# coding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(*providers)
    providers.each do |provider|
      class_eval %Q{
        def #{provider}
          if not current_user.blank?
            current_user.bind_service(env["omniauth.auth"])#Add an auth to existing
            redirect_to edit_user_registration_path, :notice => "成功绑定了 #{provider} 帐号。"
          else
            @user = User.find_or_create_for_#{provider}(env["omniauth.auth"])

            if @user.persisted?
              flash[:notice] = "Signed in with #{provider.to_s.titleize} successfully."
              sign_in_and_redirect @user, :event => :authentication, :notice => "登陆成功。"
            else
              redirect_to new_user_registration_url
            end
          end
        end
      }
    end
  end

  provides_callback_for :github, :twitter, :douban, :google, :weibo

  # This is solution for existing accout want bind Google login but current_user is always nil
  # https://github.com/intridea/omniauth/issues/185
  def handle_unverified_request
    true
  end

  # def google_openid
  #   render :text => "ami"
  # end

  # def weibo
  #   omniauth_process
  # end

  # protected
  # def omniauth_process
  #   omniauth = request.env['omniauth.auth']
  #   authentication = Authorization.where(provider: omniauth.provider, uid: omniauth.uid.to_s).first

  #   if authentication
  #     set_flash_message(:notice, :signed_in)
  #     sign_in(:user, authentication.user)
  #     redirect_to root_path
  #   elsif current_user
  #     authentication = Authorization.create_from_hash(current_user.id, omniauth)
  #     set_flash_message(:notice, :add_provider_success)
  #     redirect_to authentications_path
  #   else
  #     session[:omniauth] = omniauth.except("extra")
  #     set_flash_message(:notice, :fill_your_email)
  #     redirect_to new_user_registration_url
  #   end
  # end

  # def after_omniauth_failure_path_for(scope)
  #   new_user_registration_path
  # end
  
end