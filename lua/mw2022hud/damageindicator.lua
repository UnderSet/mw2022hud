MW2022HUD.DamageIndicator = {}

MW2022HUD.Materials.Damaged = Material("iw9ui/hit_direction.png", "smooth")
MW2022HUD.Materials.DamagedArmor = Material("iw9ui/hit_direction_armor.png", "smooth")

MW2022HUD.DamageIndicator.DamageAng = {{30, false, CurTime() + 6}, {90, true, CurTime() + 6}, {127, true, CurTime() + 6}}

local armordmg = Color(190,190,190)
local healthdmg = Color(255,255,255) -- literally the same as color_white, yes, but see below for why

MW2022HUD.DamageIndicator.Draw = function()
    for i = 1, #MW2022HUD.DamageIndicator.DamageAng do
        local ang = MW2022HUD.DamageIndicator.DamageAng[i][1] - EyeAngles().y + 180
        local angrad = math.rad(ang) -- math.sin and math.cos take a radian value lmao
        local x = 220 * math.sin(angrad)
        local y = 220 * math.cos(angrad)

        armordmg.a = math.max(255 - 128 * math.max(CurTime() - MW2022HUD.DamageIndicator.DamageAng[i][3], 0), 0)
        healthdmg.a = math.max(255 - 128 * math.max(CurTime() - MW2022HUD.DamageIndicator.DamageAng[i][3], 0), 0)

        surface.SetMaterial(MW2022HUD.DamageIndicator.DamageAng[i][2] and MW2022HUD.Materials.DamagedArmor or MW2022HUD.Materials.Damaged)
        surface.SetDrawColor(MW2022HUD.DamageIndicator.DamageAng[i][2] and armordmg or healthdmg)
        surface.DrawTexturedRectRotated(ScrW() / 2 + x, ScrH() / 2 + y, 256, 128, ang + 180)
        -- surface.DrawCircle(ScrW() / 2, ScrH() / 2, 240, 255, 255, 255, 255)
    end

    for i = #MW2022HUD.DamageIndicator.DamageAng, 1, -1 do
        if MW2022HUD.DamageIndicator.DamageAng[i][3] + 2 < CurTime() then
            table.remove(MW2022HUD.DamageIndicator.DamageAng, i)
        end
    end
end

net.Receive("MW2022PlayerDamageTaken", function()
    ang = net.ReadFloat()
    print("DMG TAKEN: " .. ang)
    MW2022HUD.DamageIndicator.DamageAng[#MW2022HUD.DamageIndicator.DamageAng + 1] = {ang, false, CurTime() + 6}
end)