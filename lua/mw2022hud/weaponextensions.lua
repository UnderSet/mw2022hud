MW2022HUD.WeaponExtensions = {}

-- badly named, but isBaseChecks essentially is the table of functions that check if a weapon is of a certain base
-- (they're run once and then cached)
local isBaseChecks = isBaseChecks or {}
local extendedDataHandlers = extendedDataHandlers or {}

local wepBase = {} -- which base a weapon is can be cached as it can't change at runtime (...or can it? (pls no))

MW2022HUD.WeaponExtensions.GetWeaponBase = function(wep)
    if wepBase[wep:GetClass()] then
        -- print("[MWIIHUD DEBUG] Cache hit! - Weapon: " .. wep:GetClass() .. " - base: " .. wepBase[wep:GetClass()])
        return wepBase[wep:GetClass()]
    end

    for k,v in pairs(isBaseChecks) do
        if v(wep) then
            wepBase[wep:GetClass()] = k
            -- print("[MWIIHUD DEBUG] Cache miss - Weapon: " .. wep:GetClass() .. " - base: " .. k)
            break
        end
    end
end

MW2022HUD.WeaponExtensions.AddHandler = function(basename, isBaseCheck, extendedDataHandler)
    isBaseChecks[basename] = isBaseCheck
    extendedDataHandlers[basename] = extendedDataHandler
end

-- all of the following functions are essentially thin wrappers to prevent you from accidentally calling a nonexistent
-- function (because I know some bases will probably make integrations like that...goddammit...)
MW2022HUD.WeaponExtensions.GetFiremode = function(wep)
    local curWepBase = wepBase[wep:GetClass()]
    if curWepBase and extendedDataHandlers[curWepBase].GetFiremode then
        return extendedDataHandlers[curWepBase].GetFiremode(wep)
    else
        return false, "", 1, false, false
    end
end
MW2022HUD.WeaponExtensions.GetCaliber = function(wep)
    local curWepBase = wepBase[wep:GetClass()]
    if curWepBase and extendedDataHandlers[curWepBase].GetCaliber then
        return extendedDataHandlers[curWepBase].GetCaliber(wep)
    else
        return false
    end
end
MW2022HUD.WeaponExtensions.GetMalfunctioning = function(wep)
    local curWepBase = wepBase[wep:GetClass()]
    if curWepBase and extendedDataHandlers[curWepBase].GetMalfunctioning then
        return extendedDataHandlers[curWepBase].GetMalfunctioning(wep)
    else
        return false
    end
end

print("[MWIIHUD] Weapon base extensions system loaded")