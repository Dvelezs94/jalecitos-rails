# task :unescape_messages => [:environment] do
#   Message.all.each do |msg|
#     msg.update_columns(body: CGI::unescape(ActionController::Base.helpers.strip_tags(msg.body)))
#   end
#   puts "all body content has unescaped and removed links"
# end
