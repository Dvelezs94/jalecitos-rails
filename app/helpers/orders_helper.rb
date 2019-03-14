module OrdersHelper
  def order_hint_employer(status)
    case status
    when "pending"
      icon("fas", "question-circle", class: "fa-pending-employer")
    when "waiting_for_bank_approval"
      icon("fas", "question-circle", class: "fa-waiting-for-bank-approval-employer")
    end
  end

  def order_hint_employee(status)
    case status
    when "pending"
      icon("fas", "question-circle", class: "fa-pending-employee")
    when "waiting_for_bank_approval"
      icon("fas", "question-circle", class: "fa-waiting-for-bank-approval-employee")
    end
  end
end
