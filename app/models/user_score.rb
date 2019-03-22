class UserScore < ApplicationRecord
  include LevelHelper
  has_one :user

  before_update :gain_level

  def gain_level
    lq = levels_quantity #get level and sales needed
    lq.each do |key, value|
      if self.total_sales >= value
        self.level = key
      else
        break
      end
    end
  end
end
