# task :task_pending_refunds => [:environment] do
#   pending_refunds = Order.where(status: "refund_in_progress", response_refund_id: nil)
#   pending_refunds.each do |o|
#     o.with_lock do
#       o.update(pending_refund_worker: true)
#       if o.response_refund_id.nil? #break if openpay doesnt respond in one
#         @error = true
#         break
#       end
#     end
#   end
#   puts "finished pending refunds rake"
#   puts "seems that openpay doesnt respond, run the job later, please" if @error
# end
