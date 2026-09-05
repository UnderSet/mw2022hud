MW2022HUD.Vitals = {}

MW2022HUD.Materials.ArmorPlate = Material("iw9ui/hud_icon_loot_armor.png", "smooth")

MW2022HUD.Materials.ArmorBar = Material("iw9ui/hud_icon_armor_background.png", "smooth")
MW2022HUD.Materials.ArmorOutline = Material("iw9ui/hud_icon_armor_outline.png", "smooth") -- does not gracefully downscale otherwise
MW2022HUD.Materials.PlayerNumBacking = Material("mw2022/playernum_backing.png", "smooth")

local LowRed = Color(201,73,0)
local OutlineBlack = Color(66,66,66,55)
local BarBacking = Color(48,48,48,128)
local ArmorBlue = Color(97,127,205)

local plyColor = GetConVar("cl_playercolor") and Vector(GetConVar("cl_playercolor"):GetString()):ToColor() or Color(255,255,255)
local plyColorHSVValue = select(3, plyColor:ToHSV())

MW2022HUD.Vitals.Draw = function()
    local ply = LocalPlayer()

    if MW2022HUD.EnableHealth:GetBool() then
        if MW2022HUD.EnableHealth:GetInt() == 1 then
        draw.SimpleTextOutlined(ply:Nick(), "MW2022PlayerName", MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 93 * MW2022HUD.Scale, plyColor,
            TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, OutlineBlack)
        surface.SetMaterial(MW2022HUD.Materials.PlayerNumBacking)
        surface.SetDrawColor(BarBacking)
        surface.DrawTexturedRect(MW2022HUD.LeftMargin + 41 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 92 * MW2022HUD.Scale, 20 * MW2022HUD.Scale, 20 * MW2022HUD.Scale)
        surface.SetDrawColor(plyColor)
        surface.DrawTexturedRect(MW2022HUD.LeftMargin + 42 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 91 * MW2022HUD.Scale, 18 * MW2022HUD.Scale, 18 * MW2022HUD.Scale)
        draw.DrawText(1, "MW2022AmmoType", MW2022HUD.LeftMargin + 50 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 92 * MW2022HUD.Scale,
            plyColorHSVValue > 0.6 and color_black or color_white, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(BarBacking)
        surface.DrawRect(MW2022HUD.LeftMargin + 62 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 55 * MW2022HUD.Scale, 169 * MW2022HUD.Scale, 3 * MW2022HUD.Scale)
        surface.SetDrawColor(color_white)
        surface.DrawRect(MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 55 * MW2022HUD.Scale,
            165 * MW2022HUD.Scale * math.min(ply:Health() / ply:GetMaxHealth(), 1), 3 * MW2022HUD.Scale)
        end

        render.SetScissorRect(MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 72 * MW2022HUD.Scale,
            MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale + 165 * MW2022HUD.Scale * math.min(ply:Armor() / ply:GetMaxArmor(), 1), MW2022HUD.BottomMargin - 52 * MW2022HUD.Scale, true)
        surface.SetMaterial(MW2022HUD.Materials.ArmorBar)
        surface.SetDrawColor(ArmorBlue)
        surface.DrawTexturedRect(MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 72 * MW2022HUD.Scale,
            165 * MW2022HUD.Scale, 20 * MW2022HUD.Scale)
            render.SetScissorRect(0,0,0,0,false)
        surface.SetMaterial(MW2022HUD.Materials.ArmorOutline)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 72 * MW2022HUD.Scale, 165 * MW2022HUD.Scale, 20 * MW2022HUD.Scale)

        if ply.GetArmorPlates or GetConVar("wz_armorsys_armorplates_maxcarry") and ply:GetAmmoCount("WZ_ARMORPLATE") then
            surface.SetMaterial(MW2022HUD.Materials.ArmorPlate)
            surface.SetDrawColor(color_white)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 334 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 71 * MW2022HUD.Scale, 25 * MW2022HUD.Scale, 25 * MW2022HUD.Scale)

            draw.SimpleTextOutlined(ply.GetArmorPlates and ply:GetArmorPlates() or GetConVar("wz_armorsys_armorplates_maxcarry") and ply:GetAmmoCount("WZ_ARMORPLATE") or "0", "MW2022AmmoSmall",
                MW2022HUD.LeftMargin + 357 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 69 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
        end
    end
end

hook.Add("InitPostEntity", "MW2022VitalsInit", function()
    plyColor = Vector(GetConVar("cl_playercolor"):GetString()):ToColor()
    plyColorHSVValue = select(3, plyColor:ToHSV())
end)

cvars.AddChangeCallback("cl_playercolor",
    function(convar, oldVal, newVal) plyColor = Vector(newVal):ToColor() plyColorHSVValue = select(3, plyColor:ToHSV()) end, "MW2022HUDPlayerColorChange")

print("[MWIIHUD] Vitals module loaded")