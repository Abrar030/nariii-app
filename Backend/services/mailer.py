from flask_mail import Message
from flask import current_app
from extensions import mail

def send_sos_alert(recipient, user_name, message):
    subject = f"🚨 SOS Alert from {user_name}"
    body = f"{user_name} has triggered an SOS alert.\n\nMessage:\n{message}"

    # Flask-Mail will automatically use MAIL_DEFAULT_SENDER from the config
    msg = Message(subject=subject, recipients=[recipient], body=body)
    mail.send(msg)
