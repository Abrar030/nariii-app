from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from extensions import db
from models.sos import SOSRequest
from datetime import datetime
from services.media_uploader import upload_file_locally
from services.mailer import send_sos_alert
from models.contact import TrustedContact
from models.user import User
# from services.notification_service import send_sos_notification # You can implement this later

# ✅ Declare your blueprint BEFORE using it
sos_bp = Blueprint('sos', __name__)

# 🚨 Upload SOS media (video/audio)
@sos_bp.route('/upload', methods=['POST'])
@jwt_required()
def upload_sos_media():
    user_id = get_jwt_identity()
    sos_id = request.form.get('sos_id')
    file = request.files.get('file')

    if not file:
        return {'error': 'No file provided'}, 400

    file_url = upload_file_locally(file, file.filename)


    sos = SOSRequest.query.get(sos_id)
    if not sos or sos.user_id != user_id:
        return {'error': 'SOS not found'}, 404

    sos.video_url = file_url
    sos.status = 'Sent'
    db.session.commit()

    return {'message': 'File uploaded', 'file_url': file_url}, 200

# ✅ Basic trigger SOS endpoint (no file upload)
@sos_bp.route('/trigger', methods=['POST'])
@jwt_required()
def trigger_sos():
    user_id = get_jwt_identity()
    description = request.form.get('description')  # 👈 from form-data
    file = request.files.get('file')  # 👈 from form-data

    file_url = None
    if file:
          file_url = upload_file_locally(file, file.filename)


    sos = SOSRequest(
        user_id=user_id,
        description=description,
        video_url=file_url,
        status="Sent"
    )
    db.session.add(sos)
    db.session.commit()

    # After saving SOS to DB, send email alerts
    contacts = TrustedContact.query.filter_by(user_id=user_id, notify=True).all()
    user = User.query.get(user_id)

    for contact in contacts:
        send_sos_alert(contact.email, user.full_name, description)

    return jsonify({
        "message": "SOS triggered and alerts sent",
        "sos_id": sos.id,
        "file_url": file_url
    }), 200
