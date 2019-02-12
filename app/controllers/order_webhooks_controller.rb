class OrderWebhooksController < ApplicationController
  http_basic_authenticate_with name: ENV.fetch("WEBHOOK_USERNAME"), password: ENV.fetch("WEBHOOK_PASSWORD")
  skip_before_action :verify_authenticity_token
  access all: :all

  def handle
    @object = params
    @object_type = @object["type"]

    begin
      case
      when @object_type == "charge.succeeded"
        @object_id = @object["transaction"]["id"]
        TransferFundsAfterThreeDWorker.perform_async(@object_id)
      when @object_type == "invoice.created"
        @invoice = @object["invoice_data"]
        NotifyInvoiceGenerationWorker.perform_async(@invoice["invoice_id"],  @invoice["public_pdf_link"], @invoice["public_xml_link"])
      when @object_type == "charge.failed"
        @object_id = @object["transaction"]["id"]
        @error_message = @object["transaction"]["error_message"]
        ChargeDeniedWorker.perform_async(@object_id, @error_message)
      when @object_type == "verification"
        OpenpayVerificationMailer.new_verification(ENV.fetch("RAILS_ENV"), @object["verification_code"]).deliver
      end
      render status: 200, json: { message: "Success" }.to_json
    rescue
      render status: 500, json: { message: "Unprocessable" }.to_json
    end
  end

end
