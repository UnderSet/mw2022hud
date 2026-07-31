# *Modern Warfare II* HUD

A recreation of the *Call of Duty: Modern Warfare II* HUD in Garry's Mod. For the third time.

README is WIP.

## Features
- **Generally accurate-ish to MWII's elements!**
  - *Note:* I'm aware HUD animations are not 100% accurate, unfortunately
- **Working minimap!** - requires [GMinimap](https://steamcommunity.com/sharedfiles/filedetails/?id=3024317004) to be installed and enabled in-game
  - No, GMinimap's own in-game enable toggle doesn't need to be on
  - Has...a myriad of issues (due to GMinimap itself suffering from them), unfortunately - *to be documented later*
- **Functional scorebars** - requires gamemode integration
  - Built-in integrations: *Beatrun*
  - Also overridable with custom score drawing so you're not limited to MWII MP's two-bar setup either *(note to self: document this later)*
- **Killfeed with *kill icons!***
  - *Why is this such a rare feature???*
- Weapon display with *firemodes and altfire switching (where supported)* and icon rendering *(with grayscale colorgrading to match the MW reboot games [^1])*!
  - Uses weapon selection icons - can be configured per-weapon with offset and scaling *(note to self: also document this later)*
- Health and armor display with *armor plate support!*
  - Supports both VManip Armor Plates and [Warzone Armor System]() out of the box!

## License
Code - and *only the code* - is under the MIT license - see [`LICENSE`](/LICENSE).

Weapon prerenders under under [`materials/mw2022/weaponicons`](/materials/mw2022/weaponicons) are by me using assets from Garry's Mod or Half-Life 2 in Blender and are free to be reused. [^2]

*All other files* under [`materials/`](/materials/) are either original textures from Modern Warfare II or edits of said textures, and are copyright Activision and Infinity Ward.

## Credits
- Tripperful for [Iconic Weapon Selector](https://github.com/Tripperful/iconic), which is where I got the weapon icon method from
- Scobalula, dest1yo and echo000 for Cordycep and Saluki, which was used to get MWII's HUD assets
- REDxEYE and contributors to [SourceIO](https://github.com/REDxEYE/SourceIO/), which was used to import assets into Blender for making base Half-Life 2 weapon icon prerenders in this addon
- Activision and Infinity Ward for *Call of Duty: Modern Warfare II*

Let me know if you feel like you should be credited here but aren't.

[^1]: I unfortunately can't really force every weapon into having a MWII style icon unless I make one manually for every single weapon... And that is...let's say labor intensive to say the least...

[^2]: I'm not really familiar with how licensing this stuff works as opposed to code...