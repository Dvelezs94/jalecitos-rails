task :set_whatsapp_enabled_to_true => [:environment] do
  User.all.each do |user|
    user.update(whatsapp_enabled: true)
  end
  puts "Set all whatsapp to true"
end
