# Cloudflare Invite Acceptor

Simple scripts (Python & PowerShell) to automatically scan for and accept pending Cloudflare account invitations using your Global API Key.

## Prereq

### General

* A Cloudflare Account.
* Global API Key (See Configuration section below).

### For Python Version
* Python 3.7+ installed on your machine.
* cloudflare python package

### For PowerShell Version

* Windows PowerShell 7
* No external module installation required.

More details on Cloudflare Python if you need it - https://pypi.org/project/cloudflare/

## Configuration

⚠️⚠️⚠️ SECURITY WARNING: The Global API Key provides full access to your account. Do not commit files containing your key to public repositories. If you hardcode credentials for testing, delete the script or the key immediately after use. ⚠️⚠️⚠️


### 1. Get your Credentials
1.  Go to the [Cloudflare Dashboard](https://dash.cloudflare.com/profile/api-tokens).
2.  Scroll to **API Keys**.
3.  Find **Global API Key** and click **View**.
4.  Copy the key.

## Option 1: Python

 **Install the Cloudflare Python SDK**:
    ```bash
    pip install cloudflare
    ```

Update below or swap to Envirs:
```bash
client = Cloudflare(
    api_email="harry@email.com", #Use your Cloudflare Email
    api_key="101010101010101" #Replace with your Global API Key - do not save this API anywhere, delete after!
)
```

## Option 2: PowerShell

* Open the script in an editor (VS Code, or ISE) and update the configuration block at the top:

```bash
# --- CONFIGURATION ---
$CF_EMAIL = "harry@email.com"      # Replace with your Cloudflare Email
$CF_KEY   = "101010101010101"      # Replace with your Global API Key
# ---------------------
```
If you get an error about ampersand character is not allowed, make sure you are running in PowerShell 7; this script was tested working within Visual Studio Code, not PowerShell 5/ISE
