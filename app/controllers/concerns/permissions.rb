module ProfilePermissions
  def check_user_ownership
    if ! my_profile
      flash[:error] = "No tienes permisos para acceder aquí"
      redirect_to root_path
    end
  end
end
