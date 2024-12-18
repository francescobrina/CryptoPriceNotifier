﻿# Import the necessary assemblies for WPF
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
