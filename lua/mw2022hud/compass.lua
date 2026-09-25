MW2022HUD.Compass = {}

MW2022HUD.Materials.Compass = Material("iw9ui/hud_compass_location_backer.png", "noclamp smooth")
MW2022HUD.Materials.CompassTickerMask2 = Material("mw2022/compass_tickertape_mask.png")
MW2022HUD.Materials.CompassBacker = Material("mw2022/compass_tickertape_backing.png")

MW2022HUD.Compass.CompassTickerRT = GetRenderTarget("MW5CompassTicker", 1280, 40)
MW2022HUD.Materials.CompassTickerRT = CreateMaterial( 
    "MW5CompassTickerMat","UnlitGeneric",
    {
        ["$basetexture"] = MW2022HUD.Compass.CompassTickerRT:GetName(),
        ["$translucent"] = "1"
    } 
)

local CompassAngles = {0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,225,240,255,270,285,300,315,330,345} 
local CompassAnglesText = {"N",15,30,"NE",60,75,"E",105,120,"SE",150,165,"S",195,210,"SW",240,255,"W",285,300,"NW",330,345} 

local CompassAngleColor = color_white:Copy()

local OutlineBlack = Color(66,66,66,55)

MW2022HUD.Compass.Draw = function()
    if !MW2022HUD.EnableCompass:GetBool() then return end

    local ply = LocalPlayer()

    local dir = ply:ShouldDrawLocalPlayer() and ply:EyeAngles().y or EyeAngles().y
    dir = -math.Remap(dir, -180, 180, -360, 0)
    local cardinal = ""

    if (math.abs(math.AngleDifference(dir, 0))) < 67.5 then cardinal = cardinal .. "N"
    elseif (math.abs(math.AngleDifference(dir, 180))) < 67.5 then cardinal = cardinal .. "S" end
    if (math.abs(math.AngleDifference(dir, 90))) < 67.5 then cardinal = cardinal .. "E"
    elseif (math.abs(math.AngleDifference(dir, 270))) < 67.5 then cardinal = cardinal .. "W" end

    render.PushRenderTarget(MW2022HUD.Compass.CompassTickerRT)
    cam.Start2D()
    render.Clear(0,0,0,0,true,true)
    surface.SetMaterial(MW2022HUD.Materials.CompassBacker)
    surface.SetDrawColor(255,255,255,160)
    surface.DrawTexturedRect(0, 0, 1280, 40)
    for i=1,360 do
        surface.SetDrawColor(color_white)
        surface.DrawRect(640 - math.floor(math.AngleDifference(dir, i) * 13.6), 37, 1, 3)
    end
    for i=1,#CompassAngles do
        draw.DrawText(CompassAnglesText[i], CompassAngles[i] % 45 == 0 and "MW2022CompassAngles" or "MW2022CompassAnglesSmall",
            640 - math.floor(math.AngleDifference(dir, CompassAngles[i]) * 13.6),
            (6 + (CompassAngles[i] % 45 == 0 and 6 or 12)), color_white, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(color_white)
        surface.DrawRect(640 - math.floor(math.AngleDifference(dir, CompassAngles[i]) * MW2022HUD.Scale * 13.6),
            34, 1, 6)
    end
    render.SetWriteDepthToDestAlpha(false)
	render.OverrideBlend(true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, BLENDFUNC_MIN)
        surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(MW2022HUD.Materials.CompassTickerMask2)
		surface.DrawTexturedRect(0, 0, 1280, 40)
	render.OverrideBlend(false)
    render.SetWriteDepthToDestAlpha(true)
    cam.End2D()
    render.PopRenderTarget()

    surface.SetMaterial(MW2022HUD.Materials.CompassTickerRT)
    surface.SetDrawColor(255,255,255,255)
    surface.DrawTexturedRect(MW2022HUD.ScreenWidth * 0.5 - 640 * MW2022HUD.Scale, MW2022HUD.TopMargin, 1280 * MW2022HUD.Scale, 40)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(MW2022HUD.Materials.GradientL)
    surface.DrawTexturedRect(MW2022HUD.ScreenWidth * 0.5, MW2022HUD.TopMargin + 40, 200 * MW2022HUD.Scale, 1)
    surface.SetMaterial(MW2022HUD.Materials.GradientR)
    surface.DrawTexturedRect(MW2022HUD.ScreenWidth * 0.5 - 200 * MW2022HUD.Scale, MW2022HUD.TopMargin + 40, 200 * MW2022HUD.Scale, 1)
    surface.SetMaterial(MW2022HUD.Materials.GradientU)
    surface.DrawTexturedRect(MW2022HUD.ScreenWidth * 0.5 - 1 * 0.5, MW2022HUD.TopMargin, 1, 40)

    draw.NoTexture()

    surface.SetDrawColor(color_white)
    surface.DrawRect(MW2022HUD.ScreenWidth * 0.5 - 1 * 0.5, MW2022HUD.TopMargin + 40, 1, 21)

    draw.SimpleTextOutlined(math.abs(math.floor(dir)), "MW2022CompassText", MW2022HUD.ScreenWidth * 0.5 + 5, MW2022HUD.TopMargin + 43, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    draw.SimpleTextOutlined(cardinal, "MW2022CompassText", MW2022HUD.ScreenWidth * 0.5 - 5, MW2022HUD.TopMargin + 43, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
end

print("[MWIIHUD] Compass loaded")