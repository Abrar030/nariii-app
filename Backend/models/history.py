from extensions import db
from datetime import datetime

class EmergencyHistory(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    sos_id = db.Column(db.Integer, db.ForeignKey('sos_request.id'))
    trigger_method = db.Column(db.String(50))
    contacts_notified = db.Column(db.Text)
    media_status = db.Column(db.String(50))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    user = db.relationship('User')
    sos_request = db.relationship('SOSRequest')
