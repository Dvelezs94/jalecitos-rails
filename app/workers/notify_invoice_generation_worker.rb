class NotifyInvoiceGenerationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(invoice)
    @order_id = invoice["invoice_data"]["invoice_id"]
    @user = Order.find_by_uuid(@order_id).employer
    @xml = invoice["invoice_data"]["public_xml_link"]
    @pdf = invoice["invoice_data"]["public_pdf_link"]
    NotifyInvoiceGenerationMailer.invoice_ready(@user, @pdf, @xml, @order_id).deliver
  end
end
