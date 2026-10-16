MW2022HUD.Ammo = {}
MW2022HUD.Weapon = nil
MW2022HUD.LastWeapon = nil

local lastUBState = false
local lastFiremode = "AUTO"
local weaponData = {}

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

MW2022HUD.Ammo.SetupWeaponData = function()
    local ply = LocalPlayer()
    MW2022HUD.Weapon = ply:GetActiveWeapon()
    if !IsValid(MW2022HUD.Weapon) then return end

    weaponData.ClassName = MW2022HUD.Weapon:GetClass()

    weaponData.CurrentMag = math.max(MW2022HUD.Weapon:Clip1(), 0)
    weaponData.CurrentMagAlt = math.max(MW2022HUD.Weapon:Clip2(), 0)
    weaponData.MaxMag = MW2022HUD.Weapon:GetMaxClip1()
    weaponData.MaxMagAlt = MW2022HUD.Weapon:GetMaxClip2()

    weaponData.AmmoType = MW2022HUD.Weapon:GetPrimaryAmmoType()
    weaponData.AmmoTypeAlt = MW2022HUD.Weapon:GetSecondaryAmmoType()

    weaponData.AmmoTypeName = MW2022HUD.WeaponExtensions.GetCaliber(MW2022HUD.Weapon) or language.GetPhrase(game.GetAmmoName(weaponData.AmmoType) or "Melee/Tool")
    weaponData.AmmoTypeAltName = language.GetPhrase(game.GetAmmoName(weaponData.AmmoTypeAlt) or "Melee/Tool")

    weaponData.Reserve = ply:GetAmmoCount(weaponData.AmmoType)
    weaponData.ReserveAlt = ply:GetAmmoCount(weaponData.AmmoTypeAlt)

    weaponData.TotalAmmo = weaponData.CurrentMag + weaponData.Reserve
    weaponData.TotalAmmoAlt = weaponData.CurrentMagAlt + weaponData.ReserveAlt

    MW2022HUD.WeaponExtensions.GetWeaponBase(MW2022HUD.Weapon)

    weaponData.FireModeSupport, weaponData.FireMode, weaponData.FireType, weaponData.Safety, weaponData.UBGL = MW2022HUD.WeaponExtensions.GetFiremode(MW2022HUD.Weapon)

    -- Swap values around if we're using underbarrel
    if !weaponData.UBGL then return end
    weaponData.CurrentMag, weaponData.CurrentMagAlt = weaponData.CurrentMagAlt, weaponData.CurrentMag
    weaponData.MaxMag, weaponData.MaxMagAlt = weaponData.MaxMagAlt, weaponData.MaxMag
    weaponData.Reserve, weaponData.ReserveAlt = weaponData.ReserveAlt, weaponData.Reserve
end

MW2022HUD.DrawWeaponIcon = function(wep, x, y, w, h)
    local offx, offy, sclw, sclh = 0, 0, MW2022HUD.WeaponIconRTWidth, MW2022HUD.WeaponIconRTHeight
    local class = weaponData.ClassName
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
        MW2022HUD.LastUBState = weaponData.UBGL
        WeaponNameColor.a = 0
        WeaponNameOutline.a = 0
        AmmoTypeNameColor.a = 0
        AmmoTypeNameOutline.a = 0
    elseif MW2022HUD.LastUBState != weaponData.UBGL then
        AmmoTypeTime = CurTime() + (5/3)
        MW2022HUD.LastUBState = weaponData.UBGL
        AmmoTypeNameColor.a = 255
        AmmoTypeNameOutline.a = 55
    elseif MW2022HUD.LastFiremode != weaponData.FireMode then
        FiremodeNoticeTime = CurTime() + (5/3)
        MW2022HUD.LastFiremode = weaponData.FireMode
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

    if !MW2022HUD.WeaponIconPrerenders[weaponData.ClassName] then
    MW2022HUD.DrawWeaponIcon(MW2022HUD.Weapon, MW2022HUD.RightMargin - 500 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 173 * MW2022HUD.Scale, 280 * MW2022HUD.Scale, 140 * MW2022HUD.Scale)
    else
        surface.SetMaterial(MW2022HUD.WeaponIconPrerenders[weaponData.ClassName])
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(MW2022HUD.RightMargin - 500 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 173 * MW2022HUD.Scale, 280 * MW2022HUD.Scale, 140 * MW2022HUD.Scale)
    end
    -- surface.DrawOutlinedRect(MW2022HUD.RightMargin - 500 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 173 * MW2022HUD.Scale, 280 * MW2022HUD.Scale, 140 * MW2022HUD.Scale)

    draw.SimpleTextOutlined(MW2022HUD.Weapon:GetPrintName(), "MW2022AmmoSmall", MW2022HUD.RightMargin - 400 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 181 * MW2022HUD.Scale, WeaponNameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, WeaponNameOutline)
    draw.SimpleTextOutlined(weaponData.UBGL and weaponData.AmmoTypeAltName or weaponData.AmmoTypeName, "MW2022AmmoType", MW2022HUD.RightMargin - 402 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 161 * MW2022HUD.Scale,
        AmmoTypeNameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, AmmoTypeNameOutline)

    if weaponData.AmmoType == -1 then return end

    if weaponData.MaxMag == -1 then
        draw.SimpleTextOutlined(weaponData.UBGL and weaponData.TotalAmmoAlt or weaponData.TotalAmmo, "MW2022AmmoLarge", MW2022HUD.RightMargin - 160 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 131 * MW2022HUD.Scale,
            weaponData.CurrentMag >= weaponData.MaxMag * 0.3 and color_white or LowRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    else
        -- CoD seems to use some kind of TTK based detection for low ammo threshold or something? Waaaaay out of scope of what I can do though...
        draw.SimpleTextOutlined(weaponData.CurrentMag, "MW2022AmmoLarge", MW2022HUD.RightMargin - 160 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 131 * MW2022HUD.Scale,
            weaponData.CurrentMag >= weaponData.MaxMag * 0.3 and color_white or LowRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
        draw.SimpleTextOutlined(weaponData.Reserve, "MW2022AmmoSmall", MW2022HUD.RightMargin - 160 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 91 * MW2022HUD.Scale,
            weaponData.Reserve > 0 and ReserveGray or LowRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    end

    if MW2022HUD.WeaponExtensions.GetMalfunctioning(MW2022HUD.Weapon) then
        local reloadkey = string.upper(input.LookupBinding("+reload") or "UNKNOWN")

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
    elseif weaponData.CurrentMag + weaponData.Reserve <= 0 then
        draw.SimpleTextOutlined("NO AMMO", "MW2022AmmoNotice", MW2022HUD.ScreenWidth / 2, MW2022HUD.ScreenHeight / 2 + 90 * MW2022HUD.Scale, LowRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    elseif weaponData.CurrentMag < weaponData.MaxMag * 0.3 and weaponData.Reserve <= 0 then
        draw.SimpleTextOutlined("LOW AMMO", "MW2022AmmoNotice", MW2022HUD.ScreenWidth / 2, MW2022HUD.ScreenHeight / 2 + 90 * MW2022HUD.Scale, LowYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    elseif weaponData.CurrentMag < weaponData.MaxMag * 0.3 then
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

    if !weaponData.FireModeSupport then return end

    if MW2022HUD.Ammo.EnableFiremodeNotice:GetBool() and FiremodeNoticeTime > CurTime() then
        local FiremodeColor = Color(255,255,255)
        FiremodeColor = FiremodeColor:Lerp(Color(212,153,59), -math.sin(math.Clamp(-(FiremodeNoticeTime - (5/3) - CurTime()) * math.pi * 15, 0, math.pi * 6)))
        FiremodeColor.a = FiremodeNoticeColor.a
        local FireTypeString = string.upper(weaponData.UBGL and "Altfire: " or "Fire Type: ")
        local Firemode = string.upper(weaponData.FireMode)

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
    surface.SetMaterial(MW2022HUD.Materials.FireGroups[weaponData.FireType][1])
    surface.DrawTexturedRect(MW2022HUD.RightMargin - 287 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 66 * MW2022HUD.Scale, 30 * MW2022HUD.Scale, 30 * MW2022HUD.Scale)
    
    if weaponData.AmmoTypeAlt != -1 then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(MW2022HUD.Materials.FireGroups[1][1])
        surface.DrawTexturedRect(MW2022HUD.RightMargin - 326 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 66 * MW2022HUD.Scale, 30 * MW2022HUD.Scale, 30 * MW2022HUD.Scale)

        surface.DrawRect(MW2022HUD.RightMargin - 294 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 66 * MW2022HUD.Scale, 1 * MW2022HUD.Scale, 30 * MW2022HUD.Scale)
    end

    if weaponData.UBGL then
        draw.NoTexture()
        surface.DrawRect(MW2022HUD.RightMargin - 325 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 36 * MW2022HUD.Scale, 26 * MW2022HUD.Scale, 2 * MW2022HUD.Scale)

        draw.SimpleTextOutlined(weaponData.FireMode, "MW2022AmmoSmall", MW2022HUD.RightMargin - 335 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 62 * MW2022HUD.Scale, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    else
        draw.NoTexture()
        surface.DrawRect(MW2022HUD.RightMargin - 287 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 36 * MW2022HUD.Scale, 26 * MW2022HUD.Scale, 2 * MW2022HUD.Scale)
        
        draw.SimpleTextOutlined(weaponData.FireMode, "MW2022AmmoSmall", MW2022HUD.RightMargin - 249 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 62 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)

        if weaponData.AmmoTypeAlt != -1 then
            draw.SimpleTextOutlined(weaponData.TotalAmmoAlt, "MW2022AmmoSmall", MW2022HUD.RightMargin - 335 * MW2022HUD.Scale, MW2022HUD.BottomMargin - 62 * MW2022HUD.Scale, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
        end
    end
end

concommand.Add("MW2022HUD_AddWeaponIconOffset", function(ply, cmd, args)
    local x, y, scale = args
    MW2022HUD.WeaponIconOffsets[LocalPlayer():GetActiveWeapon():GetClass()] = x, y, scale
    file.Write("mw2022weaponiconoffsets.txt", util.Compress(util.TableToJSON(MW2022HUD.WeaponIconOffsets)))
end)

print("[MWIIHUD] Weapon info module loaded")