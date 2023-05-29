class UserInvestment < ApplicationRecord
  belongs_to :user
  belongs_to :investment

  validates :initial_amount, presence: true, numericality: { greater_than: 0 }
end
