from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from decimal import Decimal
from marshmallow import ValidationError
from app.schemas.transaction import TransactionSchema
from app.services.transaction_service import TransactionService

transaction_bp = Blueprint('transaction', __name__)

transaction_schema = TransactionSchema()

@transaction_bp.route('/credit', methods=['POST'])
@jwt_required()
def credit():
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        errors = transaction_schema.validate(data)
        if errors:
            return jsonify({"error": errors}), 400

        amount = Decimal(str(data['amount']))
        result = TransactionService.credit_money(user_id, amount)
        return jsonify(result), 200

    except ValueError as e:
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500

@transaction_bp.route('/debit', methods=['POST'])
@jwt_required()
def debit():
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        errors = transaction_schema.validate(data)
        if errors:
            return jsonify({"error": errors}), 400

        amount = Decimal(str(data['amount']))
        result = TransactionService.debit_money(user_id, amount)
        return jsonify(result), 200

    except ValueError as e:
        if "Insufficient balance" in str(e):
            return jsonify({"error": str(e)}), 400
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500

@transaction_bp.route('', methods=['GET'])
@jwt_required()
def get_transactions():
    try:
        user_id = get_jwt_identity()
        transactions = TransactionService.get_transaction_history(user_id)
        return jsonify(transactions), 200

    except ValueError as e:
        return jsonify({"error": str(e)}), 404
    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500
