class BansController < ApplicationController
  before_action :authenticate_user!
  access admin: :all
  before_action :set_ban

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

  private

  def set_ban
    @ban = Ban.find(params[:id])
  end
end
