from MetaTrader5 import initialize, shutdown, version

if initialize():
    print("✅ MT5 initialized successfully!")
    print("MT5 version:", version())
    shutdown()
else:
    print("❌ Failed to initialize MT5")
