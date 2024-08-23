class Api::ProfileController < Api::BaseController
  def check_balance
    wallet = Wallet.find_by(wallet_address: params[:wallet_address])
    if wallet.present?
      render json: { balance: wallet.total_book }
    else
      render json: { error: "Wallet not found." }
    end
  end

  def all_profile
    users_with_wallet = User
      .joins("JOIN wallets ON (walletable_id = users.id AND walletable_type = 'User')")
      .joins("LEFT JOIN transaction_books ON wallets.id = transaction_books.wallet_id")
      .select("users.name, users.email, wallets.wallet_address, (COALESCE(SUM(transaction_books.debit), 0) - COALESCE(SUM(transaction_books.credit), 0)) as book_balance")
      .group("users.id, wallets.id")

    teams_with_wallet = Team
      .joins("JOIN wallets ON (walletable_id = teams.id AND walletable_type = 'Team')")
      .joins("LEFT JOIN transaction_books ON wallets.id = transaction_books.wallet_id")
      .select("teams.name, wallets.wallet_address, (COALESCE(SUM(transaction_books.debit), 0) - COALESCE(SUM(transaction_books.credit), 0)) as book_balance")
      .group("teams.id, wallets.id")
    render json: { 
      users: users_with_wallet,
      teams: teams_with_wallet
    }
  end
end
