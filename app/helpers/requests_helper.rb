module RequestsHelper
  def request_form_url_helper
    if params[:action] == "edit" || params[:action] == "update"
      request_path(@request)
    else
      requests_path()
    end
  end

  def options_for_budget
    [
      ['$100.00 a $500.00'],
      ['$500.00 a $1000.00'],
      ['$1000.00 a $2000.00'],
      ['$2000.00 a $5000.00'],
      ['$5000.00 a $9999.00']
    ]
  end

end
