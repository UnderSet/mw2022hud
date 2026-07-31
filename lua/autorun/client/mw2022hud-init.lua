MW2022HUD = MW2022HUD or {}
MW2022HUD.Debug = {} -- don't touch this one, will ya?

MW2022HUD.Enable = CreateClientConVar("MW2022HUD_Enable", 1, true, true, "Enable the MW2022 HUD.", 0, 1)
MW2022HUD.EnableCompass = CreateClientConVar("MW2022HUD_EnableCompass", 1, true, true, "Enable the compass at the top of the screen.", 0, 1)
MW2022HUD.EnableMinimap = CreateClientConVar("MW2022HUD_EnableMinimap", 1, true, true, "EXPERIMENTAL: Enable the minimap just above the score display.\nGMinimap REQUIRED TO FUNCTION.", 0, 1)
MW2022HUD.EnableMinimapRotation = CreateClientConVar("MW2022HUD_EnableMinimapRotation", 1, true, true, "Allow the minimap to rotate.", 0, 1)
MW2022HUD.EnableHealth = CreateClientConVar("MW2022HUD_EnableHealth", 1, true, true, "Enable the HUD's health display.\n1: Display health, armor and player name\n2: Display only armor", 0, 2)
MW2022HUD.EnableScore = CreateClientConVar("MW2022HUD_EnableScore", 1, true, true, "Enable the HUD's scoring element.\nNOTE: Only affects if it's displayed in HUD or not. Requires gamemode support.\n1: Show gamemode icon, name and scores at all times\n2: Only show if actively displaying scores", 0, 2)
MW2022HUD.XBounds = CreateClientConVar("MW2022HUD_XBounds", 100, true, true, "Set horizontal bounds.", 0, 100)
MW2022HUD.YBounds = CreateClientConVar("MW2022HUD_YBounds", 100, true, true, "Set vertical bounds.", 0, 100)

MW2022HUD.SetupBounds = function()
    MW2022HUD.ScreenWidth = ScrW()
    MW2022HUD.ScreenHeight = ScrH()

    MW2022HUD.Scale = MW2022HUD.ScreenHeight / 1080

    MW2022HUD.XBoundsMargin = MW2022HUD.ScreenHeight * 0.088
    MW2022HUD.YBoundsMargin = MW2022HUD.ScreenHeight * 0.05

    -- CoD locks UI to 16:9 no matter your display aspect ratio.
    -- I will not be doing that, at least for now.
    MW2022HUD.RightMargin = MW2022HUD.ScreenWidth + (MW2022HUD.XBounds:GetFloat() - 100) / 100 * MW2022HUD.XBoundsMargin
    MW2022HUD.LeftMargin = -((MW2022HUD.XBounds:GetFloat() - 100) / 100 * MW2022HUD.XBoundsMargin)
    MW2022HUD.TopMargin = -((MW2022HUD.YBounds:GetFloat() - 100) / 100 * MW2022HUD.YBoundsMargin)
    MW2022HUD.BottomMargin = MW2022HUD.ScreenHeight + (MW2022HUD.YBounds:GetFloat() - 100) / 100 * MW2022HUD.YBoundsMargin

    -- technically doesn't belong in "SetupBounds"...can't think of a name to rename it to tho
    if MW2022HUD.Minimap then
        MW2022HUD.Minimap.UpdateLayout()
    end
end

MW2022HUD.Materials = {}
MW2022HUD.Materials.GradientL = Material("vgui/gradient-l")
MW2022HUD.Materials.GradientR = Material("vgui/gradient-r")
MW2022HUD.Materials.GradientU = Material("vgui/gradient_up")

MW2022HUD.NullFunction = function() end

MW2022HUD.SetupBounds()

print("[MWIIHUD] Initializing HUD... --------------------------------")

include("mw2022hud/fonts.lua")
include("mw2022hud/compass.lua")
include("mw2022hud/ammo.lua")
include("mw2022hud/score.lua")
include("mw2022hud/vitals.lua")
include("mw2022hud/damageindicator.lua")
include("mw2022hud/killfeed.lua")
include("mw2022hud/minimap.lua")
-- include("mw2022hud/callingcards.lua")
include("mw2022hud/drawsystem.lua")

for _, v in ipairs(file.Find("mw2022hud/AddonIntegrations/*.lua", "LUA")) do
    include("mw2022hud/AddonIntegrations/" .. v)
end

print("[MWIIHUD] HUD initialization complete ------------------------")

cvars.AddChangeCallback("MW2022HUD_XBounds", MW2022HUD.SetupBounds)
cvars.AddChangeCallback("MW2022HUD_YBounds", MW2022HUD.SetupBounds)
