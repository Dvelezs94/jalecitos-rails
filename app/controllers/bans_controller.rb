class BansController < ApplicationController
  before_action :authenticate_user!
  before_action :check_cause_present, only: :create
  before_action :no_system_ban, only: :create
  before_action :set_report, only: :create
  access admin: :all
  before_action :set_ban, only: [:proceed, :deny]

  def proceed
    case @ban.baneable_type
      when "Gig"
        @ban.baneable.banned!
        @ban.banned!
      when "Request"
        @ban.baneable.banned!
        @ban.banned!
      when "User"
        @ban.baneable.banned!
        @ban.banned!
    end
    redirect_to bans_admins_path
  end

  def deny
    @ban.denied!
    redirect_to bans_admins_path
  end

  def create
    ban = Ban.new(ban_params)
    if ban.valid?
      @success = ban.save
    elsif ban.errors.full_messages.first.include?("Status") #of "Status", gives error of status in use when the resource is banned
      @already_banned = true
    end
    render "create"
  end

  private

  def set_ban
    @ban = Ban.find(params[:id])
  end

  def ban_params
    ban_params = params.require(:ban).permit(:cause,
                                :comment
                              ).merge(:baneable => @report.reportable)
  end

  def set_report #these are the admitted models for ban
    if params[:report_id].present?
      @report = Report.find_by(status: "open", id: params[:report_id].to_i)
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
