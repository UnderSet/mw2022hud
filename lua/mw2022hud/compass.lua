MW2022HUD.Compass = {}

MW2022HUD.Materials.Compass = Material("iw9ui/hud_compass_location_backer.png", "noclamp smooth")

local CompassAngles = {0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,225,240,255,270,285,300,315,330,345} 
local CompassAnglesText = {"N",15,30,"NE",60,75,"E",105,120,"SE",150,165,"S",195,210,"SW",240,255,"W",285,300,"NW",330,345} 

local CompassAngleColor = color_white:Copy()

MW2022HUD.Compass.Draw = function()
    if !MW2022HUD.EnableCompass:GetBool() then return end

    local dir = ply:ShouldDrawLocalPlayer() and ply:EyeAngles().y or EyeAngles().y
    dir = -math.Remap(dir, -180, 180, -360, 0)
    local cardinal = ""

    if (math.abs(math.AngleDifference(dir, 0))) < 67.5 then cardinal = cardinal .. "N"
    elseif (math.abs(math.AngleDifference(dir, 180))) < 67.5 then cardinal = cardinal .. "S" end
    if (math.abs(math.AngleDifference(dir, 90))) < 67.5 then cardinal = cardinal .. "E"
    elseif (math.abs(math.AngleDifference(dir, 270))) < 67.5 then cardinal = cardinal .. "W" end

    surface.SetMaterial(MW2022HUD.Materials.Compass)
    surface.SetDrawColor(color_black)
    surface.DrawTexturedRect(MW2022HUD.ScreenWidth * 0.5 - 1400 * MW2022HUD.Scale * 0.5, MW2022HUD.TopMargin, 1400 * MW2022HUD.Scale, 40)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(MW2022HUD.Materials.GradientL)
    surface.DrawTexturedRect(MW2022HUD.ScreenWidth * 0.5, MW2022HUD.TopMargin + 40, 200 * MW2022HUD.Scale, 1)
    surface.SetMaterial(MW2022HUD.Materials.GradientR)
    surface.DrawTexturedRect(MW2022HUD.ScreenWidth * 0.5 - 200 * MW2022HUD.Scale, MW2022HUD.TopMargin + 40, 200 * MW2022HUD.Scale, 1)
    surface.SetMaterial(MW2022HUD.Materials.GradientU)
    surface.DrawTexturedRect(MW2022HUD.ScreenWidth * 0.5 - 1 * 0.5, MW2022HUD.TopMargin, 1, 40)

    draw.NoTexture()

    for i=1,360 do
        CompassAngleColor.a = 255 * (math.max(1 - math.max(math.abs(math.AngleDifference(dir, i)) - 40, 0) * 0.15, 0))
        surface.SetDrawColor(CompassAngleColor)
        surface.DrawRect(MW2022HUD.ScreenWidth / 2 - math.floor(math.AngleDifference(dir, i) * MW2022HUD.Scale * 13.6),
            MW2022HUD.TopMargin + 37 * MW2022HUD.Scale, 1, 3)
    end

    for i=1,#CompassAngles do
        CompassAngleColor.a = 255 * (math.max(1 - math.max(math.abs(math.AngleDifference(dir, CompassAngles[i])) - 40, 0) * 0.15, 0))
        draw.DrawText(CompassAnglesText[i], CompassAngles[i] % 45 == 0 and "MW2022CompassAngles" or "MW2022CompassAnglesSmall",
            MW2022HUD.ScreenWidth / 2 - math.floor(math.AngleDifference(dir, CompassAngles[i]) * MW2022HUD.Scale * 13.6),
            MW2022HUD.TopMargin + (6 + (CompassAngles[i] % 45 == 0 and 6 or 12)) * MW2022HUD.Scale, CompassAngleColor, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(CompassAngleColor)
        surface.DrawRect(MW2022HUD.ScreenWidth / 2 - math.floor(math.AngleDifference(dir, CompassAngles[i]) * MW2022HUD.Scale * 13.6),
            MW2022HUD.TopMargin + 34 * MW2022HUD.Scale, 1, 6)
    end

    surface.SetDrawColor(color_white)
    surface.DrawRect(MW2022HUD.ScreenWidth * 0.5 - 1 * 0.5, MW2022HUD.TopMargin + 40, 1, 21)

    draw.DrawText(math.abs(math.floor(dir)), "MW2022CompassText", MW2022HUD.ScreenWidth * 0.5 + 5, MW2022HUD.TopMargin + 43, color_white, TEXT_ALIGN_LEFT)
    draw.DrawText(cardinal, "MW2022CompassText", MW2022HUD.ScreenWidth * 0.5 - 5, MW2022HUD.TopMargin + 43, color_white, TEXT_ALIGN_RIGHT)
end