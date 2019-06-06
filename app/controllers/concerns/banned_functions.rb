module BannedFunctions
  private
  def flash_if_user_banned
    flash[:error]='Tu cuenta está bloqueada' if current_user.banned?
  end
  def redirect_if_user_banned
    if current_user.banned?
      flash[:error]='Tu cuenta está bloqueada'
      redirect_to(root_path)
    end
  end
end
