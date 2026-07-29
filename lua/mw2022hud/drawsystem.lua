MW2022HUD.HideElements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudSuitPower"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}

hook.Add("HUDPaint", "MW2022HUDRun", function()
    if !MW2022HUD.Enable:GetBool() then return end

    if !LocalPlayer():Alive() then
        -- reset damage directions
        MW2022HUD.DamageIndicator.DamageAng = {}
    else
        MW2022HUD.DamageIndicator.Draw()
    
        MW2022HUD.Compass.Draw()
    
        MW2022HUD.Ammo.SetupWeaponData()
        MW2022HUD.Ammo.Draw()
    
        MW2022HUD.Vitals.Draw()

        MW2022HUD.Minimap.Draw()
    end

    MW2022HUD.Score.SetScores()
    MW2022HUD.Score.Draw()

    MW2022HUD.Killfeed.Draw()

    -- I'm genuinely unsure if the calling cards draw if you're dead in MWII itself so uh...
    -- MW2022HUD.CallingCards.Draw()
end)

hook.Add("HUDShouldDraw", "MW2022HUDHideDefault", function(name)
    if MW2022HUD.HideElements[name] and MW2022HUD.Enable:GetBool() then return false end
end)