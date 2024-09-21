class Wallet < ApplicationRecord
  belongs_to :user
  has_many :sent_transactions, class_name: 'Transaction', foreign_key: :source_wallet_id
  has_many :received_transactions, class_name: 'Transaction', foreign_key: :target_wallet_id

  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
