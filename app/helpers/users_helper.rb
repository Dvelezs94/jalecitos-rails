module UsersHelper
  def my_profile
    current_user && @user.id == current_user.id
  end

  def config_modals_helper
    if params[:controller] == "users" && params[:action] == "configuration"
      javascript_include_tag 'config_modals'
    end
  end
end
