local ARC9TriviaCaliberKeys = {}

local extendedHandler = {}
local IsWeaponARC9 = function(wep)
    if wep.ARC9 then return true else return false end
end

extendedHandler.GetFiremode = function(wep)
    local firemode = wep:GetFiremodeName()
    local safety = wep:GetSafe()
    local ubgl = wep:GetUBGL()

    -- behold the insanity
    local firetype = wep:GetCurrentFiremodeTable().Mode
    firetype = safety and 5 or firetype < 0 and 4 or firetype > 1 and math.min(firetype, 3) or 1

    return true, firemode, firetype, safety, ubgl
end
extendedHandler.GetCaliber = function(wep)
    -- basically? this is a GIANT HEURISTIC to find calibers.
    -- only works properly for English, obviously, as trivia is fully customizable in ARC9...
    
    -- if you don't play GMod in English...I'm sorry...

    -- uncomment the print() calls here if you'd like to see how this works behind the scenes

    if ARC9TriviaCaliberKeys[wep:GetClass()] then
        return (ARC9:GetPhrase(wep.Trivia[ARC9TriviaCaliberKeys[wep:GetClass()]])
            or wep.Trivia[ARC9TriviaCaliberKeys[wep:GetClass()]])
    end

    for k,v in pairs(wep.Trivia) do
        local TriviaKey = ARC9:GetPhrase(string.sub(k, 0, #k-1)) or string.sub(k, 0, #k-1)
        local TriviaKeyAlt = ARC9:GetPhrase(k) or k
        if string.match(TriviaKey, "Caliber") or string.match(TriviaKey, "Calibre") then
            ARC9TriviaCaliberKeys[wep:GetClass()] = k
            return (ARC9:GetPhrase(wep.Trivia[k]) or wep.Trivia[k])
        end

        if string.match(TriviaKeyAlt, "Caliber") or string.match(TriviaKeyAlt, "Calibre") then
            ARC9TriviaCaliberKeys[wep:GetClass()] = k
            return (ARC9:GetPhrase(wep.Trivia[k]) or wep.Trivia[k])
        end
    end

    return false
end
extendedHandler.GetMalfunctioning = function(wep)
    return wep:GetJammed()
end

MW2022HUD.WeaponExtensions.AddHandler("ARC9", IsWeaponARC9, extendedHandler)
print("[MWIIHUD] Loaded weapon base extension: ARC9")