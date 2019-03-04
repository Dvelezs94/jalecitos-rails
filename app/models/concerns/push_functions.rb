module PushFunctions
  extend ActiveSupport::Concern
  require 'fcm'

  def createFirebasePush(user_id, options)
    @user = User.find(user_id)
    @user_subscriptions = @user.push_subscriptions.pluck(:auth_key)
    fcm = FCM.new(ENV.fetch("GCM_SERVER_KEY"))
    response = fcm.send(@user_subscriptions, options)
    # delete unused push subsciptions
    response[:not_registered_ids].each do |ps|
      @user.push_subscriptions.find_by_auth_key(ps).delete
    end
  end
end
