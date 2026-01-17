from app.db import db
from app.models.transaction import Transaction
from decimal import Decimal

class TransactionRepository:
    @staticmethod
    def create_transaction(wallet_id, transaction_type: str, amount: Decimal) -> Transaction:
        """Create a new transaction."""
        transaction = Transaction(
            wallet_id=wallet_id,
            type=transaction_type,
            amount=amount
        )
        db.session.add(transaction)
        db.session.commit()
        return transaction

    @staticmethod
    def get_transactions_by_wallet_id(wallet_id, limit: int = None):
        """Get all transactions for a wallet."""
        query = Transaction.query.filter_by(wallet_id=wallet_id).order_by(Transaction.created_at.desc())
        if limit:
            query = query.limit(limit)
        return query.all()
