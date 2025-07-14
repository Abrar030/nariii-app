from flask import Flask
from flask_cors import CORS
from extensions import db, jwt, mail # Removed 'migrate' from this import
from config import Config
from routes import register_routes
from flask_migrate import Migrate # Added new import for the Migrate class
from flask import send_from_directory
import os

app = Flask(__name__)
app.config.from_object(Config)
CORS(app)

# Init extensions
db.init_app(app)
jwt.init_app(app)
migrate = Migrate(app, db) # Changed initialization to direct instantiation
mail.init_app(app)

# Route to serve uploaded media files
@app.route('/media/<filename>')
def serve_media_file(filename):
    return send_from_directory('media', filename)

# Register all API routes
register_routes(app)

@app.route('/')
def home(): 
    return {'message': 'NARIII API is running 🚨'}

if __name__ == '__main__':
    with app.app_context():
        db.create_all()

    app.run(host='127.0.0.1', port=5000, debug=True)

    
