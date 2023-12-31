class UserInvestment < ApplicationRecord
  belongs_to :user
  belongs_to :investment

  validates :initial_amount, presence: true, numericality: { greater_than: 0 }
  validate :initial_amount_enough?
  validate :premium_investment_available?
  validate :balance_account_enough?

  before_create :set_initial_profit
  after_commit :update_investment_profit, on: :create

  def update_account_balance
    user.account.update(balance: user.account.balance - initial_amount)
  end

  def update_account_balance_after_rescue
    user.account.update(balance: user.account.balance + profit)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[initial_amount profit]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[investment user]
  end

  private

  def update_investment_profit
    UserInvestments::UpdateProfitJob.perform_later(id)
  end

  def premium_investment_available?
    return unless user && user.role == 'free' && investment && investment.premium

    errors.add(:base, 'Premium investments are not available for free users')
  end

  def initial_amount_enough?
    errors.add(:initial_amount, 'needs to be more than minimum amount') if initial_amount && initial_amount < investment.minimum_amount
  end

  def balance_account_enough?
    errors.add(:base, 'Balance is not enough') if initial_amount && user.account.balance < initial_amount
  end

  def set_initial_profit
    self.profit = initial_amount.to_f
  end
end
