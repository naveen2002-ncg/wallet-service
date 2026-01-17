from app.db import db
from sqlalchemy.dialects.postgresql import UUID
import uuid

class Wallet(db.Model):
    __tablename__ = 'wallets'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = db.Column(UUID(as_uuid=True), db.ForeignKey('users.id', ondelete='CASCADE'), unique=True, nullable=False)
    balance = db.Column(db.Numeric(12, 2), nullable=False, default=0.00)
    updated_at = db.Column(db.DateTime, server_default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    # Relationship
    transactions = db.relationship('Transaction', backref='wallet', lazy=True, cascade='all, delete-orphan')

    def __repr__(self):
        return f'<Wallet {self.id} - Balance: {self.balance}>'
