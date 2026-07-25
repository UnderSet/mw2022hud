local radar = GMinimap and GMinimap.CreateRadar() or nil
local ply = LocalPlayer() or nil
local rotation = Angle(0, 0, 0) -- gets used in Minimap.Draw()

MW2022HUD.Minimap = {}

MW2022HUD.Minimap.Draw = function()
    if !GMinimap or !MW2022HUD.EnableMinimap:GetBool() then return end

    rotation.yaw = ply:EyeAngles().y
    
    radar.origin = ply:GetPos()
    radar.rotation = MW2022HUD.EnableMinimapRotation:GetBool() and rotation or angle_zero
    radar.ratio = 10
    -- radar:SetOrigin(ply:GetPos())
    -- radar:SetRatio(10)
    -- radar:SetDimensions(20,20,200,200)
    -- radar:UpdateLayout()
    radar:Draw()
    GMinimap:DrawBlips(radar)
end

MW2022HUD.Minimap.UpdateLayout = function()
    radar.ratio = 8
    radar:SetDimensions(MW2022HUD.LeftMargin + 26 * MW2022HUD.Scale, MW2022HUD.TopMargin + 22 * MW2022HUD.Scale,
    218 * MW2022HUD.Scale, 218 * MW2022HUD.Scale)
    radar:SetHeights(GMinimap.World:GetHeights())
    radar:UpdateLayout()
end

hook.Add("InitPostEntity", "MW2022MapInit", function() ply = LocalPlayer() end)

MW2022HUD.Minimap.UpdateLayout()