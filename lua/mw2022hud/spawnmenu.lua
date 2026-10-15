hook.Add("PopulateToolMenu", "MW2022HUD_SpawnMenu", function()
    spawnmenu.AddToolMenuOption("Options", "MWII HUD", "MW2022HUD_Settings", "Settings", "", "", function(panel)
        panel:CheckBox("Enable HUD", "MW2022HUD_Enable")
        panel:ControlHelp("Enable the HUD.")

        panel:CheckBox("Compass", "MW2022HUD_EnableCompass")
        panel:ControlHelp("Enable the compass.")

        panel:CheckBox("Minimap", "MW2022HUD_EnableMinimap")
        panel:ControlHelp("Enable the minimap.\n- GMinimap is required for this feature.\n- WARNING: Some other addons' UI may be displayed on the minimap. This is out of my control as far as I'm aware, unfortunately.")

        panel:CheckBox("Minimap Rotation", "MW2022HUD_EnableMinimapRotation")
        panel:ControlHelp("Allow the minimap to rotate instead of being locked to North.") -- is it really North locked?

        local health = panel:ComboBox("Health/Armor", "MW2022HUD_EnableHealth")
        health:AddChoice("Disabled", 0)
        health:AddChoice("Full (incl. squad behavior)", 1)
        health:AddChoice("My armor only", 2) -- this option is slightly broken at the moment, I'll fix that behavior (mark my words)
        panel:ControlHelp("Enable health and armor display.\n- This element is based off of Warzone 2.0/DMZ, not Ground War/Co-Op (Spec Ops/RAID)/Campaign and will not match those gamemodes.")

        local score = panel:ComboBox("Score Display", "MW2022HUD_EnableScore")
        score:AddChoice("Disabled", 0)
        score:AddChoice("Enabled (Always)", 1)
        score:AddChoice("Enabled (While Active)", 2)
        panel:ControlHelp("Enable score display. Requires active support from other addons or gamemodes.\n- \"Always\" will show gamemode icon and name at all times.\n- \"While Active\" will only display when an addon or gamemode is actively trying to display scores through this HUD.")
        -- note to fellow addon makers peeking here: integration with Beatrun is included as a template! copy and hack that away if you wish to make your addon supported!

        panel:CheckBox("Firemode Notice", "MW2022HUD_EnableAmmoFiremodeNotice")
        panel:ControlHelp("Display a brief popup notice when changing firemodes. This may be distracting.")

        panel:NumSlider("Horizontal Bounds", "MW2022HUD_XBounds", 0, 100, 0)
        panel:NumSlider("Vertical Bounds", "MW2022HUD_YBounds", 0, 100, 0)
        panel:ControlHelp("Control how close the HUD is to your screen's edges.\n- Note: 100 is closer to screen edge and 0 is closer to center. This matches MWII behavior on 1920x1080.\n- Your mileage may vary with these settings.")
    end)
end)

print("[MWIIHUD] Spawnmenu settings loaded")