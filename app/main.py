from flask import Flask
from flask_jwt_extended import JWTManager
from app.config import Config
from app.db import db

jwt = JWTManager()

def create_app():
    app = Flask(__name__, static_folder='static', static_url_path='')
    app.config.from_object(Config)

    db.init_app(app)
    jwt.init_app(app)

    # Import models after db initialization
    from app.models import user, wallet, transaction

    # Create tables (only if database is available)
    with app.app_context():
        try:
            db.create_all()
        except Exception as e:
            print(f"Warning: Could not create database tables: {e}")
            print("This is normal if PostgreSQL is not running or not configured yet.")

    from app.routes.auth import auth_bp
    from app.routes.wallet import wallet_bp
    from app.routes.transaction import transaction_bp
    from app.routes.health import health_bp

    app.register_blueprint(health_bp, url_prefix="/api/v1")
    app.register_blueprint(auth_bp, url_prefix="/api/v1/auth")
    app.register_blueprint(wallet_bp, url_prefix="/api/v1/wallet")
    app.register_blueprint(transaction_bp, url_prefix="/api/v1/transactions")

    @app.route('/')
    def index():
        return app.send_static_file('login.html')
    
    @app.route('/login.html')
    def login_page():
        return app.send_static_file('login.html')
    
    @app.route('/dashboard.html')
    def dashboard():
        return app.send_static_file('dashboard.html')

    return app

app = create_app()

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
