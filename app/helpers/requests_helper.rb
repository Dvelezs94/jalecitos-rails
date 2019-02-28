module RequestsHelper
  def request_form_url_helper
    if params[:action] == "edit" || params[:action] == "update"
      request_path(@request)
    else
      requests_path()
    end
  end

 #this is used in view and validation
  def options_for_budget
    [
      '$100.00 a $300.00',
      '$301.00 a $500.00',
      '$501.00 a $1000.00',
      '$1001.00 a $2000.00',
      '$2001.00 a $3000.00',
      '$3001.00 a $4000.00',
      '$4001.00 a $5000.00',
      '$5001.00 a $6000.00',
      '$6001.00 a $7000.00',
      '$7001.00 a $8000.00',
      '$8001.00 a $9999.00'
    ]
  end

end
