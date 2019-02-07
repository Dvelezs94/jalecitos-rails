module RepliesHelper
  # this method notifies the proper user when a new reply is created
  def reply_notification(reply, user)
    @dispute = reply.dispute
    @employer = @dispute.order.employer
    @employee = @dispute.order.employee

    if user == @employer
      create_notification(user, @employee, "hizo una replica", @reply)
    elsif user == @employee
      create_notification(user, @employer, "hizo una replica", @reply)
    else #is admin
      create_notification(user, @employer, "hizo una replica", @reply)
      create_notification(user, @employee, "hizo una replica", @reply)
    end
  end
end
