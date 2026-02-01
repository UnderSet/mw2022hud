util.AddNetworkString("MW2022PlayerDamageTaken")

print("ALO VEO MA DI ALO")

hook.Add("PostEntityTakeDamage", "MW2022PlayerDamageTaken", function(ent, dmginfo, taken)
    if ent:IsPlayer() then
        local frompos = dmginfo:GetInflictor():GetPos()
        local ang = (ent:GetPos() - frompos):Angle().y % 360 + 180

        net.Start("MW2022PlayerDamageTaken")
        net.WriteFloat(ang)
        net.Send(ent)
    end
end)