class Report < ApplicationRecord
  belongs_to :user
  belongs_to :reportable, polymorphic: true
  enum status: { open: 0, closed: 1 }
  validates :user_id, :uniqueness => { :scope => [:reportable_type, :reportable_id] }
end
