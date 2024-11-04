import os
import subprocess
from datetime import datetime
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# Configuration
SERVICE_ACCOUNT_FILE = os.path.expanduser('~/.ssh/google-credentials.json')
SCOPES = ['https://www.googleapis.com/auth/drive.file']
SOURCE_DIR = os.path.expanduser("~/Library/Group Containers/group.com.apple.notes")
TIMESTAMP = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
ARCHIVE_FILENAME = f"group.com.apple.notes_backup_{TIMESTAMP}.tar.gz"
FOLDER_ID = '1HOK6bczhiEjhnbmu1rGzspa3KagTACiy' # Replace with your specific Google Drive folder ID

def authenticate_gdrive():
    creds = service_account.Credentials.from_service_account_file(CREDENTIALS_FILE, scopes=SCOPES)
    return build('drive', 'v3', credentials=creds)

# Compress the entire directory using tar
def create_tar_gz(source_dir, tar_filename):
    subprocess.run(['tar', '--no-xattrs', '-czf', tar_filename, '-C', os.path.dirname(source_dir), os.path.basename(source_dir)], check=True)

# Upload to Google Drive
def upload_to_gdrive(file_name):
    drive_service = authenticate_gdrive()
    file_metadata = {
        'name': file_name,
        'parents': [FOLDER_ID]
    }
    media = MediaFileUpload(file_name, mimetype='application/gzip')
    file = drive_service.files().create(body=file_metadata, media_body=media, fields='id').execute()
    print(f"File uploaded to Google Drive with ID: {file.get('id')}")

# Run the backup and upload
if os.path.exists(SOURCE_DIR):
    print(f"Backing up {SOURCE_DIR} as {ARCHIVE_FILENAME}...")
    create_tar_gz(SOURCE_DIR, ARCHIVE_FILENAME)
    upload_to_gdrive(ARCHIVE_FILENAME)
    os.remove(ARCHIVE_FILENAME)
    print("Backup complete.")
else:
    print("Source file does not exist.")
