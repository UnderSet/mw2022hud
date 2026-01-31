MW2022HUD.Vitals = {}

MW2022HUD.Materials.ArmorPlate = Material("iw9ui/hud_icon_loot_armor.png")

local LowRed = Color(201,73,0)
local OutlineBlack = Color(66,66,66,55)

MW2022HUD.Vitals.Draw = function()
    local ply = LocalPlayer()

    surface.SetDrawColor(color_white)
    surface.DrawRect(MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 55 * MW2022HUD.Scale,
        165 * MW2022HUD.Scale * math.min(ply:Health() / ply:GetMaxHealth(), 1), 3 * MW2022HUD.Scale)

    if ply.GetArmorPlates or GetConVar("wz_armorsys_armorplates_maxcarry") and ply:GetAmmoCount("WZ_ARMORPLATE") then
        surface.SetMaterial(MW2022HUD.Materials.ArmorPlate)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(MW2022HUD.LeftMargin + 334 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 71 * MW2022HUD.Scale, 25 * MW2022HUD.Scale, 25 * MW2022HUD.Scale)

        draw.SimpleTextOutlined(ply.GetArmorPlates and ply:GetArmorPlates() or GetConVar("wz_armorsys_armorplates_maxcarry") and ply:GetAmmoCount("WZ_ARMORPLATE") or "0", "MW2022AmmoSmall",
            MW2022HUD.LeftMargin + 357 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 69 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    end
end