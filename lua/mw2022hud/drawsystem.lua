hook.Add("HUDPaint", "MW2022HUDRun", function()
    if !MW2022HUD.Enable:GetBool() then return end

    MW2022HUD.Compass.Draw()

    MW2022HUD.Ammo.SetupWeaponData()
    MW2022HUD.Ammo.Draw()
end)