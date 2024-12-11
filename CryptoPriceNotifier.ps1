# Import the necessary assemblies for WPF
Add-Type -AssemblyName PresentationFramework

# CoinGecko API for retrieving cryptocurrency prices
$apiUrl = "https://api.coingecko.com/api/v3/simple/price?ids=btc&vs_currencies=usd" # Modify the end of the URL to get the price of your desired cryptocurrency

# Price threshold
$threshold = 100000 # You can edit this value to set your own threshold

# Variable to keep track of the price being above the threshold
$priceAboveThreshold = $false

# Function to get the current price of the cryptocurrency
function Get-CryptoPrice {
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get
        return [double]$response.btc.usd
    }
    catch {
        Write-Output "Error retrieving the price: $_"
        return $null
    }
}

# Function to show the notification window
function Show-NotificationWindow($title, $message) {
    [xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
        Title="$title" Height="150" Width="400" WindowStartupLocation="CenterScreen" Topmost="True" ResizeMode="NoResize" WindowStyle="ToolWindow">
    <Grid Background="#333">
        <TextBlock Text="$message" VerticalAlignment="Center" HorizontalAlignment="Center" TextWrapping="Wrap" FontSize="18" Foreground="White" TextAlignment="Center" Margin="10"/>
    </Grid>
</Window>
"@

    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)
    $window.ShowDialog() | Out-Null
}

# Monitoring loop
while ($true) {
    $price = Get-CryptoPrice
    if ($price -ne $null) {
        Write-Output "$(Get-Date): Current price of BTC: $price USD"
        if ($price -ge $threshold -and -not $priceAboveThreshold) {
            # Show notification window
            $title = "BTC is rising!"
            $message = "The price of BTC has exceeded $threshold USD and is now $price USD."
            Show-NotificationWindow $title $message
            Write-Output "Notification window shown: price above the threshold."
            $priceAboveThreshold = $true
        }
        elseif ($price -lt $threshold -and $priceAboveThreshold) {
            # Update the state when the price falls below the threshold
            Write-Output "The price has fallen below the threshold."
            $priceAboveThreshold = $false
        }
    }
    else {
        Write-Output "Unable to retrieve the price. Retrying in 60 seconds."
    }
    # Wait 60 seconds before the next check
    Start-Sleep -Seconds 60
}


<#
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

#>
