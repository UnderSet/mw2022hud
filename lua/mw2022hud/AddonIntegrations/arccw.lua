local extendedHandler = {}
local IsWeaponArcCW = function(wep)
    if wep.ArcCW then return true else return false end
end

extendedHandler.GetFiremode = function(wep)
    local firemode = wep:GetFiremodeName()
    local safety = wep:GetCurrentFiremode().Mode == 0 and true or false
    local ubgl = wep:GetInUBGL()

    local firetype = wep:GetCurrentFiremode().Mode
    firetype = firetype == 0 and 5 or firetype == 1 and 1 or firetype >= 2 and 4 or firetype < 0 and math.Clamp(math.abs(firetype), 2, 3)

    return true, firemode, firetype, safety, ubgl
end
extendedHandler.GetCaliber = function(wep)
    return MW2022HUD.Weapon:GetBuff_Override("Override_Trivia_Calibre") or MW2022HUD.Weapon.Trivia_Calibre
end
extendedHandler.GetMalfunctioning = function(wep)
    return wep:GetMalfunctionJam() 
end

MW2022HUD.WeaponExtensions.AddHandler("ArcCW", IsWeaponArcCW, extendedHandler)
print("[MWIIHUD] Loaded weapon base extension: ArcCW")