from extensions import db
from datetime import datetime

class SOSRequest(db.Model):
    __tablename__ = 'sos_request'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    status = db.Column(db.String(50))
    video_url = db.Column(db.String)
    description = db.Column(db.String(300))

    user = db.relationship('User', backref=db.backref('sos_requests', lazy=True))
