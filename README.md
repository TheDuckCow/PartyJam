# PNWPartyGame
 
This is a starter test repo for a Mario Party-style game jam project. This is the main game selector menu, which searches for mini-game scenes in a designated folder (res://MiniGames/) and dynamically creates a button with their name. Upon click, it loads the mini-game.

The included minigame is just there as an example to show where the minigames should be located to be seen by the project to be loaded and show required title and victory scene content, ie game name, credits, basic game instructions, etc, but how it looks or organized is up to you so be creative and have fun with it!

In your victory screen, use Global.playerWins function and pass in the player number that won, so there is score tracking!

### ---How to validate your entry before submission---
Fresh clone of the template project and copy your entry into the Minigames folder within. And when you run the template from the default scene, it should be automatically recognized and playable. If it doesn't do this, remodify your entry as needed.

If you have any questions, you can ask for help in the Godot Seattle Discord Game Jam channel https://discord.com/channels/1157408687393099796/1274154951379255417 or 
Seattle Indies' Discord Jam channel https://discord.com/channels/225755619586605056/340940420597022724.


### How to export your entry

1. Decide on your minigame name, e.g. `my_minigame` (use snake_case!)
2. Crate your minigame primary scene as `/minigames/my_minigame.tscn`
3. Create a subfolder for your minigame resources if necessary, e.g. `/minigames/my_minigame/...`
4. When ready, export your minigame by going to:
   1. Project > Export...
   2. Select the default web export template
   3. Press "Export PCK/ZIP" (not Export Project, as that would be the whole thing)
   4. Navigate to `/minigames/`
   5. Change the export dropdown type to "Godot Project pack (\*.pck)"
   6. Change the name to exactly match your scene name in that location, but ending in pck (e.g. `my_minigame.pck`)
   7. Uncheck "debug" and uncheck "export as patch"
5. You should now see a new pck in the minigames folder called `/minigames/my_minigame.pck`
6. If you build and run the game now, you should see two versions of your minigame: one with a ".tscn" suffix (which is like your working copy), and then another one simply named after your minigame (which comes from the pck export). 
7. Test that your minigame is working by pressing on the one *without* the "tscn" suffix. You should see:
    * The console prints out something like `scenePath: res://minigames/my_minigame.pck` and then `unpackedScene: res://minigames/my_minigame.tscn` showing it resolved the name appropriately
    * And that your minigame fully works as expected

That's it! Your pck file is now your portable entry which can be submitted to the jam organizers.

