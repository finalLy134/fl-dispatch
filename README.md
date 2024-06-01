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

- ### How can I add another job?
This is a frequently asked question, and the answer to this is pretty simple.
For the sake of this example, I want to add job support for `beanmachine` which is a job in my server.

#### 1. Head to `config.lua`
Here, we would want to head to `Config.Jobs` and add our new job to the table of jobs that are already in there.
Mine looks like this now:
```lua
Config.Jobs = { "police", "ambulance", "taxi", "beanmachine" }
```

#### 2. Head to `colors.json`
In this file we would want to add the colors for our `beanmachine` job.
We don't want to start writing all of the different colors from scratch. And that's why we can just copy the "template" of how other colors are created for other jobs.
I will copy the format of the `ambulance` job:
```lua
"ambulance": {
      "label": "Active EMS",
      "colors": {
        "backgroundColor": "red",
        "foregroundColor": "white"
      },
      "ranges": [
        {
          "start": 1,
          "end": 19,
          "colors": {
            "backgroundColor": "#2e54d1",
            "foregroundColor": "white"
          }
        },
        {
          "start": 31,
          "end": 39,
          "colors": {
            "backgroundColor": "#2e54d1",
            "foregroundColor": "white"
          }
        },
        {
          "start": 21,
          "end": 29,
          "colors": {
            "backgroundColor": "#10a9ef",
            "foregroundColor": "white"
          }
        },
        {
          "start": 91,
          "end": 99,
          "colors": {
            "backgroundColor": "#AB1150",
            "foregroundColor": "white"
          }
        }
      ],
      "special": [
        {
          "prefix": "A",
          "colors": {
            "backgroundColor": "#11ab6c",
            "foregroundColor": "white"
          }
        },
        {
          "prefix": "DELTA",
          "colors": {
            "backgroundColor": "#FF9700",
            "foregroundColor": "white"
          }
        },
        {
          "prefix": "OMEGA",
          "colors": {
            "backgroundColor": "#EF5610",
            "foregroundColor": "white"
          }
        },
        {
          "prefix": "PD",
          "colors": {
            "backgroundColor": "#DE212A",
            "foregroundColor": "white"
          }
        }
      ]
    }
```
Now we would want to change the job name, label and from here we are free to modify the colors as we wish.
This is what I have done:
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
Feel free to edit it as you wish until you get the result you like.
If you have a problem with the code or you're stuck with something, feel free to copy the original content from the source code here or contact me and I will be more than happy to help you.

## Preview

![fl-dispatch-preview](https://github.com/finalLy134/fl-dispatch/assets/60448180/f9345bbf-a1d7-4929-92ad-e4490b4b69c9)

## License

This project is under MIT license. See the file [LICENSE](LICENSE) for more details.
