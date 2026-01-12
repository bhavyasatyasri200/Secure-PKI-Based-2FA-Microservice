# scripts/log_2fa_cron.py
import sys
import os
from datetime import datetime
sys.path.append("/app")  # Make Python aware of the 'app' module

from app.totp_utils import generate_totp_code

SEED_FILE = "/data/seed.txt"        # Path to your seed file
LOG_FILE = "/cron/last_code.txt"    # Path for cron logs

def main():
    # Read seed
    if not os.path.exists(SEED_FILE):
        print("Seed file not found", flush=True)
        return

    with open(SEED_FILE, "r") as f:
        hex_seed = f.read().strip()

    # Generate 2FA code
    code = generate_totp_code(hex_seed)

    # Timestamp
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Log to file
    with open(LOG_FILE, "a") as f:
        f.write(f"{timestamp} - 2FA Code: {code}\n")

if __name__ == "__main__":
    main()
