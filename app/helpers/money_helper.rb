module MoneyHelper
  # Earning for the worker
  def get_order_earning base
    # Constant Increment to keep our loss at minimum
    ci = 10
    # Formula to get earnings based on the base  price (package or offer number)
    ((0.9609776)*( base + ci ) - 2.91  - calc_employee_earning(base)).round(2)

  end
  # this is used for the hire view, to calculate the subtotal and our fee + iva
  def calc_hire_view price
    # Constant Increment to keep our loss at minimum
    ci = 10
    iva = 1.16
    fee = (((price * 0.1) + ci) * iva).round(2)
    subtotal = ((price * 0.9) * iva).round(2)
    {"fee": fee, "subtotal": subtotal}
  end

  def order_tax price
    (price * 0.16).round(2)
  end
  ###### These two should always sum 1
  def get_order_fee price
    # Get our fee of base price
    (price * 0.10).round(2)
  end

  def calc_employee_earning base
    (base * 0.9).round(2)
  end
  ######
  # the difference with the one above is that this one calculates all the orders minus fees and taxes
  def calc_employee_orders_earning(orders_total, orders_count)
    (((orders_total / 116) * 100 - (10 * orders_count)) * 0.90).round(2)
    # (45/58) * orders_total - 9 * orders.count
  end

  def calc_openpay_tax (order_total)
    openpay_fee = 0.029 #percent
    openpay_base = 2.5 #MXN pesos
    pre_iva = (order_total * openpay_fee + openpay_base).round(2)
    tax_iva = pre_iva * 0.16
    (pre_iva + tax_iva).round(2)
  end

  # Get toal price of order, with taxes included
  def purchase_order_total price
    const_added = price + 10
    iva = order_tax(const_added)
    (const_added + iva).round(2)
  end


  # Method to get results in console, this has no real use in the app
  def print_earnings base
    ci = 10
    jalecitos_earning =  ((ci - 2.9) - (ci * 0.0390224) - (0.0390224 * base) + get_order_fee(base)).round(2)
    openpay_earning = (purchase_order_total(base) * 0.03364 + 2.9).round(2)
    p "base + iva = #{purchase_order_total(base)}"
    p "openpay = #{openpay_earning}"
    p "jalecitos = #{jalecitos_earning}"
    return true
  end
end
