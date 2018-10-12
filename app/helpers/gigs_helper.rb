module GigsHelper
   def status_text_helper gig
     if gig.published?
       "Ocultar"
     else
       "Publicar"
     end
   end


   def checked_helper option_status
     if @gig.status == option_status
       opions = {checked: true}
     else
       opions = {checked: false}
     end
   end
end
