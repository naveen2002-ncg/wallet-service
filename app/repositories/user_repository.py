from app.db import db
from app.models.user import User
from app.models.wallet import Wallet

class UserRepository:
    @staticmethod
    def create_user(email: str, password_hash: str) -> User:
        """Create a new user and their wallet."""
        user = User(email=email, password_hash=password_hash)
        db.session.add(user)
        db.session.flush()  # Get user.id
        
        # Create wallet for user
        wallet = Wallet(user_id=user.id, balance=0.00)
        db.session.add(wallet)
        db.session.commit()
        
        return user

    @staticmethod
    def get_user_by_email(email: str) -> User:
        """Get user by email."""
        return User.query.filter_by(email=email).first()

    @staticmethod
    def get_user_by_id(user_id) -> User:
        """Get user by ID."""
        return User.query.get(user_id)
