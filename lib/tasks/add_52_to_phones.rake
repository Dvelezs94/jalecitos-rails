task :add_52_to_phones => [:environment] do
  User.all.each do |user|
    if user.phone_number.present?
      user.update(phone_number: "+52 " + user.phone_number[0..2]+" "+user.phone_number[3..5]+ " "+ user.phone_number[6..-1])
    end
  end
  puts "Teléfonos actualizados a +52"
end
