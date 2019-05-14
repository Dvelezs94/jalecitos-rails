task :regenerate_long_alias => [:environment] do
  @failed_alias = 0
  User.all.each do |u|
    if u.alias.length > 30
      u.alias = "Usuario-#{SecureRandom.hex(11)}"
    end
    ################################
    if u.changed?
      begin
        u.save
      rescue
        @failed_alias +=1
      end
    end
  end
  puts "fix of long alias has finished"
  if @failed_alias > 0
    puts "#{@failed_alias} long alias hasnt been fixed"
  end

end
