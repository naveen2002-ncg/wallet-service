from flask import Blueprint, request, jsonify
from marshmallow import ValidationError
from app.schemas.auth import RegisterSchema, LoginSchema
from app.services.auth_service import AuthService

auth_bp = Blueprint('auth', __name__)

register_schema = RegisterSchema()
login_schema = LoginSchema()

@auth_bp.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        errors = register_schema.validate(data)
        if errors:
            return jsonify({"error": errors}), 400

        result = AuthService.register_user(data['email'], data['password'])
        return jsonify(result), 201

    except ValueError as e:
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        errors = login_schema.validate(data)
        if errors:
            return jsonify({"error": errors}), 400

        result = AuthService.login_user(data['email'], data['password'])
        return jsonify(result), 200

    except ValueError as e:
        return jsonify({"error": str(e)}), 401
    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500
