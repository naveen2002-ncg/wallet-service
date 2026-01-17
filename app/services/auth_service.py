from app.repositories.user_repository import UserRepository
from app.utils.hash import hash_password, verify_password
from app.utils.jwt import create_access_token

class AuthService:
    @staticmethod
    def register_user(email: str, password: str) -> dict:
        """Register a new user."""
        # Check if user exists
        existing_user = UserRepository.get_user_by_email(email)
        if existing_user:
            raise ValueError("User with this email already exists")

        # Hash password and create user
        password_hash = hash_password(password)
        user = UserRepository.create_user(email, password_hash)

        return {"message": "User registered successfully"}

    @staticmethod
    def login_user(email: str, password: str) -> dict:
        """Authenticate user and return JWT token."""
        user = UserRepository.get_user_by_email(email)
        if not user or not verify_password(password, user.password_hash):
            raise ValueError("Invalid email or password")

        access_token = create_access_token(str(user.id))
        return {"access_token": access_token}
