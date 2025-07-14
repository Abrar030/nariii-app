from flask import Blueprint, request, jsonify
from extensions import db
from models.user import User
from flask_jwt_extended import create_access_token

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data.get('email')
    phone = data.get('phone')

    if User.query.filter((User.email == email) | (User.phone == phone)).first():
        return jsonify({'error': 'User already exists'}), 400

    user = User(
        full_name=data.get('full_name'),
        email=email,
        phone=phone
    )
    user.set_password(data.get('password'))
    db.session.add(user)
    db.session.commit()

    return jsonify({'message': 'User created successfully'}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    user = User.query.filter_by(email=data.get('email')).first()

    if not user or not user.check_password(data.get('password')):
        return jsonify({'error': 'Invalid credentials'}), 401

    access_token = create_access_token(identity=str(user.id))  # 👈 cast to string
    return jsonify({'token': access_token}), 200
