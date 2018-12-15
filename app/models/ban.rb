class Ban < ApplicationRecord
  belongs_to :baneable, polymorphic: true
  enum status: { pending: 0, denied: 1, banned: 2}
  validates_uniqueness_of :baneable_id, :scope => [:baneable_type, :baneable_id]
end
