from app.db import db
from app.models.wallet import Wallet

class WalletRepository:
    @staticmethod
    def get_wallet_by_user_id(user_id) -> Wallet:
        """Get wallet by user ID."""
        return Wallet.query.filter_by(user_id=user_id).first()

    @staticmethod
    def update_balance(wallet: Wallet, new_balance: float) -> Wallet:
        """Update wallet balance."""
        wallet.balance = new_balance
        db.session.commit()
        return wallet
