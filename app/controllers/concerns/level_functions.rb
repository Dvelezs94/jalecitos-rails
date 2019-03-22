module LevelFunctions
  # calculate payout corresponding to user
  def calc_level_percent(level)
    l = {
      1 => 0.9,
      2 => 0.95,
      3 => 0.96,
      4 => 0.97,
      5 => 0.98
    }
    l[level]
  end

  # level up user
  def level_up? (user)
    level = user.level
  end
end
