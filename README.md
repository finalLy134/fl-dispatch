# fl-activeofficers
Event-Based Advanced QBCore Active Officers,
Originally Made by NevoG,
Link to old script [here](https://forum.cfx.re/t/release-fivem-advanced-active-officers/1798459).

Need Help? My Discord: finalLy#1138

**Requirements:**
- qb-core
- qb-policejob
- pma-voice

**Code Changes Requirements:**

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

**Keybinds:**
- F3 - Open Active Officers List - Changeable in the `config.lua`

**Config:**

- The toggle key is configurable in the `config.lua`.
- The callsign colors and prefixes are configurable in the `colors.json`.

**Configure Colors and Prefixes:**

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

**Commands:**
- /plist 0 - Drag Menu
- /plist - Toggle Menu
- /callsign `[callsign]` - To set your callsign (QBCore Command)

**Preview:**

![fl-activeofficers-preview](https://github.com/finalLy134/fl-activeofficers/assets/60448180/f9345bbf-a1d7-4929-92ad-e4490b4b69c9)
