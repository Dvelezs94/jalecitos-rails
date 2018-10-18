module RequestsHelper
  def request_form_url_helper
    if params[:action] == "edit"
      user_request_path(current_user.slug, @request)
    else
      user_requests_path(current_user.slug)
    end
  end

  def request_form_method_helper
    if params[:action] == "edit"
      :patch
    else
      :post
    end
  end

end
