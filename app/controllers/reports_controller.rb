class ReportsController < ApplicationController
  before_action :authenticate_user!
  access user: :all
  before_action :verify_report_count, only: :create

  # POST /reports
  def create

    @report = Report.new(report_params)

    # create reportable object
    if params[:user_id] && params[:gig_id]
      @gig = Gig.friendly.find(params[:gig_id])
      @report.reportable = @gig
    # check if report is going to request
    elsif params[:request_id]
      @request = Request.friendly.find(params[:request_id])
      @report.reportable = @request
    else
      @user = User.friendly.find(params[:user_id])
      @report.reportable = @user
    end


    @report.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def report_params
       report_params = params.require(:report).permit(:cause, :comment)
       report_params[:user] = current_user
       report_params
    end

    def verify_report_count
      if current_user.reports.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count >= 5
        render :create
      end
    end
end