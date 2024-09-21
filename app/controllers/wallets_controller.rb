class WalletsController < ApplicationController
    def index
      wallets = Wallet.all
      render json: wallets
    end
  
    def show
      wallet = Wallet.find(params[:id])
      render json: wallet
    end
  end
  