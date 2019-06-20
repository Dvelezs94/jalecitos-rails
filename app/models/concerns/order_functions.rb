module OrderFunctions
  extend ActiveSupport::Concern

  def increment_count(order)
    emp_score = order.employee.score
    emp_score.update(:total_sales => emp_score.total_sales + order.total)
    if order.purchase_type == "Package"
      gig = order.purchase.gig
      gig.update( order_count: gig.order_count + 1 )
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
  # function to calculate payout
  def calc_payout(orders)
    h = [orders: [], :count => 0]
    count = 0
    max = 5000.0 #maximum allowed openpay payout
    orders.each do |o|
      available = max - count
      if available >= o.payout_left
        h[0][:orders] << {id: o.id,  payout_left: 0}
        count += o.payout_left
      elsif available > 0
        h[0][:orders] << {id: o.id,  payout_left: (o.payout_left - available).round(2)}
        count += available
        break
      else
        break
      end
    end
    h[0][:count] = count
    h
  end
end
