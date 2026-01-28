MW2022HUD = MW2022HUD or {}

MW2022HUD.Enable = CreateClientConVar("MW2022HUD_Enable", 1, true, true, "Enable the MW2022 HUD.", 0, 1)

MW2022HUD.ScreenWidth = ScrW()
MW2022HUD.ScreenHeight = ScrH()

MW2022HUD.Scale = MW2022HUD.ScreenHeight / 1080

-- CoD locks UI to 16:9 no matter your display aspect ratio.
-- I will not be doing that, at least for now.
MW2022HUD.RightMargin = 0
MW2022HUD.LeftMargin = 0
MW2022HUD.TopMargin = 0
MW2022HUD.BottomMargin = 0

print("MW2022hud")