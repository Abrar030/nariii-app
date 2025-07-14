from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from extensions import db
from models.contact import TrustedContact

contact_bp = Blueprint('contacts', __name__)

@contact_bp.route('/', methods=['GET'])
@jwt_required()
def get_contacts():
    user_id = get_jwt_identity()
    contacts = TrustedContact.query.filter_by(user_id=user_id).all()
    return jsonify([{
        'id': c.id,
        'name': c.name,
        'email': c.email,
        'phone': c.phone,
        'relationship': c.relationship,
        'notify': c.notify
    } for c in contacts])

@contact_bp.route('/', methods=['POST'])
@jwt_required()
def add_contact():
    user_id = get_jwt_identity()
    data = request.get_json()

    contact = TrustedContact(
        user_id=user_id,
        name=data.get('name'),
        email=data.get('email'),
        phone=data.get('phone'),
        relationship=data.get('relationship'),
        notify=data.get('notify', True)
    )
    db.session.add(contact)
    db.session.commit()

    return jsonify({'message': 'Contact added'}), 201
