class SeoController < ApplicationController
  layout 'admin'
  access admin: :all
  before_action :set_gig, only: [:edit, :update]
  before_action :create_seo, only: [:edit]
  def index
    @gigs = Gig.includes(:seo).where(status: "published")
    @gig = Gig.find(params[:id]) if params[:id].present? #sent when record is updated
  end

  def edit
  end

  def update
    @gig.with_lock do
      @success = @gig.seo.update(seo_params)
    end
    if @success
      flash[:success] = "Actualizado con éxito"
      redirect_to seo_index_path(id: @gig.id)
    else
      render :edit
    end
  end
  private
   def set_gig
     @gig = Gig.find(params[:id])
   end
   def create_seo
     @gig.with_lock do
       if @gig.seo.nil?
         Seo.create do |seo|
           @gig.update(seo: seo)
         end
       end
    end
   end
   def seo_params
     seo_params = params.require(:seo).permit(:title,
                                 :description,
                                 :keywords
                               )
   end
end
