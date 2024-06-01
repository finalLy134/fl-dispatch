# fl-dispatch

Event-Based Advanced QBCore Job Dispatch / 10-System,
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

- /dispatch 0 - Drag Menu
- /dispatch - Toggle Menu
- /callsign `[callsign]` - To set your callsign (QBCore Command)

## Configuration

### How can I add another job?
This is a frequently asked question, and the answer is simple. For this example, we'll add job support for `beanmachine`.

#### 1. Head to `config.lua`
Add your new job to the `Config.Jobs` table. It should look like this:
```lua
Config.Jobs = { "police", "ambulance", "taxi", "beanmachine" }
```

#### 2. Head to `colors.json`
Add the colors for your `beanmachine` job. Copy the format of the `ambulance` job or any other job and modify as needed.
We would to modify the job's **name**, **label** and **colors**:
```lua
"beanmachine": {
      "label": "Active Beanmachine Workers",
      "colors": {
        "backgroundColor": "#682900",
        "foregroundColor": "white"
      },
      "ranges": [
        {
          "start": 1,
          "end": 19,
          "colors": {
            "backgroundColor": "#003F68",
            "foregroundColor": "white"
          }
        },
        {
          "start": 31,
          "end": 39,
          "colors": {
            "backgroundColor": "#6F5900",
            "foregroundColor": "white"
          }
        }
      ],
      "special": [
        {
          "prefix": "W",
          "colors": {
            "backgroundColor": "#50008F",
            "foregroundColor": "white"
          }
        }
      ]
    }
```
Feel free to edit until you get the desired result. If you encounter any issues, you can copy the original content from the source code or contact me for assistance.

## Preview

![fl-dispatch-preview](https://github.com/finalLy134/fl-dispatch/assets/60448180/f9345bbf-a1d7-4929-92ad-e4490b4b69c9)

## License

This project is under MIT license. See the file [LICENSE](LICENSE) for more details.
