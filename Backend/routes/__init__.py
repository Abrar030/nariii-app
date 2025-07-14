from .auth_routes import auth_bp
from .sos_routes import sos_bp
from .contact_routes import contact_bp  # ✅ Add this if missing

def register_routes(app):
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(sos_bp, url_prefix='/api/sos')
    app.register_blueprint(contact_bp, url_prefix='/api/contacts')  # ✅ This must match
