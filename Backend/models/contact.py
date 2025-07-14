from extensions import db
from werkzeug.security import generate_password_hash, check_password_hash


class TrustedContact(db.Model):  # ✅ Correct class
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120))
    phone = db.Column(db.String(20))
    relationship = db.Column(db.String(50))
    notify = db.Column(db.Boolean, default=True)

    user = db.relationship('User', backref=db.backref('contacts', lazy=True))

