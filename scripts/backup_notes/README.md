# Set up virtual pip environment:

```
python3 -m venv $HOME/local_python_env
```

#Activate the environment:

```
source $HOME/local_python_env/bin/activate
```

Install required packages:

```
pip install google-auth google-auth-oauthlib google-auth-httplib2 google-api-python-client zipfile36
```

# Set up a GCC Services Account:

Using a **service account** for Google Drive API access is a great option, especially if you’re building an automated process that doesn’t require user interaction. Here’s how to set up and use a service account to access Google Drive:

### Step 1: Set Up a Service Account in Google Cloud Console

1. **Go to the Google Cloud Console**:
   - Visit [https://console.cloud.google.com/](https://console.cloud.google.com/) and log in with your Google account.

2. **Select Your Project**:
   - Make sure you’re working within the project where you enabled the Google Drive API.

3. **Enable the Google Drive API (if not already enabled)**:
   - Go to **APIs & Services** > **Library**.
   - Search for **Google Drive API** and click on it.
   - Click **Enable** if it’s not already enabled for this project.

4. **Create a Service Account**:
   - Go to **IAM & Admin** > **Service Accounts** in the left sidebar.
   - Click **+ CREATE SERVICE ACCOUNT** at the top.
   - Enter a name (e.g., “Drive Backup Service Account”) and optionally a description, then click **Create and Continue**.

5. **Assign Permissions to the Service Account**:
   - For most Drive API needs, you don’t need to assign any additional roles or permissions at this stage. Just click **Continue** and then **Done** to finish setting up the service account.

6. **Create a JSON Key for the Service Account**:
   - In the **Service Accounts** page, find your newly created service account, click on it, then go to the **Keys** tab.
   - Click **ADD KEY** > **Create new key**.
   - Choose **JSON** and click **Create**. This will download a JSON file with the credentials for the service account. Move this file to your script directory and rename it to `service_account_credentials.json` (or whatever name you prefer).

### Step 2: Share the Google Drive Folder with the Service Account

1. **Find the Service Account Email**:
   - In the Google Cloud Console, locate the **Email** for your service account (it will look something like `your-service-account@your-project-id.iam.gserviceaccount.com`).

2. **Share the Folder in Google Drive**:
   - Go to [Google Drive](https://drive.google.com) and locate the folder you want the service account to access.
   - Right-click on the folder and select **Share**.
   - In the sharing settings, add the **service account email** as a **Viewer**, **Editor**, or whatever permission level is needed.
   - This step is essential; the service account needs permission to access the files in the folder.
