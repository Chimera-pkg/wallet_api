class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, numericality: { greater_than: 0 }
  validate :validate_wallets

  after_create :update_wallets_balance

  private

  def validate_wallets
    if transaction_type == 'credit' && source_wallet.nil?
      errors.add(:source_wallet, "must exist for credit transaction")
    elsif transaction_type == 'debit' && target_wallet.nil?
      errors.add(:target_wallet, "must exist for debit transaction")
    end
  end

  def update_wallets_balance
    ActiveRecord::Base.transaction do
      source_wallet.update!(balance: source_wallet.balance - amount) if source_wallet
      target_wallet.update!(balance: target_wallet.balance + amount) if target_wallet
    end
  end
end
