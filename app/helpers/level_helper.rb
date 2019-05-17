module LevelHelper
  def set_level_fee
    @ally_code = current_user.ally_code
    if @ally_code.present?
      if @ally_code.level_enabled
        current_user.level
      else
        # 0 stands for ally level
        0
      end
    else
      current_user.level
    end
  end
  # calculate payout corresponding to user
  def levels_fee
    {
      0 => 1,
      1 => 0.9,
      2 => 0.95,
      3 => 0.96,
      4 => 0.97,
      5 => 0.98
    }
  end

  def levels_quantity
    {
      1 => 0,
      2 => 1000,
      3 => 5000,
      4 => 20000,
      5 => 50000
    }
  end
  def calc_level_percent(level)
    l = levels_fee
    l[level]
  end

  # level up user
  def level_up? (user)
    level = user.level
  end

  def get_payout_charge_in_view
    # openpay fee, includes iva
    openpay_fee = 9.28
    if current_user.balance >= 5000
      fee = (5000 * (1 - calc_level_percent(current_user.score.level))) + openpay_fee
    else
      fee = (current_user.balance * (1 - calc_level_percent(current_user.score.level))) + openpay_fee
    end
    number_to_currency(fee.round(2))
  end
end
