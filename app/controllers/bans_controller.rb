class BansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ban, only: [:unban]
  before_action :check_cause_present, only: :create
  before_action :no_system_ban, only: :create
  before_action :set_report, only: :create
  access admin: :all

  def unban
    if @ban.banned? && @ban.baneable_type != "Request"
      @ban.unbanned!
      @success = true
    elsif @ban.unbanned?
      @already_unbanned = true
    elsif @ban.deleted_resource?
      @deleted_resource = true
    elsif @ban.baneable_type == "Request"
      @cant_unban_request = true
    end
  end

  def create
    ban = Ban.new(ban_params)
    @success = ban.save
    if ! @success
      if ban.errors.full_messages.first.include?("Baneable") #the resource is already banned
        old_ban = Ban.find_by(baneable: @report.reportable, status: "banned")
        @report.update!( ban: old_ban, status: "accepted" )
        @already_banned = true
      else #openpay error
        @openpay_error = ban.errors.full_messages.first
      end
    end
  end

  private

  def set_ban
    @ban = Ban.find(params[:id])
  end

  def ban_params
    ban_params = params.require(:ban).permit(:cause,
                                :comment
                              ).merge(:baneable => @report.reportable, banned_by: current_user)
  end

  def set_report #these are the admitted models for ban
    if params[:report_id].present?
      @report = Report.find_by(status: "open", id: params[:report_id].to_i)
      if !@report #report was treated and not open now
        @treated_report = true
        render "create"
      end
    else
      head :no_content
    end
  end
  def check_cause_present #these are the admitted models for ban
    if !params[:ban][:cause].present?
      @need_cause = true
      render "create"
    end
  end

  def no_system_ban
    #only system can do system_ban
    head(:no_content) if params[:ban][:cause] == "system_ban"
  end

end
