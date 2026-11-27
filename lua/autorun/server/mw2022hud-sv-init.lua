-- this is the very first thing we run (before even setting up MW2022HUD.MsgC) so we can't use that
-- aka the one time we intentionally use raw MsgC
MsgC(Color(123, 196, 45), "[MWIIHUD] ", Color(0,255,255), "[SV] ",
    Color(255,255,255), "Beginning HUD serverside initialization\n")
MW2022HUD = MW2022HUD or {}

MW2022HUD.MsgC = function(...)
    -- convenience wrapper around MsgC
    MsgC(Color(123, 196, 45), "[MWIIHUD] ", Color(0,255,255), "[SV] ", ..., "\n")
end

MW2022HUD.DebugMsgC = function(...)
    -- thin wrapper around MsgC for debug-only text
    if !dev:GetBool() then return end
    MsgC(Color(123, 196, 45), "[MWIIHUD]", Color(0,255,255), "[SV] ", Color(255,255,0), " <DEBUG> ", ..., "\n") 
end

AddCSLuaFile("mw2022hud/fonts.lua")
AddCSLuaFile("mw2022hud/compass.lua")
AddCSLuaFile("mw2022hud/ammo.lua")
AddCSLuaFile("mw2022hud/weaponextensions.lua")
AddCSLuaFile("mw2022hud/score.lua")
AddCSLuaFile("mw2022hud/vitals.lua")
AddCSLuaFile("mw2022hud/damageindicator.lua")
AddCSLuaFile("mw2022hud/killfeed.lua")
AddCSLuaFile("mw2022hud/minimap.lua")
-- AddCSLuaFile("mw2022hud/callingcards.lua")
AddCSLuaFile("mw2022hud/drawsystem.lua")
AddCSLuaFile("mw2022hud/spawnmenu.lua")

if file.Exists("lua/mw2022hud/GamemodeIntegrations/" .. engine.ActiveGamemode() .. ".lua", "GAME") then
    AddCSLuaFile("mw2022hud/GamemodeIntegrations/" .. engine.ActiveGamemode() .. ".lua")
end

for _, v in ipairs(file.Find("mw2022hud/AddonIntegrations/*.lua", "LUA")) do
    AddCSLuaFile("mw2022hud/AddonIntegrations/" .. v)
end

include("mw2022hud/server/damageindicator.lua")

resource.AddSingleFile("resource/fonts/Stratum2.ttf")
resource.AddSingleFile("resource/fonts/NotoSans-Bold.ttf")
resource.AddSingleFile("resource/fonts/NotoSans-Regular.ttf")

CreateConVar("MW2022HUD_Server_AllPlayersAreEnemies", 0, 384, "Makes the HUD consider all players are enemies at all times, even if a squad is specified.")

MW2022HUD.MsgC(Color(255,255,255), "HUD serverside initialization complete")