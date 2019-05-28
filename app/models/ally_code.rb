class AllyCode < ApplicationRecord
  has_many :users
  validates_numericality_of :times_left, :only_integer => true, :greater_than_or_equal_to => 0
end
