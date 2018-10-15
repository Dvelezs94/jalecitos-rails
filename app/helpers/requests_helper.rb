module RequestsHelper
  def request_form_url_helper
    if params[:action] == "new"
      user_requests_path(current_user.id)
    else
      user_request_path(@request.user_id, @request)
    end
  end
end
