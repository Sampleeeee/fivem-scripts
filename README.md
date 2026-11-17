# fivem-scripts

Small FiveM (GTA V multiplayer) server scripts I wrote for a roleplay server, Florida State Roleplay, around 2021–2022. Mostly Lua, one in C#. Each folder is one FiveM resource.

**Status: not maintained.** They ran on a live server, but they were written for that one server and I have not touched them since. They are here as a record of the work, not as drop-in resources.

## Scripts

| Folder | What it does |
|---|---|
| `sample_clockin` | Police and fire clock in and out at markers inside their stations. Clocking in as police hands out a duty loadout. On-duty state is stored in a state bag so other scripts can read it. Also adds a `/911` command and on-duty map blips. |
| `sample_compass` | HUD next to the minimap: compass heading, street name, zone and in-game time. |
| `sample_cooldown` | Staff commands for "priority" status (on hold, cooldown countdown, restart countdown) and the current area of play (AOP), shown on every player's HUD. Can disable PvP while a hold is active. Permissions by Discord role or ACE. Optional Discord webhook logging. |
| `sample_death` | Replaces automatic respawn: a dead player presses a key to revive in place or respawn. Also a hold-to-ragdoll key. |
| `sample_jail` | `/jail <id> <seconds>` and `/hospitalize <id> <seconds>` for police and fire, with an on-screen timer, plus `/release`. |
| `sample_k9` | Menu for players using the police dog model: dog animations and a "door popper" that opens the rear door of a chosen vehicle. Includes a joke `/shit` command. |
| `sample_logs` | Logs connects, disconnects, chat, deaths and kills (with weapon, vehicle and seat) as Discord embeds, and writes session times to MySQL. |
| `sample_nearestpostal` | Shows the nearest postal code on the HUD. `/postal <code>` sets a waypoint. Exports the lookup for other scripts. |
| `sample_propmenu` | C# menu (F5) for placing and removing traffic props such as cones and barriers, with a preview before placing. |
| `sample_radio` | Police radio animation while the radio key is held: shoulder mic or handheld radio prop, toggled with `/tpolicehh`. |
| `sample_rpchat` | Roleplay chat. Commands such as `/me` are defined in one config table (proximity or global, range, prefix, colour). Out-of-character chat, `/whois`, emoji shortcodes, optional Discord webhook logging. |
| `sample_scoreboard` | Hold-to-show player list (NUI page) with each player's rank, taken from their Discord roles. |
| `sample_speedlimit` | Shows the speed limit of the current street on the HUD, from a table of street names, and a key that caps the vehicle at that limit. |
| `sample_vehicle_whitelist` | Server-side check when a player gets into a driver's seat: police and fire vehicles need the player to be clocked in, others need a Discord role or supporter tier. |
| `sample_voice` | HUD line with the current voice range (whisper, normal, yell) and whether the player is speaking. Reads the `proximity` state bag set by the voice resource. |
| `sample_util` | Shared helper: looks up a player's Discord roles through the Discord API, caches them and maps roles to ACE permissions. **This is an older copy** (April 2021), see below. |

## Running them

They will not all run as they are.

- Copy a folder into a FiveM server's `resources` directory and add `ensure <folder>` to `server.cfg`. The folder names matter: events and exports use them.
- Most scripts call exports from `sample_util` (`IsRolePresent`, `IsCop`, `IsFire`, `GetHudColor`, `DrawTextRightOfMinimap`, `FireWebhook` and others). The copy of `sample_util` in this repository is an earlier version that only has `GetRoles`, `IsRolePresent`, `IsCop` and `GetAllCops`. The later version was not kept, so scripts that need the other exports will error until those are written.
- `sample_util` needs a Discord bot token, guild ID and role IDs in its `config.lua`.
- `sample_logs` needs [mysql-async](https://github.com/brouznouf/fivem-mysql-async) and a `playertime` table, which is not included. `sample_clockin` loads mysql-async in its manifest but does not use it.
- `sample_death` and `sample_jail` use the stock `spawnmanager` resource. `sample_rpchat` uses the stock `chat` resource.
- `sample_rpchat` and `sample_cooldown` read their Discord webhook from a server convar: `set sample_rpchat_webhook "..."` and `set sample_cooldown_webhook "..."`. With no value set, they skip logging.
- `sample_propmenu` has to be built first (Visual Studio, .NET Framework, with the CitizenFX client library and [MenuAPI](https://github.com/TomGrobbe/MenuAPI)). Its `fxmanifest.lua` expects the output in `bin/Debug`.
- Server-specific values (role names, vehicle lists, station coordinates, the server name) are hard-coded in the scripts and config files.

## Code that is not mine

- `sample_k9/cl_NativeUI.lua` is the [NativeUILua](https://github.com/FrazzIe/NativeUILua) menu library.
- The postal code table in `sample_nearestpostal/sh_config.lua` is the postal map data commonly shipped with the community `nearest-postal` resource.
- `sample_scoreboard` started from an existing FiveM `scoreboard` resource.

## History

These were 15 separate repositories, each with a single commit. They were merged here in November 2026 without their history. Hard-coded Discord webhook URLs were replaced with convars, build output was removed from `sample_propmenu`, and unused font files were removed from `sample_scoreboard`.
