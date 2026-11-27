local mat = Material("iw9ui/hud_icon_equipment_stim.png", "smooth")
MW2022HUD.Ammo.Tacticals.Material = Material("iw9ui/hud_icon_equipment_stim.png", "smooth")

hook.Add("MW2022HUD_OnFramePreDraw", "MW2022HUDStimsSupport", function()
    if !LocalPlayer().GetStims then return end
    MW2022HUD.Ammo.Tacticals.Count = LocalPlayer():GetStims()
    MW2022HUD.Ammo.Tacticals.Material = mat
end)

MW2022HUD.MsgC(Color(191,191,191), "Addon integration module loaded: VManip Stims\n")