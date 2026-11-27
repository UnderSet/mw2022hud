-- warning: this damn file has stupidly long lines since you can't split strings across multiple lines, I have warned you
-- please enable Word Wrap in your editor at least while editing this file

-- ...remind me to refactor this eventually
-- (I should open an issue lmao)
local settingsCvars = {
    MW2022HUD.Enable,
    MW2022HUD.EnableCompass,
    MW2022HUD.EnableMinimap,
    MW2022HUD.EnableMinimapRotation,
    MW2022HUD.EnableHealth,
    MW2022HUD.EnableScore,
    MW2022HUD.XBounds,
    MW2022HUD.YBounds
}


hook.Add("PopulateToolMenu", "MW2022HUD_SpawnMenu", function()
    spawnmenu.AddToolMenuOption("Options", "MWII HUD", "MW2022HUD_Settings", "Settings", "", "", function(panel)
        panel:CheckBox("Enable HUD", "MW2022HUD_Enable")
        panel:ControlHelp("Enable the HUD.")

        panel:CheckBox("Compass", "MW2022HUD_EnableCompass")
        panel:ControlHelp("Enable the compass.")

            local compass = vgui.Create("DForm")
            panel:AddItem(compass)
            compass:SetName("Compass Settings")
            
            compass:CheckBox("Warzone Length Compass", "MW2022HUD_CompassWZLength")
            compass:ControlHelp("Use a shorter length for the compass similar to Warzone/DMZ in Modern Warfare II.\n- A map change or reload is required for this setting to take effect.")

        panel:CheckBox("Minimap", "MW2022HUD_EnableMinimap")
        panel:ControlHelp("Enable the minimap.\n- GMinimap is required for this feature.\n- WARNING: Some other addons' UI may be displayed on the minimap. This is out of my control as far as I'm aware, unfortunately.")
        
        -- unnecessary indent(s); this just helps me visualize what I'm doing
        local minimap = vgui.Create("DForm")
        panel:AddItem(minimap)
        minimap:SetName("Minimap Settings")
        
            if !GMinimap then
                minimap:Help("GMinimap is not installed - the minimap will not work.")
            else
                minimap:CheckBox("Minimap Rotation", "MW2022HUD_EnableMinimapRotation")
                minimap:ControlHelp("Allow the minimap to rotate instead of being locked to North.") -- is it really North locked?
            end

        panel:CheckBox("Firemode Notice", "MW2022HUD_EnableAmmoFiremodeNotice")
        panel:ControlHelp("Display a brief popup notice when changing firemodes or weapons. This may be distracting.")

        local health = panel:ComboBox("Health/Armor", "MW2022HUD_EnableHealth")
        health:AddChoice("Disabled", 0)
        health:AddChoice("Full (incl. squad functionality)", 1)
        health:AddChoice("My armor only", 2)
        panel:ControlHelp("Enable health and armor display.\n- WARNING: Squad functionality falls back to solo if no addon provides that data.")

        local score = panel:ComboBox("Score Display", "MW2022HUD_EnableScore")
        score:AddChoice("Disabled", 0)
        score:AddChoice("Enabled (Always)", 1)
        score:AddChoice("Enabled (While Active)", 2)
        panel:ControlHelp("Enable score display. Requires support from other addons or gamemodes.\n- \"Always\" will show gamemode icon and name at all times.\n- \"While Active\" will only display when an addon or gamemode is actively trying to display scores through this HUD.")
        -- note to fellow addon makers peeking here: integration with Beatrun is included as a template! copy and hack that away if you wish to make your addon supported!

        local bounds = vgui.Create("DForm")
        panel:AddItem(bounds)
        bounds:SetName("HUD Bounds Settings")
        bounds:NumSlider("Horizontal Bounds", "MW2022HUD_XBounds", 0, 100, 0)
        bounds:NumSlider("Vertical Bounds", "MW2022HUD_YBounds", 0, 100, 0)
        bounds:ControlHelp("Control how close the HUD is to your screen's edges.\n- Note: 100 is closer to screen edge and 0 is closer to center, matching Modern Warfare II.\n- Your mileage may vary with these settings.")

        local resetButton = panel:Button("[!!!] Reset All Settings [!!!]")
        resetButton.DoClick = function()
            local frame = vgui.Create("DFrame")
            frame:SetSize(400, 100)
            frame:SetTitle("Reset Settings?")
            frame:Center()
            frame:SetVisible(true)
            -- frame:SetDraggable( true ) 
            frame:ShowCloseButton( true ) 
            frame:MakePopup()

            local buttonBox = vgui.Create("DPanel", frame)
            buttonBox:SetSize(0,30)
            buttonBox:DockMargin(5,5,5,5)
            buttonBox:Dock(BOTTOM)
            buttonBox.Paint = function() end -- someone tell me a better way to make a panel and not its children invisible

            local text = Label("Are you sure you want to reset your Modern Warfare II HUD settings?", frame)
            text:DockMargin(5,5,5,5)
            text:Dock(FILL)

            local buttonNo = vgui.Create("DButton", buttonBox)
            buttonNo:SetText("No")
            buttonNo:SetSize(40, 30)
            buttonNo:Dock(LEFT)
            buttonNo.DoClick = function() frame:Close() end

            local buttonYes = vgui.Create("DButton", buttonBox)
            buttonYes:SetText("Yes")
            buttonYes:SetSize(40, 30)
            buttonYes:Dock(RIGHT)
            buttonYes.DoClick = function()
                for _,cvar in ipairs(settingsCvars) do
                    cvar:Revert()
                end

                buttonNo:Remove()

                text:SetText("Your settings have been reset.")
        
                buttonYes:SetText("OK")
                buttonYes.DoClick = function() frame:Close() end
            end

            frame:InvalidateLayout()
        end
    end)
end)

MW2022HUD.MsgC(Color(191,191,191), "Spawnmenu settings set up\n")