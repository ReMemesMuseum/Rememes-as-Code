from eth_account import Account

# Generate and print 9 new wallets in the format "address, private key"
for i in range(9):
    account = Account.create()
    print(f"{account.address},{account.key.hex()}")
