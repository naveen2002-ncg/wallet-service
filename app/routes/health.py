from flask import Blueprint, jsonify

health_bp = Blueprint('health', __name__)

@health_bp.route('/health', methods=['GET'])
def health():
    """Health check endpoint."""
    return jsonify({
        "status": "healthy",
        "service": "Wallet & Transaction Service",
        "version": "1.0.0"
    }), 200

@health_bp.route('', methods=['GET'])
def root():
    """API root endpoint - lists available endpoints."""
    return jsonify({
        "service": "Wallet & Transaction Service API",
        "version": "v1",
        "endpoints": {
            "auth": {
                "register": "POST /api/v1/auth/register",
                "login": "POST /api/v1/auth/login"
            },
            "wallet": {
                "get_balance": "GET /api/v1/wallet (requires JWT)"
            },
            "transactions": {
                "credit": "POST /api/v1/transactions/credit (requires JWT)",
                "debit": "POST /api/v1/transactions/debit (requires JWT)",
                "history": "GET /api/v1/transactions (requires JWT)"
            },
            "health": "GET /api/v1/health"
        }
    }), 200
