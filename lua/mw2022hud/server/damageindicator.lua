util.AddNetworkString("MW2022PlayerDamageTaken")

hook.Add("PostEntityTakeDamage", "MW2022PlayerDamageTaken", function(ent, dmginfo, taken)
    if ent:IsPlayer() then
        local frompos = IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetPos() or vector_origin
        local ang = (ent:GetPos() - frompos):Angle().y % 360 + 180

        net.Start("MW2022PlayerDamageTaken")
        net.WriteFloat(ang)
        net.Send(ent)
    end
end)