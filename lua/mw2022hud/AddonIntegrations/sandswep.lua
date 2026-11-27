local extendedHandler = {}
local isSandSwep = function(wep)
    if wep.IsSandSwep then return true else return false end
end

local fmLookupTable = {
    ["safe"] = 5,
    ["semi"] = 1,
    ["auto"] = 4
}

extendedHandler.GetFiremode = function(wep)
    local fm = wep:GetFireModes()[wep:GetFireModeIndex()]
    if string.match(fm, "burst") then
        local burst = (wep.BurstCount or 3) == 2 and 2 or 3
        return true, wep:GetGLMode() and "GL" or string.upper(fm), burst, false, wep:GetGLMode()
    else
        return true, wep:GetGLMode() and "GL" or string.upper(fm), fmLookupTable[fm], false, wep:GetGLMode()
    end
end

extendedHandler.GetCustomWeaponData = function(wep)
    return wep:Clip1(),
        wep:GetGLLoaded() and 1 or 0,
        math.max(wep.GetMagSize and wep:GetMagSize() or wep.Primary.ClipSize, 1),
        1,
        tonumber(wep.GetSpareRounds and wep:GetSpareRounds() or 0),
        wep:GetGLReserve(),
        wep:GetPrimaryAmmoType(),   -- if you're using a weapon with custom data just return anything but -1 here to have hud treat as gun
        wep:GetGLDef() and wep:GetGLDef() or -1,
        wep:GetCalibre().Name,
        wep.Secondary.Ammo
end

MW2022HUD.WeaponExtensions.AddHandler("sandswep", isSandSwep, extendedHandler)
MW2022HUD.MsgC(Color(191,191,191), "Weapon base extension loaded: Sandstorm SWEP Base\n")