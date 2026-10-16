MW2022HUD.WeaponExtensions = {}

-- badly named, but isBaseChecks essentially is the table of functions that check if a weapon is of a certain base
-- (they're run once and then cached)
local isBaseChecks = isBaseChecks or {}
local extendedDataHandlers = extendedDataHandlers or {}

local wepBase = {} -- which base a weapon is can be cached as it can't change at runtime (...or can it? (pls no))

MW2022HUD.WeaponExtensions.GetWeaponBase = function(wep)
    if wepBase[wep:GetClass()] != nil then
        -- print("[MWIIHUD DEBUG] Cache hit! - " .. wep:GetClass() .. " on " .. tostring(wepBase[wep:GetClass()]))
        return wepBase[wep:GetClass()]
    end

    -- print("[MWIIHUD DEBUG] Cache missed for " .. wep:GetClass() .. ", checking bases...")
    for k,v in pairs(isBaseChecks) do
        -- print("[MWIIHUD DEBUG] Checking this weapon for base: " .. k)
        if v(wep) then
            wepBase[wep:GetClass()] = k
            -- print("[MWIIHUD DEBUG] Found base for weapon - " .. wep:GetClass() .. " on " .. k)
            return k
        end
    end

    -- print("[MWIIHUD DEBUG] No matching base...")
    -- if we've gotten here there's no base matching, so...
    wepBase[wep:GetClass()] = false
end

MW2022HUD.WeaponExtensions.AddHandler = function(basename, isBaseCheck, extendedDataHandler)
    isBaseChecks[basename] = isBaseCheck
    extendedDataHandlers[basename] = extendedDataHandler
end

-- used in development through lua_run_cl
-- GetWeaponBase will fallback and save to cache the fallback if the base extensions aren't loaded...
MW2022HUD.WeaponExtensions.ResetWeaponBaseCache = function()
    wepBase = {}
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