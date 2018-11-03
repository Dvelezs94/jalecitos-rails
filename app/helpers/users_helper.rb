module UsersHelper
  def my_profile
    current_user && @user.id == current_user.id
  end
end
