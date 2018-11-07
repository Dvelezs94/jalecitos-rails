module SetLayout
  def set_layout
    (current_user)? 'logged' : 'guest'
  end
end
