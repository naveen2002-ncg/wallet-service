from flask_jwt_extended import create_access_token as jwt_create_access_token

def create_access_token(identity: str) -> str:
    """Create a JWT access token."""
    return jwt_create_access_token(identity=identity)
