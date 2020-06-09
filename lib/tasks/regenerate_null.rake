# task :regenerate_null => [:environment] do
#   include OpenpayHelper
#   @failed_openpay = 0
#   @failed_user_score = 0
#   @failed_savings = 0
#   User.all.each do |u|
#     #########################33
#     if u.score.nil?
#       begin
#         UserScore.create do |user_score|
#           u.score = user_score
#         end
#       rescue
#         @failed_user_score+=1
#       end
#     end
#     ###############################################
#     if u.openpay_id.nil?
#       init_openpay("customer")
#
#       # Create default hash for new user
#       request_hash={
#         "name" => (u.name || u.alias),
#         "last_name" => nil,
#         "email" => u.email,
#         "requires_account" => true
#       }
#
#       begin
#         response_hash = @customer.create(request_hash.to_hash)
#         u.openpay_id = response_hash['id']
#       rescue
#          @failed_openpay+=1
#       end
#     end
#     #######################
#     if u.slug.nil?
#         u.slug = SecureRandom.hex(12)
#     end
#     ################################
#     if u.changed?
#       begin
#         u.save
#       rescue
#         @failed_savings +=1
#       end
#     end
#   end
#   puts "generation of null slug, openpay_id and scores has finished"
#   if @failed_openpay > 0
#     puts "Openpay has failed trying to generate #{@failed_openpay} openpay_id's"
#   end
#   if @failed_user_score > 0
#     puts "Task has failed trying to create #{@failed_openpay} user_score's"
#   end
#   if @failed_savings > 0
#     puts "Task has failed trying to fix #{@failed_openpay} users, so problems still exist"
#   end
# end
