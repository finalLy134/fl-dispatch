# fl-activeofficers
Event-Based Advanced QBCore Active Officers,
Originally Made by NevoG,
Link to old script [here](https://forum.cfx.re/t/release-fivem-advanced-active-officers/1798459).

## Support

<table>
    <tr>
        <th>Personal Account</th>
        <td><img src="https://dcbadge.limes.pink/api/shield/311897788206153730" alt="" /></td>
    </tr>
        <tr>
        <th>Discord Server</th>
        <td><a target="_blank" href="https://discord.gg/87MZnFQv9y"><img src="https://dcbadge.limes.pink/api/server/87MZnFQv9y" alt="" /></a></td>
    </tr>
</table>

## Requirements
- qb-core
- qb-policejob
- pma-voice

## Code Changes Requirements

Add this line at `qb-core/server/player.lua` line 272:

```lua
TriggerEvent('QBCore:Server:OnMetaDataUpdate', self.PlayerData.source, meta, val)
```

Your method should look like this:

```lua
function self.Functions.SetMetaData(meta, val)
    if not meta or type(meta) ~= 'string' then return end
    if meta == 'hunger' or meta == 'thirst' then
        val = val > 100 and 100 or val
    end
    self.PlayerData.metadata[meta] = val
    self.Functions.UpdatePlayerData()

    -- Triggering our event:
    TriggerEvent('QBCore:Server:OnMetaDataUpdate', self.PlayerData.source, meta, val)
end
```

## Keybinds
- F3 - Open Active Officers List - Changeable in the `config.lua`

## Configure Colors and Prefixes

The colors and prefixes are editable in the `colors.json`

- The default colors are changable here:
  ```json  
  "defaultColors": {
      "backgroundColor": "rgb(47, 69, 86)",
      "foregroundColor": "white"
  },
  ```
- The special colors (prefixes) are changable here:
  ```json
  "special": [
    {
      "prefix": "S",
      "colors": {
        "backgroundColor": "red",
        "foregroundColor": "white"
      }
    },
  ]
  ```
- The callsign ranges are changable here:
  ```json
  "ranges": [
        {
          "start": 200,
          "end": 210,
          "colors": {
            "backgroundColor": "rgb(235, 1, 2)",
            "foregroundColor": "white"
          }
        },
        {
          "start": 300,
          "end": 330,
          "colors": {
            "backgroundColor": "rgb(20, 10, 11)",
            "foregroundColor": "white"
          }
        }
    ]
  ```

## Commands
- /plist 0 - Drag Menu
- /plist - Toggle Menu
- /callsign `[callsign]` - To set your callsign (QBCore Command)

## Preview:

![fl-activeofficers-preview](https://github.com/finalLy134/fl-activeofficers/assets/60448180/f9345bbf-a1d7-4929-92ad-e4490b4b69c9)
