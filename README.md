# *Modern Warfare II* HUD

A recreation of the *Call of Duty: Modern Warfare II* HUD in Garry's Mod. For the third time.

README is WIP.

## Features
- **Generally accurate-ish to MWII's elements!**
- **Working minimap!** - requires [GMinimap] to be installed
  - Has...a myriad of issues (due to GMinimap itself suffering from them), unfortunately - *to be documented later*
- **Functional scorebars** - requires gamemode integration
  - Built-in integrations: *Beatrun*
  - Also overridable with custom score drawing so you're not limited to MWII MP's two-bar setup either *(note to self: document this later)*
- **Killfeed with *kill icons!***
  - *Why is this such a rare feature???*
- Weapon display with *firemodes and altfire switching (where supported)* and icon rendering *(with grayscale colorgrading to match the MW reboot games [^1])*!
  - Uses weapon selection icons - can be configured per-weapon with offset and scaling
- Health and armor display with *armor plate support!*
  - Supports both VManip armor plates and [Warzone Armor System] out of the box!

[^1]: I unfortunately can't really force every weapon into having a MWII style icon unless I make one manually for every single weapon... And that is...let's say labor intensive to say the least...