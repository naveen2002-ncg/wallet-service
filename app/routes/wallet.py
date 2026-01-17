from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.repositories.wallet_repository import WalletRepository

wallet_bp = Blueprint('wallet', __name__)

@wallet_bp.route('', methods=['GET'])
@jwt_required()
def get_wallet():
    try:
        user_id = get_jwt_identity()
        wallet = WalletRepository.get_wallet_by_user_id(user_id)
        
        if not wallet:
            return jsonify({"error": "Wallet not found"}), 404

        return jsonify({"balance": float(wallet.balance)}), 200

    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500
