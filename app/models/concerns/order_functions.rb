module OrderFunctions
  extend ActiveSupport::Concern

  def increment_count(order)
    if order.purchase_type == "Package"
      order.purchase.gig.increment!(:order_count)
    end
  end

  def finish_order_request(order)
    if order.purchase_type == "Offer"
      order.purchase.request.completed!
    end
  end

  def create_reviews(order)
    #this is useful for collecting the two reviews generated
    @new_reviews = []
    if order.purchase_type == "Package"
      create_review( order, order.employer, order.employee, order.purchase.gig)
      create_review( order, order.employee, order.employer, order.purchase.gig)
    else
      create_review(order, order.employer, order.employee, order.purchase.request)
      create_review(order, order.employee, order.employer, order.purchase.request)
    end

    #get the id of the user corresponding review and the one for use in the job
    @employer_review = @new_reviews.select{ |r| r.giver_id == order.employer.id }.first
    @employee_review = @new_reviews.select{ |r| r.giver_id != order.employer.id }.first
  end

  def create_review(order, giver, receiver, object)
    @new_reviews << Review.create!( order: order, giver: giver, receiver: receiver, reviewable: object)
  end

  def generate_invoice(order)
    OrderInvoiceGeneratorWorker.perform_async(order.id) if order.billing_profile_id
  end
end
