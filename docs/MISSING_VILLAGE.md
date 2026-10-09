# Project Evil — The Missing Village

## Original story
Leon arrives to investigate a remote settlement after its residents vanish. Abandoned houses and scattered supplies suggest a hurried evacuation. At night, the infected villagers return. Surviving the first attack reveals evidence of a parasite outbreak and opens the investigation into who caused it.

## Intended feel
Resident Evil 4 (2005) action-horror and major encounters blended with Project Zomboid scavenging, injuries, crafting, and defensible shelters. Single-player first.

## Chapter-one playable loop
1. Investigate the settlement for five in-game hours.
2. Find food plus medicine or ammunition before nightfall.
3. Defeat five nearby infected to survive the first return.
4. Save chapter completion to player mod data.

## Current implementation versus intended release
The code currently implements **only** a mission-state prototype with HUD objectives and native Project Zomboid zombies. It does not yet create the village, schedule a night attack, spawn custom infected, replace the protagonist model, add RE4 weapons, implement a boss, or provide an authored level. The five-hour transition is a narrative timer, **not** a darkness or encounter trigger. Those are required future work, not completed features.

## Release acceptance gates
- Create a distinct village environment and original outbreak clues.
- Implement infected-villager behavior, meaningful night assault, RE4-style weapons, and a boss encounter using legally distributable original content or runtime reads from a player's own installed game.
- Test gameplay in Project Zomboid Build 42, including save/reload and Lua errors.
- Verify a real one-click install and launch in Melty and capture a genuine in-game screenshot.
- Confirm credits, license, remix permissions, and Melty's package validation before publishing.

Do not bundle files copied from either commercial game.
