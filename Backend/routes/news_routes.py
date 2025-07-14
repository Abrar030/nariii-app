from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required
from extensions import db
from models.news import NewsArticle

news_bp = Blueprint('news', __name__)

@news_bp.route('/', methods=['GET'])
@jwt_required()
def get_news():
    news = NewsArticle.query.order_by(NewsArticle.timestamp.desc()).all()
    return jsonify([{
        'id': n.id,
        'title': n.title,
        'url': n.url,
        'image_url': n.image_url,
        'timestamp': n.timestamp.isoformat()
    } for n in news])
