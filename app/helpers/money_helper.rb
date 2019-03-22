module MoneyHelper
  $cons = 10 #the constant added to base
  $fee = 0.04 #the percentage added to the base (includes contant)
  $iva = 0.16


  # Earning for order hiring
  def get_order_earning base
     (($fee+1) * (base+$cons) - (1+ $iva ) * ($fee+1) * ( base + $cons ) * ( 0.03364 ) - 2.9 - x).round(2)
  end

  def order_tax price
    purchase_order_total(price)*$iva.round(2)
  end

  ######

  def calc_openpay_tax (order_total)
    openpay_fee = 0.029 #percent
    openpay_base = 2.5 #MXN pesos
    pre_iva = (order_total * openpay_fee + openpay_base).round(2)
    tax_iva = pre_iva * iva
    (pre_iva + tax_iva).round(2)
  end

  # Get toal price of order, with taxes included
  def purchase_order_total price
    ($fee+1) * (price+$cons)
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
