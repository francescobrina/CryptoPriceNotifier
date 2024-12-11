# CryptoPriceNotifier

CryptoPriceNotifier is a PowerShell script that monitors the price of Bitcoin (BTC) using the CoinGecko API and displays a notification window when the price exceeds a specified threshold.

## Features

- Retrieves the current price of Bitcoin (BTC) from the CoinGecko API.
- Displays a notification window when the price exceeds a user-defined threshold.
- Continuously monitors the price at regular intervals (every 60 seconds by default).

## Prerequisites

- Windows PowerShell
- Internet connection

## Usage

1. Clone or download the repository to your local machine.
2. Open the `CryptoPriceNotifier.ps1` file in a text editor.
3. Modify the `$apiUrl` variable if you want to monitor a different cryptocurrency.
4. Set your desired price threshold by changing the value of the `$threshold` variable.
5. Save the changes.
6. Open PowerShell and navigate to the directory containing the `CryptoPriceNotifier.ps1` file.
7. Run the script using the following command:
    ```powershell
    .\CryptoPriceNotifier.ps1
    ```

## Example

To monitor the price of Bitcoin (BTC) and get notified when it exceeds $100,000 USD, set the `$threshold` variable to `100000` and run the script.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Acknowledgements

- CoinGecko API for providing cryptocurrency price data.
- Microsoft for the PowerShell scripting language and WPF framework.
