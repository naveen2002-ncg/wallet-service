from decimal import Decimal
from app.repositories.wallet_repository import WalletRepository
from app.repositories.transaction_repository import TransactionRepository

class TransactionService:
    @staticmethod
    def credit_money(user_id, amount: Decimal) -> dict:
        """Credit money to user's wallet."""
        wallet = WalletRepository.get_wallet_by_user_id(user_id)
        if not wallet:
            raise ValueError("Wallet not found")

        new_balance = float(wallet.balance) + float(amount)
        WalletRepository.update_balance(wallet, new_balance)
        TransactionRepository.create_transaction(wallet.id, "credit", amount)

        return {
            "message": "Amount credited successfully",
            "new_balance": float(wallet.balance)
        }

    @staticmethod
    def debit_money(user_id, amount: Decimal) -> dict:
        """Debit money from user's wallet."""
        wallet = WalletRepository.get_wallet_by_user_id(user_id)
        if not wallet:
            raise ValueError("Wallet not found")

        current_balance = float(wallet.balance)
        if current_balance < float(amount):
            raise ValueError("Insufficient balance")

        new_balance = current_balance - float(amount)
        WalletRepository.update_balance(wallet, new_balance)
        TransactionRepository.create_transaction(wallet.id, "debit", amount)

        return {
            "message": "Amount debited successfully",
            "new_balance": float(wallet.balance)
        }

    @staticmethod
    def get_transaction_history(user_id):
        """Get transaction history for user's wallet."""
        wallet = WalletRepository.get_wallet_by_user_id(user_id)
        if not wallet:
            raise ValueError("Wallet not found")

        transactions = TransactionRepository.get_transactions_by_wallet_id(wallet.id)
        
        return [
            {
                "id": str(t.id),
                "type": t.type,
                "amount": float(t.amount),
                "created_at": t.created_at.isoformat()
            }
            for t in transactions
        ]
