class AdminsController < ApplicationController
  layout 'admin'
  access admin: :all

  def index_dashboard
    @gigs = Gig.order(updated_at: :desc).page(params[:gig_page]).per(25)
    @categories =  Category.order(:name).page(params[:category_page]).per(10)
    @users =  User.order(:name).page(params[:user_page]).per(25)
  end
end
