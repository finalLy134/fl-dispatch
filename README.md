# fl-dispatch

Event-Based Advanced QBCore Job Dispatch,
Originally Made by NevoG,
Link to old script [here](https://forum.cfx.re/t/release-fivem-advanced-active-officers/1798459).

## Support

<table>
    <tr>
        <th>Personal Account</th>
        <td><img src="https://dcbadge.limes.pink/api/shield/311897788206153730" alt="" /></td>
    </tr>
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

- F3 - Open Active Officers List - Configurable in the `config.lua`

## Commands

- /plist 0 - Drag Menu
- /plist - Toggle Menu
- /callsign `[callsign]` - To set your callsign (QBCore Command)

## Configuration

The colors and prefixes are configurable in the `colors.json`.

### Default Colors

In order to change the default colors simply change the `backgroundColor` `foregroundColor` as you wish.

```json
"defaultColors": {
    "backgroundColor": "rgb(47, 69, 86)",
    "foregroundColor": "white"
},
```

### Special Colors

In order to change the special colors simply change the `prefix` `backgroundColor` `foregroundColor` as you wish.
To add more special colors, simply copy and paste as shown.

```json
"special": [
  { # Start copying from this line
    "prefix": "S",
    "colors": {
      "backgroundColor": "red",
      "foregroundColor": "white"
    }
  }, # End copying here
  + Paste New
]
```

### Callsign Ranges

In order to change the callsign ranges colors simply change the `start` `end` `backgroundColor` `foregroundColor` as you wish.
To add more callsign ranges colors, simply copy and paste as shown.

```json
"ranges": [
      { # Start copying from this line
        "start": 200,
        "end": 210,
        "colors": {
          "backgroundColor": "rgb(235, 1, 2)",
          "foregroundColor": "white"
        }
      }, # End copying here
      + Paste New
  ]
```

## Preview

![fl-dispatch-preview](https://github.com/finalLy134/fl-dispatch/assets/60448180/f9345bbf-a1d7-4929-92ad-e4490b4b69c9)

## License

This project is under MIT license. See the file [LICENSE](LICENSE) for more details.
