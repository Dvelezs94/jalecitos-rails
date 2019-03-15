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
      '$100 a $300',
      '$301 a $500',
      '$501 a $1000',
      '$1001 a $2000',
      '$2001 a $3000',
      '$3001 a $4000',
      '$4001 a $5000',
      '$5001 a $6000',
      '$6001 a $7000',
      '$7001 a $8000',
      '$8001 a $9999'
    ]
  end

end
