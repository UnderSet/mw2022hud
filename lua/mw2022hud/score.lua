MW2022HUD.Score = {}

local ActiveScoreSource = false
local ScoreSources = {}

local GamemodeName = gmod.GetGamemode() and gmod.GetGamemode().Name or ""
local OverrideGamemodeName = "" -- override shown gamemode name, useful for say, Beatrun; set to "" (like here) to disable

local GamemodeIconRT = GetRenderTarget("MW5GamemodeIcon", 256, 256)
local GamemodeIconRTMat = CreateMaterial( 
    "MW5GamemodeIconMat","UnlitGeneric",
    {
        ["$basetexture"] = GamemodeIconRT:GetName(),
        ["$translucent"] = "1"
    } 
)

local MaxScore = 65
local AllyScore = 17
local EnemyScore = 18
local RemainingTime = 0 -- in seconds, no need to round
local FFAPos = 8 -- set to false (as in yes the boolean false) to turn off FFA mode
local FFAEnemyLead = ""

MW2022HUD.Materials.Score = Material("iw9ui/hud_score_bar.png")
MW2022HUD.Materials.ScoreInverse = Material("iw9ui/hud_score_bar_reverse.png")
MW2022HUD.Materials.ScoreGradient = Material("iw9ui/hud_score_bar_grad_winning.png")
MW2022HUD.Materials.ScoreGradientInverse = Material("iw9ui/hud_score_bar_grad_winning_reverse.png")
MW2022HUD.Materials.ScoreGradientLosing = Material("iw9ui/hud_score_bar_grad_losing.png")
MW2022HUD.Materials.ScoreGradientLosingInverse = Material("iw9ui/hud_score_bar_grad_losing_reverse.png")

MW2022HUD.Materials.ScoreTick = Material("iw9ui/hud_score_bar_tick.png")
MW2022HUD.Materials.ScoreTickInverse = Material("iw9ui/hud_score_bar_tick_reverse.png")

MW2022HUD.Materials.GamemodeSplash = Material("mw2022/hud_splash_gamemode_diamond.png")
MW2022HUD.Materials.GamemodeSplash2 = Material("iw9ui/hud_splash_gamemode_diamond.png")

MW2022HUD.GamemodeIconColorCorrect = {
    [ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0.7,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 0,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

local OutlineBlack = Color(66,66,66,55)
local GamemodeGray = Color(185,185,185,183)
local ScoreBG = Color(44,44,44,94)
local MaterialColor = Material("color")

local AllyColor = Color(21, 182, 207)
local EnemyColor = Color(162,24,0)
local AllyColorGradient = Color(24, 210, 240)
local EnemyColorGradient = Color(248,39,0)

-- Neutral color is just white (color_white)
local WinningColor = Color(24, 210, 240)
local LosingColor = Color(255, 34, 0)

local GamemodeIcon = Material("gamemodes/" .. engine.ActiveGamemode() .. "/icon24.png")
local GradientRight = Material("vgui/gradient-r")

-- Integration-defined function (see mw2022hud/GamemodeIntegrations/beatrun.lua)
MW2022HUD.Score.GetScores = function()
    if !ActiveScoreSource then return end
    MaxScore, AllyScore, EnemyScore, RemainingTime, FFAPos, FFAEnemyLead = ScoreSources[ActiveScoreSource].func()
end

MW2022HUD.Score.Draw = function()
    if !MW2022HUD.EnableScore:GetBool() or (!MW2022HUD.Score.Enabled and MW2022HUD.EnableScore:GetInt() == 2) then return end

    MW2022HUD.Score.GetScores()

    render.PushRenderTarget(GamemodeIconRT)
    cam.Start2D()
    render.Clear(0, 0, 0, 0, true, true)

    render.SetStencilEnable( true )
    render.ClearStencil()
    render.SetStencilTestMask( 255 )
    render.SetStencilWriteMask( 255 )
    render.SetStencilPassOperation(STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue( 9 )
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)

    surface.SetDrawColor(255,255,255,255)
    surface.DrawRect(64, 0, 192, 256)

    render.SetStencilFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

    surface.SetDrawColor(255,255,255,255)
    surface.SetMaterial(GamemodeIcon)
    surface.DrawTexturedRect(64, 64, 128, 128)
    surface.SetMaterial(MW2022HUD.Materials.GamemodeSplash2)
    surface.DrawTexturedRect(0, 0, 256, 256)

    render.SetWriteDepthToDestAlpha(false)
	render.OverrideBlend(true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, BLENDFUNC_MIN)
        surface.SetDrawColor(255,255,255,80)
		surface.SetMaterial(GradientRight)
		surface.DrawTexturedRect(64, 0, 192, 256)
	render.OverrideBlend(false)
    render.SetWriteDepthToDestAlpha(true)

    DrawColorModify(MW2022HUD.GamemodeIconColorCorrect)

    render.SetStencilEnable(false)

    cam.End2D()
    render.PopRenderTarget()

    surface.SetMaterial(GamemodeIconRTMat)
    surface.SetDrawColor(255,255,255,128)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin - 65 * MW2022HUD.Scale, MW2022HUD.TopMargin + 255 * MW2022HUD.Scale, 135 * MW2022HUD.Scale, 135 * MW2022HUD.Scale)

    draw.SimpleText(string.upper("// " .. (OverrideGamemodeName != "" and OverrideGamemodeName or GamemodeName)),
        "MW2022GamemodeName", MW2022HUD.LeftMargin + 25 * MW2022HUD.Scale, MW2022HUD.TopMargin + 246 * MW2022HUD.Scale, GamemodeGray, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    
    if !ActiveScoreSource then return end

    if ScoreSources[ActiveScoreSource].customDraw then
        -- some gamemodes have special integrations that don't use the regular scorebars
        ScoreSources[ActiveScoreSource].func()
    else
        -- THESE ARE NOT WHAT YOU THINK THEY ARE.
        local AllyScoreRatio = 1 - AllyScore / MaxScore
        local EnemyScoreRatio = 1 - EnemyScore / MaxScore
        local ScoreBalance = AllyScore > EnemyScore and 1
            or AllyScore == EnemyScore and 0
            or -1
        local FormattedTime = string.FormattedTime(RemainingTime, "%01i:%02i")

        draw.SimpleTextOutlined(AllyScore, ScoreBalance == 1 and "MW2022ScoreWinning" or "MW2022ScoreLosing",
            MW2022HUD.LeftMargin + 56 * MW2022HUD.Scale, MW2022HUD.TopMargin + 259 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
        draw.SimpleTextOutlined(EnemyScore, ScoreBalance == -1 and "MW2022ScoreWinning" or "MW2022ScoreLosing",
            MW2022HUD.LeftMargin + 56 * MW2022HUD.Scale, MW2022HUD.TopMargin + 331 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)

        if FFAPos then
            draw.SimpleTextOutlined(string.CardinalToOrdinal(FFAPos), "MW2022GamemodeTime",
                MW2022HUD.LeftMargin + 250 * MW2022HUD.Scale, MW2022HUD.TopMargin + 283 * MW2022HUD.Scale, WinningColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
            draw.SimpleTextOutlined(FFAPos != 1 and "1st" or "2nd", "MW2022GamemodeTime",
                MW2022HUD.LeftMargin + 250 * MW2022HUD.Scale, MW2022HUD.TopMargin + 343 * MW2022HUD.Scale, LosingColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
            draw.SimpleTextOutlined(FFAEnemyLead, "MW2022ScorePlayerName",
                MW2022HUD.LeftMargin + 55 * MW2022HUD.Scale, MW2022HUD.TopMargin + 373 * MW2022HUD.Scale, LosingColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)

            if RemainingTime >= 0 then 
                draw.SimpleTextOutlined(FormattedTime, "MW2022GamemodeTime", MW2022HUD.LeftMargin + 250 * MW2022HUD.Scale, MW2022HUD.TopMargin + 396 * MW2022HUD.Scale,
                    color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
            end
            -- don't even fucking *think* of touching this stencil mess, we clear?
            render.SetStencilEnable(true)
            render.ClearStencil()
            render.SetStencilTestMask(255)
            render.SetStencilWriteMask(255)
            render.SetStencilPassOperation(STENCILOPERATION_KEEP)
            render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)

            render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
            render.SetStencilReferenceValue(69)

            draw.NoTexture()
            surface.SetDrawColor(color_black)
            surface.DrawTexturedRectRotated(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale, MW2022HUD.TopMargin + 325 * MW2022HUD.Scale, 12 * MW2022HUD.Scale, 12 * MW2022HUD.Scale, 45)
            surface.DrawTexturedRectRotated(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale, MW2022HUD.TopMargin + 321 * MW2022HUD.Scale, 12 * MW2022HUD.Scale, 12 * MW2022HUD.Scale, 45)
            surface.DrawRect(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale, MW2022HUD.TopMargin + 321 * MW2022HUD.Scale, 192 * MW2022HUD.Scale, 4 * MW2022HUD.Scale)

            render.SetStencilFailOperation(STENCILOPERATION_KEEP)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_GREATER)
            render.SetStencilReferenceValue(8)

            surface.SetMaterial(MW2022HUD.Materials.Score)
            surface.SetDrawColor(WinningColor)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.TopMargin + 316 * MW2022HUD.Scale, 188 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
            surface.SetMaterial(MW2022HUD.Materials.ScoreInverse)
            surface.SetDrawColor(LosingColor)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 64 * MW2022HUD.Scale, MW2022HUD.TopMargin + 320 * MW2022HUD.Scale, 188 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)

            render.SetStencilEnable(false)
            render.SetScissorRect(0,0,0,0,false)
        else
            draw.SimpleTextOutlined(ScoreBalance == 1 and "WINNING" or ScoreBalance == 0 and "TIED" or "LOSING", "MW2022ScoreState",
                MW2022HUD.LeftMargin + 240 * MW2022HUD.Scale, MW2022HUD.TopMargin + 288 * MW2022HUD.Scale,
                ScoreBalance == 1 and WinningColor or ScoreBalance == 0 and color_white or LosingColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)

            if RemainingTime >= 0 then 
                draw.SimpleTextOutlined(FormattedTime, "MW2022GamemodeTime", MW2022HUD.LeftMargin + 240 * MW2022HUD.Scale, MW2022HUD.TopMargin + 338 * MW2022HUD.Scale,
                    color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
            end
            
            -- surface.SetDrawColor(color_white)
            -- surface.DrawRect(MW2022HUD.LeftMargin + 61 * MW2022HUD.Scale, MW2022HUD.TopMargin + 313 * MW2022HUD.Scale, 180 * MW2022HUD.Scale, 1 * MW2022HUD.Scale)

            -- don't even fucking *think* of touching this stencil mess, we clear?
            render.SetScissorRect(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale, MW2022HUD.TopMargin + 313 * MW2022HUD.Scale,
                MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale + 190 * MW2022HUD.Scale, MW2022HUD.TopMargin + 335 * MW2022HUD.Scale, true)
            surface.SetDrawColor(ScoreBG)
            surface.SetMaterial(MW2022HUD.Materials.Score)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 60 * MW2022HUD.Scale, MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 188 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
            surface.SetMaterial(MW2022HUD.Materials.ScoreInverse)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 60 * MW2022HUD.Scale, MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 188 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)

            render.SetStencilEnable(true)
            render.ClearStencil()
            render.SetStencilTestMask(255)
            render.SetStencilWriteMask(255)
            render.SetStencilPassOperation(STENCILOPERATION_KEEP)
            render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)

            render.SetStencilReferenceValue(0)
            render.SetStencilFailOperation(STENCILOPERATION_REPLACE)

            -- surface.SetDrawColor(color_black)
            -- surface.DrawRect(0,0,ScrW(),ScrH())

            render.SetStencilReferenceValue(69)

            draw.NoTexture()
            surface.SetDrawColor(color_black)
            surface.DrawTexturedRectRotated(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale, MW2022HUD.TopMargin + 325 * MW2022HUD.Scale, 12 * MW2022HUD.Scale, 12 * MW2022HUD.Scale, 45)
            surface.DrawTexturedRectRotated(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale, MW2022HUD.TopMargin + 321 * MW2022HUD.Scale, 12 * MW2022HUD.Scale, 12 * MW2022HUD.Scale, 45)
            render.SetStencilFailOperation(STENCILOPERATION_KEEP)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_GREATER)
            render.SetStencilReferenceValue(8)

            surface.SetMaterial(MW2022HUD.Materials.Score)
            surface.SetDrawColor(AllyColor)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale - (AllyScoreRatio * 180), MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 188 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
            surface.SetMaterial(ScoreBalance == 1 and MW2022HUD.Materials.ScoreGradient or MW2022HUD.Materials.ScoreGradientLosing)
            surface.SetDrawColor(AllyColorGradient)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 225 * MW2022HUD.Scale - (AllyScoreRatio * 180), MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 23 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
            surface.SetMaterial(MW2022HUD.Materials.ScoreTick)
            surface.SetDrawColor(color_white)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 239 * MW2022HUD.Scale - (AllyScoreRatio * 180), MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 10 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)

            surface.SetMaterial(MW2022HUD.Materials.ScoreInverse)
            surface.SetDrawColor(EnemyColor)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale - (EnemyScoreRatio * 180), MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 188 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
            surface.SetMaterial(ScoreBalance == -1 and MW2022HUD.Materials.ScoreGradientInverse or MW2022HUD.Materials.ScoreGradientLosingInverse)
            surface.SetDrawColor(EnemyColorGradient)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 225 * MW2022HUD.Scale - (EnemyScoreRatio * 180), MW2022HUD.TopMargin + 323 * MW2022HUD.Scale, 23 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
            surface.SetMaterial(MW2022HUD.Materials.ScoreTickInverse)
            surface.SetDrawColor(color_white)
            surface.DrawTexturedRect(MW2022HUD.LeftMargin + 239 * MW2022HUD.Scale - (EnemyScoreRatio * 180), MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 10 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)

            render.SetStencilEnable(false)
            render.SetScissorRect(0,0,0,0,false)
        end
    end
end

MW2022HUD.Score.AddSource = function(name, isCustomDraw, func)
    ScoreSources[name] = {["func"] = func, ["customDraw"] = isCustomDraw}
end

MW2022HUD.Score.SetActiveSource = function(name)
    if ActiveScoreSource and name then
        MW2022HUD.DebugMsgC(Color(255,0,0), "score.lua: Cannot set a score source while one is already active!\n")
        return
    end
    ActiveScoreSource = name
    MW2022HUD.DebugMsgC("score.lua: Set score source to " .. tostring(name) .. "\n")
end

MW2022HUD.Score.GetActiveSource = function() return ActiveScoreSource end

MW2022HUD.Score.SetGamemodeNameOverride = function(name)
    OverrideGamemodeName = name
end

hook.Add("PostGamemodeLoaded", "MW2022HUDGetGamemode", function()
    GamemodeName = gmod.GetGamemode().Name
    hook.Remove("PostGamemodeLoaded", "MW2022HUDGetGamemode")
end)

if file.Exists("lua/mw2022hud/GamemodeIntegrations/" .. engine.ActiveGamemode() .. ".lua", "GAME") then
    include("mw2022hud/GamemodeIntegrations/" .. engine.ActiveGamemode() .. ".lua")
    MW2022HUD.DebugMsgC("score.lua: Gamemode integration module loaded for " .. engine.ActiveGamemode() .. "\n")
end

MW2022HUD.MsgC(Color(191,191,191), "Module loaded: Scores\n")

-- MW2022HUD.Score.AddSource("mw2022huddebug", false, function()
--     local MaxScore = 250
--     local AllyScore = math.Round(CurTime() % 10 * 100)
--     local EnemyScore = 1000 - AllyScore
--     local RemainingTime = 3600 - CurTime() % 3600
--     local FFAPos = false
--     local FFAEnemyLead = "thetunaaaa"
--     return MaxScore, AllyScore, EnemyScore, RemainingTime, FFAPos, FFAEnemyLead
-- end)
-- MW2022HUD.Score.SetActiveSource("mw2022huddebug")
-- MW2022HUD.Score.SetActiveSource("mw2022huddebug")
-- MW2022HUD.Score.SetGamemodeNameOverride("MWII HUD DEBUG")
-- PrintTable(ScoreSources)