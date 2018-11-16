class Order < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: "User"
  belongs_to :receiver, foreign_key: :receiver_id, class_name: "User"
  belongs_to :purchase, polymorphic: true
  belongs_to :withdrawal, optional: true

  enum status: { pending: 0, denied: 1, in_progress: 2, disputed: 3, completed: 4, refunded: 5}
end
