class OrderWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  access all: :all

  def handle
    @object = params
    @object_type = @object["type"]
    @object_id = @object["transaction"]["id"] if @object_type != "verification"
    begin
      case
      when @object_type == "charge.succeeded"
        TransferFundsAfterThreeDWorker.perform_async(@object_id)
      when @object_type == "verification"
        OpenpayVerificationMailer.new_verification(ENV.fetch("RAILS_ENV"), @object["verification_code"]).deliver
      end
      render status: 200, json: { message: "Success" }.to_json
    rescue
      render status: 500, json: { message: "Unprocessable" }.to_json
    end
  end

end
