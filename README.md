# Discord-Ban-Sync
## What is it? 
Discord-Ban-Sync is a highly advanced FiveM script that will let you rest assured knowing that those trolls that you banned from your discord won't go and troll your FiveM server. This script will check against your Discord ban list for the server of your choice using the Discord REST API. This script is highly optimized and works flawlessly. 

## Configuration 
```
Config = {
    Bot_Token = '', -- Your bot token from https://discord.com/developers/applications (See docs for more)
    Guild_ID = '', -- The ID for your guild (See docs for more)
    webhookURL = 'https://discord.com/api/webhooks/1049066583571570729/rfb624nc9ey6ny7oJPGcw1CiLwkPdRMo2L9aYi-jTAFIqwTUPL-20aM3hhDNSAu6nJNh', -- Webhook URL to send logs to
    ThereWasAnIssue = 'Sorry, there was an issue checking if you were banned... Please restart FiveM and if the issue persists contact the server owner.',
    steamNotOpen = 'You must have steam open in order to play on this server! Please open steam and relog!',
    blacklist = {
        enabled = false, -- Should the script enable blacklisting
        blacklistedRoles = {'123456789'} -- Array of role ID's that are not allowed to join the server
    }
}
```

## Acknowledgments
[Badger](https://github.com/jaredscar) - Created Badger Discord API 

## Photos
![](https://i.imgur.com/0Xn2uQG.png)
