# Project Evil — implementation notes

## Target and design

- Host: Project Zomboid, Build 42 mod layout.
- Mode: single-player first; gameplay state is stored on the player mod-data so mission logic is not tied to the HUD and can later be adapted to co-op.
- Opening mission: **The Village** — investigate, survive the opening, scavenge food plus medical supplies or ammunition, then clear five nearby threats.
- Current prototype uses Project Zomboid's native world, inventory, and zombie simulation. It does not yet replace the map with RE4 geometry, add genuine Ganado models/AI, or ship RE4 weapons/assets.

## Install

Copy the `42` directory into a Project Zomboid user mods directory as a folder named `ProjectEvil`, then enable **Project Evil - The Village** in the Mods menu. For a Workshop/Melty package, preserve the version folder and metadata expected by the target game and platform.

## First-slice loop

1. Start a new or existing single-player world and enable the mod.
2. The mission HUD introduces Leon's opening objective.
3. After the opening survival beat, the mission asks for scavenged food and either medical supplies or ammunition.
4. The next phase tracks nearby zombie deaths; clearing five completes the opening and marks the next objective unlocked.
5. Mission state is stored in player mod-data, independent of the HUD.

## Known prototype limitations

- The HUD labels the campaign's protagonist as Leon, but this prototype does not yet replace the player model/clothing with authentic Leon assets.
- The opening is implemented as mission state over a Project Zomboid world, not a bespoke recreation of the RE4 village map or a scripted RE4-accurate horde.
- The opening delay currently uses player-update ticks and must be tuned against real gameplay; the five-threat counter observes zombie deaths within a radius and is not yet kill-credit secure.
- Authentic RE4 assets are not bundled. A future asset bridge must use assets legally available to the player, with compatibility and distribution rights reviewed before release.
- Melty one-click launch and publication are not verified by repository code alone.

## Manual QA checklist

- [ ] Enable the mod and start a single-player world without Lua errors.
- [ ] Confirm the HUD appears and does not obscure core controls.
- [ ] Confirm the mission objective advances after the opening delay.
- [ ] Confirm carrying food plus medical supplies or ammunition advances the objective.
- [ ] Confirm nearby zombie deaths update the threat counter and finish the mission.
- [ ] Save, quit, and reload; confirm mission state persists.
- [ ] Test on the exact Project Zomboid build selected in Melty.
- [ ] Confirm Melty's Play button launches directly into a playable session before publishing.
