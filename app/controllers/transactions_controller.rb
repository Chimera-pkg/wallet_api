class TransactionsController < ApplicationController
  # GET /transactions
  def index
    transactions = Transaction.all
    render json: transactions
  end

  # GET /transactions/:id
  def show
    transaction = Transaction.find_by(id: params[:id])
    if transaction
      render json: transaction
    else
      render json: { error: "Transaction not found" }, status: :not_found
    end
  end

  # POST /transactions
  def create
    # Extract parameters from the request
    transaction_params = params.require(:transaction).permit(:source_wallet_id, :target_wallet_id, :amount, :transaction_type)

    # Find the source and target wallets
    source_wallet = Wallet.find_by(id: transaction_params[:source_wallet_id])
    target_wallet = Wallet.find_by(id: transaction_params[:target_wallet_id])

    # Handle deposit (credit)
    if transaction_params[:transaction_type] == 'credit'
      if target_wallet.nil?
        return render json: { error: "Target wallet not found" }, status: :not_found
      end

      ActiveRecord::Base.transaction do
        target_wallet.update!(balance: target_wallet.balance + transaction_params[:amount].to_f)
        Transaction.create!(
          source_wallet: nil,
          target_wallet: target_wallet,
          amount: transaction_params[:amount],
          transaction_type: 'credit'
        )
      end

    # Handle withdrawal (debit)
    elsif transaction_params[:transaction_type] == 'debit'
      if source_wallet.nil?
        return render json: { error: "Source wallet not found" }, status: :not_found
      elsif source_wallet.balance < transaction_params[:amount].to_f
        return render json: { error: "Insufficient funds in source wallet" }, status: :unprocessable_entity
      end

      ActiveRecord::Base.transaction do
        source_wallet.update!(balance: source_wallet.balance - transaction_params[:amount].to_f)
        Transaction.create!(
          source_wallet: source_wallet,
          target_wallet: nil,
          amount: transaction_params[:amount],
          transaction_type: 'debit'
        )
      end

    # Handle transfer between wallets
    elsif transaction_params[:transaction_type] == 'transfer'
      if source_wallet.nil? || target_wallet.nil?
        return render json: { error: "Source or target wallet not found" }, status: :not_found
      elsif source_wallet.balance < transaction_params[:amount].to_f
        return render json: { error: "Insufficient funds in source wallet" }, status: :unprocessable_entity
      end

      ActiveRecord::Base.transaction do
        source_wallet.update!(balance: source_wallet.balance - transaction_params[:amount].to_f)
        target_wallet.update!(balance: target_wallet.balance + transaction_params[:amount].to_f)
        Transaction.create!(
          source_wallet: source_wallet,
          target_wallet: target_wallet,
          amount: transaction_params[:amount],
          transaction_type: 'transfer'
        )
      end

    else
      return render json: { error: "Invalid transaction type" }, status: :unprocessable_entity
    end

    # If transaction is successful
    render json: { message: 'Transaction successful' }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
