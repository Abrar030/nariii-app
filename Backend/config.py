import os

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URI', 'postgresql://postgres:afifa%40123@localhost:5432/nariii_ab')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'super-secret-key')

    # AWS S3
    S3_BUCKET = os.getenv('S3_BUCKET', 'your-bucket-name')
    S3_KEY = os.getenv('S3_KEY', 'your-access-key')
    S3_SECRET = os.getenv('S3_SECRET', 'your-secret-key')
    S3_REGION = os.getenv('S3_REGION', 'us-east-1')

    # Mail
    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 587
    MAIL_USE_TLS = True
    MAIL_USERNAME = os.getenv('MAIL_USERNAME')
    MAIL_PASSWORD = os.getenv('MAIL_PASSWORD')
    MAIL_DEFAULT_SENDER = os.getenv('MAIL_DEFAULT_SENDER', os.getenv('MAIL_USERNAME'))

    # Local Media Upload
    UPLOAD_FOLDER = 'media' # Relative path, will be joined with app.root_path
