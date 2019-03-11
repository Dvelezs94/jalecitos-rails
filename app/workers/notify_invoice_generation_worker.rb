class NotifyInvoiceGenerationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform(invoice_id, pdf_link, xml_link)
    @order_id = invoice_id
    @user = Order.find_by_uuid(@order_id).employer
    NotifyInvoiceGenerationMailer.invoice_ready(@user, pdf_link, xml_link, @order_id).deliver
  end
end
