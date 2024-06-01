# fl-dispatch

An Event-Based Advanced FiveM QBCore Job Dispatch / 10-System Script,

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

- F3 - Open Active Officers List

## Commands

- /dispatch 0 - Drag Menu
- /dispatch - Toggle Menu
- /callsign `[callsign]` - To set your callsign (QBCore Command)

## FAQ

### 1. How can I change the default keybinds?
Head to **`config.lua`** and under `Config.ToggleKey` change it to the key you desire.

Also, you can change it on the client-side (only for you) in the Game Settings.

### 2. How can I add another job?
This is a frequently asked question, and the answer is simple. For this example, we'll add job support for `beanmachine`.

### - Job Config Editor

Head to our FL-Dispatch Config Editor Repository right [here](https://finally134.github.io/).

And follow the steps there.

### - Manually

#### A. Head to `config.lua`
Add your new job to the `Config.Jobs` table. It should look like this:
```lua
Config.Jobs = { "police", "ambulance", "taxi", "beanmachine" }
```

#### B. Head to `colors.json`
Add the colors for your `beanmachine` job. Copy the format of the `ambulance` job or any other job and modify as needed.
We would want to modify the job's **name**, **label** and **different colors**:
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

### 3. It shows I have an update, how can I update the script without losing my config/colors modifications?
Simply save your current `colors.json` and `config.lua` somewhere in your computer.

Install the newer version of fl-dispatch, upload it to your server resources folder and drag the older config files into the newer version folder.
But of course, check if there was an update to the config files and if so include the newer text content into your older version ones.
And you're done, you have successfully updated fl-dispatch.

## Preview

![fl-dispatch-preview](https://github.com/finalLy134/fl-dispatch/assets/60448180/f9345bbf-a1d7-4929-92ad-e4490b4b69c9)

## License

This project is under MIT license. See the file [LICENSE](LICENSE) for more details.
