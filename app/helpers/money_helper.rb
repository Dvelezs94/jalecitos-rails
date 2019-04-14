module MoneyHelper
  $cons = 10 #the constant added to base
  $fee = 0.04 #the percentage added to the base (includes contant)
  $iva = 0.16
  $openpay_fee = 0.029 #percent
  $openpay_base = 2.5 #MXN pesos


  # Earning for order hiring
  #  2.91 because some operations fail with a missing 0.01
  def get_order_earning base
     (($fee+1) * (base+$cons) - (1+ $iva ) * ($fee+1) * ( base + $cons ) * ( 0.03364 ) - 2.91 - base).round(2)
  end

  def order_tax price
    (((price + $cons) * (1 + $fee)) * $iva).round(2)
  end

  def invoice_unitary price
    (($fee+1) * (price+$cons)).round(2)
  end

  #####

  def calc_openpay_tax (order_total)
    pre_iva = (order_total * $openpay_fee + $openpay_base).round(2)
    tax_iva = pre_iva * $iva
    (pre_iva + tax_iva).round(2)
  end

  # Get toal price of order, with taxes included
  def purchase_order_total price
    ($fee+1) * (price+$cons) * (1+$iva)
  end

  # used for hire view
  def calc_hire_view price
    # Constant Increment to keep our loss at minimum
    subtotal = (price)*(1+$iva).round(2)
    buy_fee = (purchase_order_total(price) - subtotal).round(2)
    {"fee": buy_fee, "subtotal": subtotal}
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

  def example x, c, p
    iva = 0.16
    #x is user win
    #c is constant added
    #p is percentage added
    g = (p+1) * (x+c) - (1+ iva ) * (p+1) * ( x+ c ) * ( 0.03364 ) - 2.9 - x
    costo = (x)
    p "ganancia #{g}"
    p "costo #{((p+1) * (x+c))*1.16}"
    return true
  end
end
