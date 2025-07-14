from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from extensions import db
from models.community import Community, CommunityPost, CommunityComment

community_bp = Blueprint('community', __name__)

@community_bp.route('/', methods=['GET'])
@jwt_required()
def get_communities():
    communities = Community.query.all()
    return jsonify([{'id': c.id, 'name': c.name, 'description': c.description} for c in communities])

@community_bp.route('/post', methods=['POST'])
@jwt_required()
def create_post():
    user_id = get_jwt_identity()
    data = request.get_json()
    post = CommunityPost(
        community_id=data.get('community_id'),
        user_id=user_id,
        content=data.get('content')
    )
    db.session.add(post)
    db.session.commit()

    return jsonify({'message': 'Post created'}), 201
