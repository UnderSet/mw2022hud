MW2022HUD.Vitals = {}
-- MW2022HUD.SquadData = {}

MW2022HUD.Materials.ArmorPlate = Material("iw9ui/hud_icon_loot_armor.png", "smooth")

MW2022HUD.Materials.ArmorBar = Material("iw9ui/hud_icon_armor_background.png", "smooth")
MW2022HUD.Materials.ArmorOutline = Material("iw9ui/hud_icon_armor_outline.png", "smooth") -- does not gracefully downscale otherwise
MW2022HUD.Materials.PlayerNumBacking = Material("mw2022/playernum_backing.png", "smooth")

local LowRed = Color(201,73,0)
local OutlineBlack = Color(66,66,66,55)
local BarBacking = Color(48,48,48,128)
local ArmorColor = Color(115,39,203)

local plyColor = GetConVar("cl_playercolor") and Vector(GetConVar("cl_playercolor"):GetString()):ToColor() or Color(255,255,255)
local plyColorHSVValue = select(3, plyColor:ToHSV())

local plyColorCache = {}
local plyColorHSVCache = {}

local localPlyNum = 1

MW2022HUD.Vitals.Draw = function()
    -- warning to anyone who wishes to dip their toes here: this element is extremely laggy and messy, I have warned you
    -- (no but seriously what the fuck is this messy code? I barely know what I'm even fucking doing)
    local ply = LocalPlayer()

    if MW2022HUD.EnableHealth:GetBool() then
        local plyRenderNum = 1 -- basically, a poorly named counter of how many players we've drawn so far

        -- duplicating the drawing stuff twice is NOT the greatest idea known to man...
        for k,v in ipairs(MW2022HUD.SquadData or player.GetAll()) do
            local vertshift = (v == ply and 0 or (6 + plyRenderNum * 52)) * MW2022HUD.Scale
            local barlen = (v == ply and 165 or 127) * MW2022HUD.Scale
            local armorw = (v == ply and 165 or 125) * MW2022HUD.Scale -- ...blame Infinity Ward...yep, it's slightly different lengths...
            if v == ply then
                -- extremely crude, but AFAIK there isn't really a way to do basically reverse key-value lookup (lmao)
                -- pls forgive this heresy
                localPlyNum = k
                -- continue
            else
                plyRenderNum = plyRenderNum + 1
            end
            if MW2022HUD.EnableHealth:GetInt() != 2 then
                if !plyColorCache[v] then
                    plyColorCache[v] = v:GetPlayerColor():ToColor()
                    plyColorHSVCache[v] = {plyColorCache[v]:ToHSV()}
                end
                draw.SimpleTextOutlined(v:Nick(), "MW2022PlayerName", MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - 93 * MW2022HUD.Scale,
                    plyColorCache[v], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, BarBacking)
                surface.SetMaterial(MW2022HUD.Materials.PlayerNumBacking)
                surface.SetDrawColor(BarBacking)
                surface.DrawTexturedRect(MW2022HUD.LeftMargin + 41 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - 92 * MW2022HUD.Scale, 20 * MW2022HUD.Scale, 20 * MW2022HUD.Scale)
                surface.SetDrawColor(plyColorCache[v])
                surface.DrawTexturedRect(MW2022HUD.LeftMargin + 42 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - 91 * MW2022HUD.Scale, 18 * MW2022HUD.Scale, 18 * MW2022HUD.Scale)
                draw.DrawText(k, "MW2022AmmoType", MW2022HUD.LeftMargin + 50 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - 92 * MW2022HUD.Scale,
                    plyColorHSVCache[v][3] > 0.6 and color_black or color_white, TEXT_ALIGN_CENTER)

                surface.SetDrawColor(BarBacking)
                surface.DrawRect(MW2022HUD.LeftMargin + 63 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - 55 * MW2022HUD.Scale, barlen + 4 * MW2022HUD.Scale, 3 * MW2022HUD.Scale)
                surface.SetDrawColor(color_white)
                surface.DrawRect(MW2022HUD.LeftMargin + 65 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - 55 * MW2022HUD.Scale,
                    barlen * math.min(v:Health() / v:GetMaxHealth(), 1), 3 * MW2022HUD.Scale)

                draw.SimpleTextOutlined("$0", "MW2022AmmoSmall", MW2022HUD.LeftMargin + (v == ply and 239 or 199) * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - 72 * MW2022HUD.Scale,
                    color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
            end

            render.SetScissorRect(MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - 72 * MW2022HUD.Scale,
                MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale + armorw * math.min(v:Armor() / v:GetMaxArmor(), 1), MW2022HUD.BottomMargin - vertshift - 52 * MW2022HUD.Scale, true)
            surface.SetMaterial(MW2022HUD.Materials.ArmorBar)
            surface.SetDrawColor(ArmorColor)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 65 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - 70 * MW2022HUD.Scale,
                armorw, 15 * MW2022HUD.Scale)
            render.SetScissorRect(0,0,0,0,false)
            surface.SetMaterial(MW2022HUD.Materials.ArmorOutline)
            surface.SetDrawColor(color_white)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 65 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - (v == ply and 72 or 70) * MW2022HUD.Scale,
                armorw, (v == ply and 20 or 15) * MW2022HUD.Scale)

            if v == ply and MW2022HUD.EnableHealth:GetInt() == 2 then break end
        end

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