module RequestsHelper
  def request_form_url_helper
    if params[:action] == "edit"
      request_path(@request)
    else
      requests_path()
    end
  end

  def request_form_method_helper
    if params[:action] == "edit"
      :patch
    else
      :post
    end
  end

  def options_for_budget
    [
      ['$100 a $500'],
      ['$500 a $1000'],
      ['$1000 a $2000'],
      ['$2000 a $5000'],
      ['$5000 a $9999']
    ]
  end

end
