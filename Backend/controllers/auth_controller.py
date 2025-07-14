from extensions import db
from flask_jwt_extended import create_access_token
from flask import jsonify
from models.user import User
import datetime


def register_user(req):
    data = req.get_json()
    full_name = data.get('full_name')
    email = data.get('email')
    phone = data.get('phone')
    password = data.get('password')

    if User.query.filter_by(email=email).first():
        return jsonify({'message': 'Email already registered'}), 409

    user = User(full_name=full_name, email=email, phone=phone)
    user.set_password(password)
    db.session.add(user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully'}), 201

def login_user(req):
    data = req.get_json()
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email).first()

    if not user or not user.check_password(password):
        return jsonify({'message': 'Invalid email or password'}), 401

    access_token = create_access_token(
        identity=user.id,
        expires_delta=datetime.timedelta(days=1)
    )

    return jsonify({'access_token': access_token, 'user': {
        'id': user.id,
        'full_name': user.full_name,
        'email': user.email
    }}), 200
