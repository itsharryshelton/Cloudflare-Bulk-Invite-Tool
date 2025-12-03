# Cloudflare Invite Acceptor

A simple Python script to automatically scan for and accept pending Cloudflare account invitations using your Global API Key.

## Prereq

* Python 3.7+ installed on your machine.
* A Cloudflare Account.
* Global API Key

## Installation

1.  **Clone the repository** (or download the script):
    ```bash
    git clone [https://github.com/itsharryshelton/Cloudflare-Bulk-Invite-Tool.git)
    cd repo-name
    ```

2.  **Install the Cloudflare Python SDK**:
    ```bash
    pip install cloudflare
    ```

    More details on Cloudflare Python if you need it - https://pypi.org/project/cloudflare/

## Configuration

To keep your credentials safe, **do not hardcode them** in the script or delete after use. DO NOT SAVE YOUR GLOBAL API KEY SOMEWHERE UNSECURE!

### 1. Get your Credentials
1.  Go to the [Cloudflare Dashboard](https://dash.cloudflare.com/profile/api-tokens).
2.  Scroll to **API Keys**.
3.  Find **Global API Key** and click **View**.
4.  Copy the key.

Update below or swap to Envirs:
```bash
client = Cloudflare(
    api_email="harry@email.com", #Use your Cloudflare Email
    api_key="101010101010101" #Replace with your Global API Key - do not save this API anywhere, delete after!
)
```
