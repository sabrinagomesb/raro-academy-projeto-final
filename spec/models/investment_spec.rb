require 'rails_helper'

RSpec.describe Investment do
  describe 'Validation definitions' do
    subject(:investment) { build(:investment) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:minimum_amount) }
    it { is_expected.to validate_presence_of(:income) }
    it { is_expected.to validate_presence_of(:expiration_date) }

    it {
      expect(investment).to allow_value(%w[true false]).for(:premium)
    }

    it {
      expect(investment).to validate_numericality_of(:minimum_amount)
        .is_greater_than(0)
    }

    it {
      expect(investment).to validate_length_of(:name)
        .is_at_least(1).is_at_most(15)
    }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:approver).class_name('User') }
    it { is_expected.to have_many(:user_investments).class_name('UserInvestment').dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_investments) }
  end

end
