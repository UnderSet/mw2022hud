local ARC9TriviaCaliberKeys = {}

local extendedHandler = {}
local IsWeaponMWB = function(wep)
    if weapons.IsBasedOn(wep:GetClass(), "mg_base") then return true else return false end
end

extendedHandler.GetFiremode = function(wep)
    local safety = wep:HasFlag("Lowered")
    local ubgl = wep:HasFlag("UsingUnderbarrel")
    local firemode = safety and "LOWERED" or ubgl and (wep:GetUnderbarrel() != nil and wep:GetUnderbarrel().Name or "Altfire")
        or string.upper(wep.Firemodes[wep:GetFiremode()].Name)

    local firetype = safety and 5 or wep.Primary.Automatic and 4 or wep.Primary.BurstRounds > 1 and math.Clamp(wep.Primary.BurstRounds, 2, 3) or 1
    return true, firemode, firetype, safety, ubgl
end

MW2022HUD.WeaponExtensions.AddHandler("ARC9", IsWeaponMWB, extendedHandler)
print("[MWIIHUD] Loaded weapon base extension: Modern Warfare Base")