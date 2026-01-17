from app.db import db
from sqlalchemy.dialects.postgresql import UUID
import uuid

class Transaction(db.Model):
    __tablename__ = 'transactions'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    wallet_id = db.Column(UUID(as_uuid=True), db.ForeignKey('wallets.id', ondelete='CASCADE'), nullable=False)
    type = db.Column(db.String(10), nullable=False)
    amount = db.Column(db.Numeric(12, 2), nullable=False)
    created_at = db.Column(db.DateTime, server_default=db.func.current_timestamp())

    __table_args__ = (
        db.CheckConstraint("type IN ('credit', 'debit')", name='check_transaction_type'),
        db.CheckConstraint("amount > 0", name='check_amount_positive'),
    )

    def __repr__(self):
        return f'<Transaction {self.id} - {self.type} {self.amount}>'
