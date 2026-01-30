MW2022HUD.HideElements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudSuitPower"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}

hook.Add("HUDPaint", "MW2022HUDRun", function()
    -- MW2022's HUD just doesn't render if you're dead lmao
    if !MW2022HUD.Enable:GetBool() or !LocalPlayer():Alive() then return end

    MW2022HUD.Compass.Draw()

    MW2022HUD.Ammo.SetupWeaponData()
    MW2022HUD.Ammo.Draw()

    MW2022HUD.Score.Draw()
end)

hook.Add("HUDShouldDraw", "MW2022HUDHideDefault", function(name)
    if MW2022HUD.HideElements[name] and MW2022HUD.Enable:GetBool() then return false end
end)