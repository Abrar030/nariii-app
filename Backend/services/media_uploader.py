import os
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = 'media'

def upload_file_locally(file, filename, content_type=None):
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)
    
    safe_filename = secure_filename(filename)
    file_path = os.path.join(UPLOAD_FOLDER, safe_filename)
    file.save(file_path)

    # Return a URL to access the file
    return f"http://localhost:5000/media/{safe_filename}"
