MW2022HUD.Ammo = {}
MW2022HUD.Weapon = nil
MW2022HUD.LastWeapon = nil
MW2022HUD.LastUBState = false
MW2022HUD.LastFiremode = "AUTO"
MW2022HUD.WeaponData = {}

local OutlineBlack = Color(66,66,66,55)
local BackgroundBlack = Color(29,29,29,207)
local ReserveGray = Color(166,177,179)
local LowRed = Color(201,73,0)
local LowYellow = Color(237,201,16)

local WeaponNameColor = Color(255,255,255)
local WeaponNameOutline = Color(66,66,66,55)
local AmmoTypeNameColor = Color(166,177,179)
local AmmoTypeNameOutline = Color(66,66,66,55)
local FiremodeNoticeColor = Color(255,255,255)
local FiremodeNoticeOutline = Color(66,66,66,55)

local WeaponNameTime = CurTime() + 1.5
local AmmoTypeName = CurTime() + 1.5
local FiremodeNoticeTime = CurTime() + 1.5

MW2022HUD.Debug.DisableWeaponIconScaling = CreateClientConVar("MW2022HUD_Debug_DisableWeaponIconScaling", 0, false, false, "DEBUG: Temporarily disables weapon icon scaling functionality. Setting is not saved.", 0, 1)

MW2022HUD.Materials.FireGroups = {{Material("iw9ui/ui_firetype_semiauto.png")}, {Material("iw9ui/ui_firetype_hyperburst.png")}, {Material("iw9ui/ui_firetype_burst.png")}, {Material("iw9ui/ui_firetype_fullauto.png")}, {Material("mw2022/ui_firetype_safe.png")}}

MW2022HUD.WeaponIconRT = GetRenderTarget("MW5WeaponIcon", 512 * math.Round(MW2022HUD.Scale), 256 * math.Round(MW2022HUD.Scale))
MW2022HUD.WeaponIconRTMat = CreateMaterial( 
    "MW5WeaponIconMat","UnlitGeneric",
    {
        ["$basetexture"] = MW2022HUD.WeaponIconRT:GetName(),
        ["$translucent"] = "1"
    } 
)
MW2022HUD.WeaponIconRTWidth, MW2022HUD.WeaponIconRTHeight = 512 * math.Round(MW2022HUD.Scale), 256 * math.Round(MW2022HUD.Scale)

MW2022HUD.WeaponIconColorCorrect = {
    [ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0.2,
	[ "$pp_colour_contrast" ] = 1.1,
	[ "$pp_colour_colour" ] = 0,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

MW2022HUD.WeaponIconOffsets = file.Exists("mw2022weaponiconoffsets.txt", "DATA") and util.JSONToTable(util.Decompress(file.Read("mw2022weaponiconoffsets.txt", "DATA"))) or {}

MW2022HUD.WeaponIconPrerenders = {
    ["weapon_357"] = select(1, Material("mw2022/weaponicons/weapon_357.png", "mips smooth")),
    ["weapon_ar2"] = select(1, Material("mw2022/weaponicons/weapon_ar2.png", "mips smooth")),
    ["weapon_bugbait"] = select(1, Material("mw2022/weaponicons/weapon_bugbait.png", "mips smooth")),
    ["weapon_crossbow"] = select(1, Material("mw2022/weaponicons/weapon_crossbow.png", "mips smooth")),
    ["weapon_crowbar"] = select(1, Material("mw2022/weaponicons/weapon_crowbar.png", "mips smooth")),
    ["weapon_frag"] = select(1, Material("mw2022/weaponicons/weapon_frag.png", "mips smooth")),
    ["weapon_physcannon"] = select(1, Material("mw2022/weaponicons/weapon_physcannon.png", "mips smooth")),
    ["weapon_physgun"] = select(1, Material("mw2022/weaponicons/weapon_physcannon.png", "mips smooth")),
    ["weapon_pistol"] = select(1, Material("mw2022/weaponicons/weapon_pistol.png", "mips smooth")),
    ["weapon_rpg"] = select(1, Material("mw2022/weaponicons/weapon_rpg.png", "mips smooth")),
    ["weapon_shotgun"] = select(1, Material("mw2022/weaponicons/weapon_shotgun.png", "mips smooth")),
    ["weapon_slam"] = select(1, Material("mw2022/weaponicons/weapon_slam.png", "mips smooth")),
    ["weapon_stunstick"] = select(1, Material("mw2022/weaponicons/weapon_stunstick.png", "mips smooth")),
    ["weapon_smg1"] = select(1, Material("mw2022/weaponicons/weapon_smg1.png", "mips smooth")),
    ["gmod_tool"] = select(1, Material("mw2022/weaponicons/gmod_tool.png", "mips smooth"))
}

MW2022HUD.Ammo.Lethals = {}
MW2022HUD.Ammo.Tacticals = {}
MW2022HUD.Ammo.Lethals.Count = -1
MW2022HUD.Ammo.Lethals.Material = nil
MW2022HUD.Ammo.Tacticals.Count = -1
MW2022HUD.Ammo.Tacticals.Material = nil

MW2022HUD.Ammo.EnableFiremodeNotice = CreateClientConVar("MW2022HUD_EnableAmmoFiremodeNotice", 1, true, true, "Enable the firemode notice text whenever you switch weapons or firemodes.", 0, 1)

MW2022HUD.Ammo.ARC9TriviaCaliberKeys = {} -- see GetARC9Caliber(); also these are not keys as in keyboard keys but rather table keys

local function GetARC9Caliber(wep)
    -- basically? this is a GIANT HEURISTIC to find calibers.
    -- only works properly for English, obviously, as trivia is fully customizable in ARC9...
    
    -- if you don't play GMod in English...I'm sorry...

    -- uncomment the print() calls here if you'd like to see how this works behind the scenes

    if MW2022HUD.Ammo.ARC9TriviaCaliberKeys[MW2022HUD.WeaponData.ClassName] then
        -- print("CACHED KEY: " .. MW2022HUD.Ammo.ARC9TriviaCaliberKeys[MW2022HUD.WeaponData.ClassName])
        -- print("- WEAPON: " .. MW2022HUD.WeaponData.ClassName)

        -- I'm...aware this looks disastrous...deranged even...
        return (ARC9:GetPhrase(wep.Trivia[MW2022HUD.Ammo.ARC9TriviaCaliberKeys[MW2022HUD.WeaponData.ClassName]])
            or wep.Trivia[MW2022HUD.Ammo.ARC9TriviaCaliberKeys[MW2022HUD.WeaponData.ClassName]])
    end

    -- print(" ")
    for k,v in pairs(wep.Trivia) do
        -- print(k)
        local TriviaKey = ARC9:GetPhrase(string.sub(k, 0, #k-1)) or string.sub(k, 0, #k-1)
        local TriviaKeyAlt = ARC9:GetPhrase(k) or k
        -- print(TriviaKey)
        if string.match(TriviaKey, "Caliber") or string.match(TriviaKey, "Calibre") then
            -- print(ARC9:GetPhrase(wep.Trivia[k]) or wep.Trivia[k])
            MW2022HUD.Ammo.ARC9TriviaCaliberKeys[MW2022HUD.WeaponData.ClassName] = k
            return (ARC9:GetPhrase(wep.Trivia[k]) or wep.Trivia[k])
        end

        if string.match(TriviaKeyAlt, "Caliber") or string.match(TriviaKeyAlt, "Calibre") then
            -- print(ARC9:GetPhrase(wep.Trivia[k]) or wep.Trivia[k])
            MW2022HUD.Ammo.ARC9TriviaCaliberKeys[MW2022HUD.WeaponData.ClassName] = k
            return (ARC9:GetPhrase(wep.Trivia[k]) or wep.Trivia[k])
        end
    end
end

MW2022HUD.Ammo.SetupWeaponData = function()
    local ply = LocalPlayer()
    MW2022HUD.Weapon = ply:GetActiveWeapon()
    if !IsValid(MW2022HUD.Weapon) then return end

    MW2022HUD.WeaponData.ClassName = MW2022HUD.Weapon:GetClass()

    MW2022HUD.WeaponData.CurrentMag = math.max(MW2022HUD.Weapon:Clip1(), 0)
    MW2022HUD.WeaponData.CurrentMagAlt = math.max(MW2022HUD.Weapon:Clip2(), 0)
    MW2022HUD.WeaponData.MaxMag = MW2022HUD.Weapon:GetMaxClip1()
    MW2022HUD.WeaponData.MaxMagAlt = MW2022HUD.Weapon:GetMaxClip2()

    MW2022HUD.WeaponData.AmmoType = MW2022HUD.Weapon:GetPrimaryAmmoType()
    MW2022HUD.WeaponData.AmmoTypeAlt = MW2022HUD.Weapon:GetSecondaryAmmoType()

    MW2022HUD.WeaponData.AmmoTypeName = MW2022HUD.Weapon.ArcCW and (MW2022HUD.Weapon:GetBuff_Override("Override_Trivia_Calibre") or MW2022HUD.Weapon.Trivia_Calibre)
        or MW2022HUD.Weapon.ARC9 and GetARC9Caliber(MW2022HUD.Weapon) -- ARC9 caliber reading is very hacky heuristics driven and only works in English, unfortunately
        or language.GetPhrase(game.GetAmmoName(MW2022HUD.WeaponData.AmmoType) or "Melee/Tool")
    MW2022HUD.WeaponData.AmmoTypeAltName = language.GetPhrase(game.GetAmmoName(MW2022HUD.WeaponData.AmmoTypeAlt) or "Melee/Tool")

    MW2022HUD.WeaponData.Reserve = ply:GetAmmoCount(MW2022HUD.WeaponData.AmmoType)
    MW2022HUD.WeaponData.ReserveAlt = ply:GetAmmoCount(MW2022HUD.WeaponData.AmmoTypeAlt)

    MW2022HUD.WeaponData.TotalAmmo = MW2022HUD.WeaponData.CurrentMag + MW2022HUD.WeaponData.Reserve
    MW2022HUD.WeaponData.TotalAmmoAlt = MW2022HUD.WeaponData.CurrentMagAlt + MW2022HUD.WeaponData.ReserveAlt

    MW2022HUD.WeaponData.FireMode, MW2022HUD.WeaponData.FireType, MW2022HUD.WeaponData.Safety, MW2022HUD.WeaponData.UBGL = MW2022HUD.GetFiremode(MW2022HUD.Weapon)

    -- Swap values around if we're using underbarrel
    if !MW2022HUD.WeaponData.UBGL then return end
    MW2022HUD.WeaponData.CurrentMag, MW2022HUD.WeaponData.CurrentMagAlt = MW2022HUD.WeaponData.CurrentMagAlt, MW2022HUD.WeaponData.CurrentMag
    MW2022HUD.WeaponData.MaxMag, MW2022HUD.WeaponData.MaxMagAlt = MW2022HUD.WeaponData.MaxMagAlt, MW2022HUD.WeaponData.MaxMag
    MW2022HUD.WeaponData.Reserve, MW2022HUD.WeaponData.ReserveAlt = MW2022HUD.WeaponData.ReserveAlt, MW2022HUD.WeaponData.Reserve
end

MW2022HUD.GetFiremode = function(wep)
    local firemode, firetype, safety, ubgl = "???", 1, false, false

    if wep.ARC9 then
        firemode = wep:GetFiremodeName()
        safety = wep:GetSafe()
        ubgl = wep:GetUBGL()

        -- behold the insanity
        firetype = wep:GetCurrentFiremodeTable().Mode
        firetype = safety and 5 or firetype < 0 and 4 or firetype > 1 and math.min(firetype, 3) or 1
    elseif wep.ArcCW then
        firemode = wep:GetFiremodeName()
        safety = wep:GetCurrentFiremode().Mode == 0 and true or false
        ubgl = wep:GetInUBGL()

        firetype = wep:GetCurrentFiremode().Mode
        firetype = firetype == 0 and 5 or firetype == 1 and 1 or firetype >= 2 and 4 or firetype < 0 and math.Clamp(math.abs(firetype), 2, 3)
    elseif weapons.IsBasedOn(wep:GetClass(), "mg_base") then
        safety = wep:HasFlag("Lowered")
        ubgl = wep:HasFlag("UsingUnderbarrel")
        firemode = safety and "LOWERED" or ubgl and (wep:GetUnderbarrel() != nil and wep:GetUnderbarrel().Name or "Altfire")
            or string.upper(wep.Firemodes[wep:GetFiremode()].Name)

        firetype = safety and 5 or wep.Primary.Automatic and 4 or wep.Primary.BurstRounds > 1 and math.Clamp(wep.Primary.BurstRounds, 2, 3) or 1
    end

    return firemode, firetype, safety, ubgl
end

MW2022HUD.DrawWeaponIcon = function(wep, x, y, w, h)
    local offx, offy, sclw, sclh = 0, 0, MW2022HUD.WeaponIconRTWidth, MW2022HUD.WeaponIconRTHeight
    local class = MW2022HUD.WeaponData.ClassName
    if MW2022HUD.WeaponIconOffsets[class] and !MW2022HUD.Debug.DisableWeaponIconScaling:GetBool() then
        local scalemod = MW2022HUD.WeaponIconOffsets[class][3]
        offx = MW2022HUD.WeaponIconOffsets[class][1] * MW2022HUD.Scale + (sclw / 2 * (1 - scalemod))
        offy = MW2022HUD.WeaponIconOffsets[class][2] * MW2022HUD.Scale + (sclh / 2 * (1 - scalemod))
        sclw = sclw * scalemod
        sclh = sclh * scalemod
    end

    render.PushRenderTarget(MW2022HUD.WeaponIconRT)
    cam.Start2D()
    render.Clear(0,0,0,0,true,true)
    if wep.DrawWeaponSelection then
        local oldDrawInfo = wep.PrintWeaponInfo
        wep.PrintWeaponInfo = MW2022HUD.NullFunction
        wep:DrawWeaponSelection(offx, offy, sclw, sclh, 255)
        wep.PrintWeaponInfo = oldDrawInfo
    end
    DrawColorModify(MW2022HUD.WeaponIconColorCorrect)
    cam.End2D()
    render.PopRenderTarget()

    surface.SetMaterial(MW2022HUD.WeaponIconRTMat)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(x, y, w, h)
end

MW2022HUD.Ammo.Draw = function()
    draw.NoTexture()
    surface.SetDrawColor(166,177,179)
    surface.DrawRect(MW2022HUD.RightMargin - 150 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 125 * MW2022HUD.Scale, 2 * MW2022HUD.Scale, 50 * MW2022HUD.Scale)

    if !LocalPlayer():Alive() then return end

    if MW2022HUD.Ammo.Lethals.Count > -1 then
        surface.SetMaterial(MW2022HUD.Ammo.Lethals.Material)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(MW2022HUD.RightMargin - 69 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 116 * MW2022HUD.Scale, 36 * MW2022HUD.Scale, 36 * MW2022HUD.Scale)
        draw.SimpleTextOutlined(MW2022HUD.Ammo.Lethals.Count, "MW2022AmmoSmall", MW2022HUD.RightMargin - 55 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 139 * MW2022HUD.Scale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    else
        surface.DrawCircle(MW2022HUD.RightMargin - 55 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 101 * MW2022HUD.Scale, 4 * MW2022HUD.Scale, color_white)
    end
    if MW2022HUD.Ammo.Tacticals.Count > -1 then
        surface.SetMaterial(MW2022HUD.Ammo.Tacticals.Material)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(MW2022HUD.RightMargin - 130 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 116 * MW2022HUD.Scale, 36 * MW2022HUD.Scale, 36 * MW2022HUD.Scale)
        draw.SimpleTextOutlined(MW2022HUD.Ammo.Tacticals.Count, "MW2022AmmoSmall", MW2022HUD.RightMargin - 115 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 139 * MW2022HUD.Scale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    else
        surface.DrawCircle(MW2022HUD.RightMargin - 115 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 101 * MW2022HUD.Scale, 4 * MW2022HUD.Scale, color_white)
    end

    -- weapon block below here; result of LocalPlayer():GetActiveWeapon() becomes invalid before LocalPlayer():Alive() returns false for some reason
    --   so this is needed to ensure hud doesn't blow into pieces
    if !IsValid(MW2022HUD.Weapon) then return end
    
    if !IsValid(MW2022HUD.LastWeapon) or MW2022HUD.LastWeapon != MW2022HUD.Weapon then
        WeaponNameTime = CurTime() + (5/3) -- the actual MWII HUD keeps this on screen for 100 frames (60fps) ≈ 1.66666666... seconds
        AmmoTypeTime = CurTime() + (5/3)
        FiremodeNoticeTime = CurTime() + (5/3)
        MW2022HUD.LastWeapon = MW2022HUD.Weapon
        MW2022HUD.LastUBState = MW2022HUD.WeaponData.UBGL
        WeaponNameColor.a = 0
        WeaponNameOutline.a = 0
        AmmoTypeNameColor.a = 0
        AmmoTypeNameOutline.a = 0
    elseif MW2022HUD.LastUBState != MW2022HUD.WeaponData.UBGL then
        AmmoTypeTime = CurTime() + (5/3)
        MW2022HUD.LastUBState = MW2022HUD.WeaponData.UBGL
        AmmoTypeNameColor.a = 255
        AmmoTypeNameOutline.a = 55
    elseif MW2022HUD.LastFiremode != MW2022HUD.WeaponData.FireMode then
        FiremodeNoticeTime = CurTime() + (5/3)
        MW2022HUD.LastFiremode = MW2022HUD.WeaponData.FireMode
    end

    WeaponNameColor.a = WeaponNameTime > CurTime() and math.Approach(WeaponNameColor.a, 255, FrameTime() * 6 * 255)
        or math.Approach(WeaponNameColor.a, 0, FrameTime() * 6 * 255)
    WeaponNameOutline.a = WeaponNameTime > CurTime() and math.Approach(WeaponNameOutline.a, 55, FrameTime() * 6 * 55)
        or math.Approach(WeaponNameOutline.a, 0, FrameTime() * 6 * 55)
    AmmoTypeNameColor.a = AmmoTypeTime > CurTime() and math.Approach(AmmoTypeNameColor.a, 255, FrameTime() * 6 * 255)
        or math.Approach(AmmoTypeNameColor.a, 0, FrameTime() * 6 * 255)
    AmmoTypeNameOutline.a = AmmoTypeTime > CurTime() and math.Approach(AmmoTypeNameOutline.a, 55, FrameTime() * 6 * 55)
        or math.Approach(AmmoTypeNameOutline.a, 0, FrameTime() * 6 * 55)
    FiremodeNoticeColor.a = 255 * math.Clamp((FiremodeNoticeTime - 0.5 - CurTime()) * 4, 0, 1)
    FiremodeNoticeOutline.a = 55 * math.Clamp((FiremodeNoticeTime - 0.5 - CurTime()) * 4, 0, 1)

    if !MW2022HUD.WeaponIconPrerenders[MW2022HUD.WeaponData.ClassName] then
    MW2022HUD.DrawWeaponIcon(MW2022HUD.Weapon, MW2022HUD.RightMargin - 500 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 173 * MW2022HUD.Scale, 280 * MW2022HUD.Scale, 140 * MW2022HUD.Scale)
    else
        surface.SetMaterial(MW2022HUD.WeaponIconPrerenders[MW2022HUD.WeaponData.ClassName])
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(MW2022HUD.RightMargin - 500 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 173 * MW2022HUD.Scale, 280 * MW2022HUD.Scale, 140 * MW2022HUD.Scale)
    end
    -- surface.DrawOutlinedRect(MW2022HUD.RightMargin - 500 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 173 * MW2022HUD.Scale, 280 * MW2022HUD.Scale, 140 * MW2022HUD.Scale)

    draw.SimpleTextOutlined(MW2022HUD.Weapon:GetPrintName(), "MW2022AmmoSmall", MW2022HUD.RightMargin - 400 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 181 * MW2022HUD.Scale, WeaponNameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, WeaponNameOutline)
    draw.SimpleTextOutlined(MW2022HUD.WeaponData.UBGL and MW2022HUD.WeaponData.AmmoTypeAltName or MW2022HUD.WeaponData.AmmoTypeName, "MW2022AmmoType", MW2022HUD.RightMargin - 402 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 161 * MW2022HUD.Scale,
        AmmoTypeNameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, AmmoTypeNameOutline)

    if MW2022HUD.WeaponData.AmmoType == -1 then return end

    if MW2022HUD.WeaponData.MaxMag == -1 then
        draw.SimpleTextOutlined(MW2022HUD.WeaponData.UBGL and MW2022HUD.WeaponData.TotalAmmoAlt or MW2022HUD.WeaponData.TotalAmmo, "MW2022AmmoLarge", MW2022HUD.RightMargin - 160 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 131 * MW2022HUD.Scale,
            MW2022HUD.WeaponData.CurrentMag >= MW2022HUD.WeaponData.MaxMag * 0.3 and color_white or LowRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    else
        -- CoD seems to use some kind of TTK based detection for low ammo threshold or something? Waaaaay out of scope of what I can do though...
        draw.SimpleTextOutlined(MW2022HUD.WeaponData.CurrentMag, "MW2022AmmoLarge", MW2022HUD.RightMargin - 160 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 131 * MW2022HUD.Scale,
            MW2022HUD.WeaponData.CurrentMag >= MW2022HUD.WeaponData.MaxMag * 0.3 and color_white or LowRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
        draw.SimpleTextOutlined(MW2022HUD.WeaponData.Reserve, "MW2022AmmoSmall", MW2022HUD.RightMargin - 160 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 91 * MW2022HUD.Scale,
            MW2022HUD.WeaponData.Reserve > 0 and ReserveGray or LowRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    end

    if MW2022HUD.Weapon.ARC9 and MW2022HUD.Weapon:GetJammed() or MW2022HUD.Weapon.ArcCW and MW2022HUD.Weapon:GetMalfunctionJam() then
        local reloadkey = string.upper(input.LookupBinding("+reload") or "???")

        surface.SetFont("MW2022Keybinds")
        local boxw, boxh = select(1, surface.GetTextSize(reloadkey))
        boxw = boxw + 12 * MW2022HUD.Scale
        boxh = boxh - 2 * MW2022HUD.Scale

        surface.SetFont("MW2022AmmoNotice")
        local offsetw = boxw + select(1, surface.GetTextSize("CLEAR MALFUNCTION")) + 5 * MW2022HUD.Scale

        draw.RoundedBox(4, MW2022HUD.ScreenWidth / 2 - offsetw / 2 - 1 * MW2022HUD.Scale, MW2022HUD.ScreenHeight / 2 + 91 * MW2022HUD.Scale, boxw + 2 * MW2022HUD.Scale, boxh + 2 * MW2022HUD.Scale, BackgroundBlack)
        draw.RoundedBox(4, MW2022HUD.ScreenWidth / 2 - offsetw / 2, MW2022HUD.ScreenHeight / 2 + 92 * MW2022HUD.Scale, boxw, boxh, color_white)
        draw.SimpleText(reloadkey, "MW2022Keybinds", MW2022HUD.ScreenWidth / 2 - offsetw / 2 + 5 * MW2022HUD.Scale, MW2022HUD.ScreenHeight / 2 + 91 * MW2022HUD.Scale, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        draw.SimpleTextOutlined("CLEAR MALFUNCTION", "MW2022AmmoNotice", MW2022HUD.ScreenWidth / 2 - offsetw / 2 + 29 * MW2022HUD.Scale, MW2022HUD.ScreenHeight / 2 + 88 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    elseif MW2022HUD.WeaponData.CurrentMag + MW2022HUD.WeaponData.Reserve <= 0 then
        draw.SimpleTextOutlined("NO AMMO", "MW2022AmmoNotice", MW2022HUD.ScreenWidth / 2, MW2022HUD.ScreenHeight / 2 + 90 * MW2022HUD.Scale, LowRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    elseif MW2022HUD.WeaponData.CurrentMag < MW2022HUD.WeaponData.MaxMag * 0.3 and MW2022HUD.WeaponData.Reserve <= 0 then
        draw.SimpleTextOutlined("LOW AMMO", "MW2022AmmoNotice", MW2022HUD.ScreenWidth / 2, MW2022HUD.ScreenHeight / 2 + 90 * MW2022HUD.Scale, LowYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    elseif MW2022HUD.WeaponData.CurrentMag < MW2022HUD.WeaponData.MaxMag * 0.3 then
        local reloadkey = string.upper(input.LookupBinding("+reload") or "???")

        surface.SetFont("MW2022Keybinds")
        local boxw, boxh = select(1, surface.GetTextSize(reloadkey))
        boxw = boxw + 12 * MW2022HUD.Scale
        boxh = boxh - 2 * MW2022HUD.Scale

        surface.SetFont("MW2022AmmoNotice")
        local offsetw = boxw + select(1, surface.GetTextSize("RELOAD")) + 5 * MW2022HUD.Scale

        draw.RoundedBox(4, MW2022HUD.ScreenWidth / 2 - offsetw / 2 - 1 * MW2022HUD.Scale, MW2022HUD.ScreenHeight / 2 + 91 * MW2022HUD.Scale, boxw + 2 * MW2022HUD.Scale, boxh + 2 * MW2022HUD.Scale, BackgroundBlack)
        draw.RoundedBox(4, MW2022HUD.ScreenWidth / 2 - offsetw / 2, MW2022HUD.ScreenHeight / 2 + 92 * MW2022HUD.Scale, boxw, boxh, color_white)
        draw.SimpleText(reloadkey, "MW2022Keybinds", MW2022HUD.ScreenWidth / 2 - offsetw / 2 + 5 * MW2022HUD.Scale, MW2022HUD.ScreenHeight / 2 + 91 * MW2022HUD.Scale, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        draw.SimpleTextOutlined("RELOAD", "MW2022AmmoNotice", MW2022HUD.ScreenWidth / 2 - offsetw / 2 + 29 * MW2022HUD.Scale, MW2022HUD.ScreenHeight / 2 + 88 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    end

    if MW2022HUD.Ammo.EnableFiremodeNotice:GetBool() and FiremodeNoticeTime > CurTime() then
        local FiremodeColor = Color(255,255,255)
        FiremodeColor = FiremodeColor:Lerp(Color(212,153,59), -math.sin(math.Clamp(-(FiremodeNoticeTime - (5/3) - CurTime()) * math.pi * 15, 0, math.pi * 6)))
        FiremodeColor.a = FiremodeNoticeColor.a
        local FireTypeString = string.upper(MW2022HUD.WeaponData.UBGL and "Altfire: " or "Fire Type: ")
        local Firemode = string.upper(MW2022HUD.WeaponData.FireMode)

        surface.SetFont("MW2022FiremodeNotice")
        local w1, _ = surface.GetTextSize(FireTypeString)
        local w2, _ = surface.GetTextSize(Firemode)
        local totalw = w1 + w2
        draw.SimpleTextOutlined(FireTypeString, "MW2022FiremodeNotice", MW2022HUD.ScreenWidth / 2 - totalw / 2, MW2022HUD.ScreenHeight / 2 + 95 * MW2022HUD.Scale, FiremodeNoticeColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, FiremodeNoticeOutline)
        draw.SimpleTextOutlined(Firemode, "MW2022FiremodeNotice", MW2022HUD.ScreenWidth / 2 - totalw / 2 + w1, MW2022HUD.ScreenHeight / 2 + 95 * MW2022HUD.Scale, FiremodeColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, FiremodeNoticeOutline)

        local barlength = w2 * math.Clamp(-(FiremodeNoticeTime - (5/3) - CurTime()) * 15, 0, 1)
        surface.SetDrawColor(FiremodeNoticeColor)
        surface.DrawRect(MW2022HUD.ScreenWidth / 2 + totalw / 2 - barlength, MW2022HUD.ScreenHeight / 2 + 108 * MW2022HUD.Scale + 20 * MW2022HUD.Scale, barlength, 2 * MW2022HUD.Scale)
    end
    
    surface.SetDrawColor(color_white)
    surface.SetMaterial(MW2022HUD.Materials.FireGroups[MW2022HUD.WeaponData.FireType][1])
    surface.DrawTexturedRect(MW2022HUD.RightMargin - 287 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 66 * MW2022HUD.Scale, 30 * MW2022HUD.Scale, 30 * MW2022HUD.Scale)
    
    if MW2022HUD.WeaponData.AmmoTypeAlt != -1 then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(MW2022HUD.Materials.FireGroups[1][1])
        surface.DrawTexturedRect(MW2022HUD.RightMargin - 326 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 66 * MW2022HUD.Scale, 30 * MW2022HUD.Scale, 30 * MW2022HUD.Scale)

        surface.DrawRect(MW2022HUD.RightMargin - 294 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 66 * MW2022HUD.Scale, 1 * MW2022HUD.Scale, 30 * MW2022HUD.Scale)
    end

    if MW2022HUD.WeaponData.UBGL then
        draw.NoTexture()
        surface.DrawRect(MW2022HUD.RightMargin - 325 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 36 * MW2022HUD.Scale, 26 * MW2022HUD.Scale, 2 * MW2022HUD.Scale)

        draw.SimpleTextOutlined(MW2022HUD.WeaponData.FireMode, "MW2022AmmoSmall", MW2022HUD.RightMargin - 335 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 62 * MW2022HUD.Scale, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    else
        draw.NoTexture()
        surface.DrawRect(MW2022HUD.RightMargin - 287 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 36 * MW2022HUD.Scale, 26 * MW2022HUD.Scale, 2 * MW2022HUD.Scale)
        
        draw.SimpleTextOutlined(MW2022HUD.WeaponData.FireMode, "MW2022AmmoSmall", MW2022HUD.RightMargin - 249 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 62 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)

        if MW2022HUD.WeaponData.AmmoTypeAlt != -1 then
            draw.SimpleTextOutlined(MW2022HUD.WeaponData.TotalAmmoAlt, "MW2022AmmoSmall", MW2022HUD.RightMargin - 335 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 62 * MW2022HUD.Scale, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
        end
    end
end

concommand.Add("MW2022HUD_AddWeaponIconOffset", function(ply, cmd, args)
    local x, y, scale = args
    MW2022HUD.WeaponIconOffsets[LocalPlayer():GetActiveWeapon():GetClass()] = x, y, scale
    file.Write("mw2022weaponiconoffsets.txt", util.Compress(util.TableToJSON(MW2022HUD.WeaponIconOffsets)))
end)

print("[MWIIHUD] Weapon info module loaded")