MW2022HUD.Score = {}
MW2022HUD.ScoreData = {}

MW2022HUD.Score.Enabled = false -- set to true to show, set back to false to hide (duh)

MW2022HUD.Score.GamemodeName = gmod.GetGamemode() and gmod.GetGamemode().Name or ""
MW2022HUD.Score.OverrideGamemodeName = "" -- override shown gamemode name, useful for say, Beatrun; set to "" (like here) to disable

MW2022HUD.ScoreData.MaxScore = 65
MW2022HUD.ScoreData.AllyScore = 17
MW2022HUD.ScoreData.EnemyScore = 18
MW2022HUD.ScoreData.EndTime = 0 -- use a format like what CurTime() returns!!!

MW2022HUD.Materials.Score = Material("iw9ui/hud_score_bar.png")
MW2022HUD.Materials.ScoreInverse = Material("iw9ui/hud_score_bar_reverse.png")
MW2022HUD.Materials.ScoreGradient = Material("iw9ui/hud_score_bar_grad_winning.png")
MW2022HUD.Materials.ScoreGradientInverse = Material("iw9ui/hud_score_bar_grad_winning_reverse.png")
MW2022HUD.Materials.ScoreGradientLosing = Material("iw9ui/hud_score_bar_grad_losing.png")
MW2022HUD.Materials.ScoreGradientLosingInverse = Material("iw9ui/hud_score_bar_grad_losing_reverse.png")

MW2022HUD.Materials.ScoreTick = Material("iw9ui/hud_score_bar_tick.png")
MW2022HUD.Materials.ScoreTickInverse = Material("iw9ui/hud_score_bar_tick_reverse.png")

MW2022HUD.Materials.GamemodeSplash = Material("mw2022/hud_splash_gamemode_diamond.png")

local OutlineBlack = Color(66,66,66,55)
local GamemodeGray = Color(185,185,185,183)
local ScoreBG = Color(44,44,44,94)
local MaterialColor = Material("color")

local AllyColor = Color(0,151,48)
local EnemyColor = Color(162,24,0)
local AllyColorGradient = Color(0,205,66)
local EnemyColorGradient = Color(248,39,0)

-- Neutral color is just white (color_white)
local WinningColor = Color(24, 210, 240)
local LosingColor = Color(255, 34, 0)

MW2022HUD.Score.Draw = function()
    -- debugging, comment at your wish
    -- MW2022HUD.ScoreData.MaxScore = 20
    -- MW2022HUD.ScoreData.AllyScore = math.Round(CurTime() * 4 % MW2022HUD.ScoreData.MaxScore)
    -- MW2022HUD.ScoreData.EnemyScore = MW2022HUD.ScoreData.MaxScore - math.Round(CurTime() * 4 % MW2022HUD.ScoreData.MaxScore)
    -- MW2022HUD.ScoreData.EndTime = CurTime() + 404

    draw.SimpleText(string.upper("// " .. (MW2022HUD.Score.OverrideGamemodeName != "" and MW2022HUD.Score.OverrideGamemodeName or MW2022HUD.Score.GamemodeName)),
        "MW2022GamemodeName", MW2022HUD.LeftMargin + 25 * MW2022HUD.Scale, MW2022HUD.TopMargin + 246 * MW2022HUD.Scale, GamemodeGray, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    
    surface.SetMaterial(MW2022HUD.Materials.GamemodeSplash)
    surface.SetDrawColor(GamemodeGray)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin - 65 * MW2022HUD.Scale, MW2022HUD.TopMargin + 255 * MW2022HUD.Scale, 135 * MW2022HUD.Scale, 135 * MW2022HUD.Scale)

    if !MW2022HUD.Score.Enabled then return end

    -- THESE ARE NOT WHAT YOU THINK THEY ARE.
    local AllyScoreRatio = 1 - MW2022HUD.ScoreData.AllyScore / MW2022HUD.ScoreData.MaxScore
    local EnemyScoreRatio = 1 - MW2022HUD.ScoreData.EnemyScore / MW2022HUD.ScoreData.MaxScore
    local ScoreBalance = MW2022HUD.ScoreData.AllyScore > MW2022HUD.ScoreData.EnemyScore and 1
        or MW2022HUD.ScoreData.AllyScore == MW2022HUD.ScoreData.EnemyScore and 0
        or -1

    draw.SimpleTextOutlined(MW2022HUD.ScoreData.AllyScore, ScoreBalance == 1 and "MW2022ScoreWinning" or "MW2022ScoreLosing",
        MW2022HUD.LeftMargin + 56 * MW2022HUD.Scale, MW2022HUD.TopMargin + 259 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    draw.SimpleTextOutlined(MW2022HUD.ScoreData.EnemyScore, ScoreBalance == -1 and "MW2022ScoreWinning" or "MW2022ScoreLosing",
        MW2022HUD.LeftMargin + 56 * MW2022HUD.Scale, MW2022HUD.TopMargin + 331 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    draw.SimpleTextOutlined(string.FormattedTime(MW2022HUD.ScoreData.EndTime - CurTime(), "%01i:%02i"), "MW2022GamemodeTime",
        MW2022HUD.LeftMargin + 240 * MW2022HUD.Scale, MW2022HUD.TopMargin + 338 * MW2022HUD.Scale, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    draw.SimpleTextOutlined(ScoreBalance == 1 and "WINNING" or ScoreBalance == 0 and "TIED" or "LOSING", "MW2022ScoreState",
        MW2022HUD.LeftMargin + 240 * MW2022HUD.Scale, MW2022HUD.TopMargin + 288 * MW2022HUD.Scale,
        ScoreBalance == 1 and WinningColor or ScoreBalance == 0 and color_white or LosingColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)

    -- don't even fucking *think* of touching this stencil mess, we clear?
    render.SetScissorRect(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale, MW2022HUD.TopMargin + 313 * MW2022HUD.Scale,
        MW2022HUD.LeftMargin + 58 * MW2022HUD.Scale + 188 * MW2022HUD.Scale, MW2022HUD.TopMargin + 335 * MW2022HUD.Scale, true)
    surface.SetMaterial(MW2022HUD.Materials.Score)
    surface.SetDrawColor(ScoreBG)
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
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 60 * MW2022HUD.Scale - (AllyScoreRatio * 188), MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 188 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
    surface.SetMaterial(ScoreBalance == 1 and MW2022HUD.Materials.ScoreGradient or MW2022HUD.Materials.ScoreGradientLosing)
    surface.SetDrawColor(AllyColorGradient)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 226 * MW2022HUD.Scale - (AllyScoreRatio * 188), MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 23 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
    surface.SetMaterial(MW2022HUD.Materials.ScoreTick)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 240 * MW2022HUD.Scale - (AllyScoreRatio * 188), MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 10 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)

    surface.SetMaterial(MW2022HUD.Materials.ScoreInverse)
    surface.SetDrawColor(EnemyColor)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 60 * MW2022HUD.Scale - (EnemyScoreRatio * 188), MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 188 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
    surface.SetMaterial(ScoreBalance == -1 and MW2022HUD.Materials.ScoreGradientInverse or MW2022HUD.Materials.ScoreGradientLosingInverse)
    surface.SetDrawColor(EnemyColorGradient)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 226 * MW2022HUD.Scale - (EnemyScoreRatio * 188), MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 23 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)
    surface.SetMaterial(MW2022HUD.Materials.ScoreTickInverse)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 240 * MW2022HUD.Scale - (EnemyScoreRatio * 188), MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 10 * MW2022HUD.Scale, 10 * MW2022HUD.Scale)

    render.SetStencilEnable(false)
    render.SetScissorRect(0,0,0,0,false)
end

hook.Add("PostGamemodeLoaded", "MW2022HUDGetGamemode", function()
    MW2022HUD.Score.GamemodeName = gmod.GetGamemode().Name
    hook.Remove("PostGamemodeLoaded", "MW2022HUDGetGamemode")
end)