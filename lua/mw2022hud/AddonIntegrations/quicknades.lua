print("[MWIIHUD] > Loaded addon integration for: Quick Grenades")

local mat = Material("iw9ui/hud_icon_equipment_frag.png", "smooth")
MW2022HUD.Ammo.Lethals.Material = Material("iw9ui/hud_icon_equipment_frag.png", "smooth")

hook.Add("MW2022HUD_OnFramePreDraw", "MW2022HUDQuickGrenadeSupport", function()
    MW2022HUD.Ammo.Lethals.Count = LocalPlayer():GetAmmoCount(10)
    MW2022HUD.Ammo.Lethals.Material = mat
end)
