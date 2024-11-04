import os
import zipfile
from datetime import datetime
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# Google Drive API setup
SCOPES = ['https://www.googleapis.com/auth/drive.file']
CREDENTIALS_FILE = '/Users/lkosak/google-credentials.json'  # Path to your credentials.json

def authenticate_gdrive():
    creds = service_account.Credentials.from_service_account_file(CREDENTIALS_FILE, scopes=SCOPES)
    return build('drive', 'v3', credentials=creds)

# Define source and backup paths
SOURCE_FILE = os.path.expanduser("~/Library/Group Containers/group.com.apple.notes")
TIMESTAMP = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
ZIP_FILENAME = f"group.com.apple.notes_backup_{TIMESTAMP}.zip"
FOLDER_ID = '1HOK6bczhiEjhnbmu1rGzspa3KagTACiy'  # Replace with your specific Google Drive folder ID

# Compress the file
with zipfile.ZipFile(ZIP_FILENAME, 'w') as zipf:
    zipf.write(SOURCE_FILE, arcname=os.path.basename(SOURCE_FILE))

# Upload to Google Drive
def upload_to_gdrive(file_name):
    drive_service = authenticate_gdrive()
    file_metadata = {
        'name': file_name,
        'parents': [FOLDER_ID],
        'mimeType': 'application/zip'
    }
    media = MediaFileUpload(file_name, mimetype='application/zip')
    file = drive_service.files().create(body=file_metadata, media_body=media, fields='id').execute()
    print(f"File uploaded to Google Drive with ID: {file.get('id')}")

# Run the backup and upload
if os.path.exists(SOURCE_FILE):
    print(f"Backing up {SOURCE_FILE} as {ZIP_FILENAME}...")
    upload_to_gdrive(ZIP_FILENAME)
    os.remove(ZIP_FILENAME)  # Optionally delete the local zip file after upload
    print("Backup complete.")
else:
    print("Source file does not exist.")
