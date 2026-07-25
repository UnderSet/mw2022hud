MW2022HUD = MW2022HUD or {}

AddCSLuaFile("mw2022hud/fonts.lua")
AddCSLuaFile("mw2022hud/compass.lua")
AddCSLuaFile("mw2022hud/ammo.lua")
AddCSLuaFile("mw2022hud/score.lua")
AddCSLuaFile("mw2022hud/vitals.lua")
AddCSLuaFile("mw2022hud/damageindicator.lua")
AddCSLuaFile("mw2022hud/killfeed.lua")
AddCSLuaFile("mw2022hud/minimap.lua")
AddCSLuaFile("mw2022hud/drawsystem.lua")

if file.Exists("lua/mw2022hud/GamemodeIntegrations/" .. engine.ActiveGamemode() .. ".lua", "GAME") then
    AddCSLuaFile("mw2022hud/GamemodeIntegrations/" .. engine.ActiveGamemode() .. ".lua")
end

include("mw2022hud/server/damageindicator.lua")

resource.AddSingleFile("resource/fonts/NotoSans-Bold.ttf")
resource.AddSingleFile("resource/fonts/NotoSans-Regular.ttf")