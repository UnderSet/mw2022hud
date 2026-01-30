MW2022HUD = MW2022HUD or {}

MW2022HUD.Enable = CreateClientConVar("MW2022HUD_Enable", 1, true, true, "Enable the MW2022 HUD.", 0, 1)
MW2022HUD.XBounds = CreateClientConVar("MW2022HUD_XBounds", 100, true, true, "Set horizontal bounds.", 0, 100)
MW2022HUD.YBounds = CreateClientConVar("MW2022HUD_YBounds", 100, true, true, "Set vertical bounds.", 0, 100)

MW2022HUD.SetupBounds = function()
    MW2022HUD.ScreenWidth = ScrW()
    MW2022HUD.ScreenHeight = ScrH()

    MW2022HUD.Scale = MW2022HUD.ScreenHeight / 1080

    MW2022HUD.BoundsMargin = MW2022HUD.ScreenHeight * 0.07

    -- CoD locks UI to 16:9 no matter your display aspect ratio.
    -- I will not be doing that, at least for now.
    MW2022HUD.RightMargin = MW2022HUD.ScreenWidth + (MW2022HUD.XBounds:GetFloat() - 100) / 100 * MW2022HUD.BoundsMargin
    MW2022HUD.LeftMargin = -((MW2022HUD.XBounds:GetFloat() - 100) / 100 * MW2022HUD.BoundsMargin)
    MW2022HUD.TopMargin = -((MW2022HUD.YBounds:GetFloat() - 100) / 100 * MW2022HUD.BoundsMargin)
    MW2022HUD.BottomMargin = MW2022HUD.ScreenHeight + (MW2022HUD.YBounds:GetFloat() - 100) / 100 * MW2022HUD.BoundsMargin
end

MW2022HUD.Materials = {}
MW2022HUD.Materials.GradientL = Material("vgui/gradient-l")
MW2022HUD.Materials.GradientR = Material("vgui/gradient-r")
MW2022HUD.Materials.GradientU = Material("vgui/gradient_up")

MW2022HUD.NullFunction = function() end

include("mw2022hud/fonts.lua")
include("mw2022hud/compass.lua")
include("mw2022hud/ammo.lua")
include("mw2022hud/score.lua")
include("mw2022hud/drawsystem.lua")

cvars.AddChangeCallback("MW2022HUD_XBounds", MW2022HUD.SetupBounds)
cvars.AddChangeCallback("MW2022HUD_YBounds", MW2022HUD.SetupBounds)
