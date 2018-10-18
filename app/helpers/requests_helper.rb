module RequestsHelper
  def request_form_url_helper
    if params[:action] == "new" || params[:action] == "create"
      user_requests_path(current_user.slug)
    else
      user_request_path(@request.user_id, @request)
    end
  end
end
