import MetaTrader5 as mt5

if not mt5.initialize():
    print("❌ Initialization failed")
    quit()

account = mt5.account_info()
if account is not None:
    print(f"✅ Connected to account #{account.login}")
else:
    print("❌ Could not fetch account info")

mt5.shutdown()
