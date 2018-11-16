module UsersHelper
  def my_profile
    @user == current_user
  end
end
