class AdminsController < ApplicationController
  layout 'admin'
  access admin: :all

  def dashboard
    @gigs = Gig.order(status: :desc).page(params[:gig_page]).per(25)
    @categories =  Category.order(:name).page(params[:category_page]).per(10)
    @users =  User.order(:name).page(params[:user_page]).per(25)
  end

  private
end
