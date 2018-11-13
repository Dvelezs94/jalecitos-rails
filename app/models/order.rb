class Order < ApplicationRecord
  belongs_to :user
  belongs_to :purchase, polymorphic: true

  enum status: { pending: 0, incomplete_payment: 1, in_progress: 2, disputed: 3, completed: 4, refunded: 5}
end
