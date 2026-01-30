MW2022HUD.Score = {}

MW2022HUD.Score.GamemodeName = gmod.GetGamemode().Name

MW2022HUD.Materials.Score = Material("iw9ui/hud_score_bar.png")
MW2022HUD.Materials.ScoreInverse = Material("iw9ui/hud_score_bar_reverse.png")
MW2022HUD.Materials.ScoreGradient = Material("iw9ui/hud_score_bar_grad_winning.png")
MW2022HUD.Materials.ScoreGradientInverse = Material("iw9ui/hud_score_bar_grad_winning_reverse.png")
MW2022HUD.Materials.ScoreGradientLosing = Material("iw9ui/hud_score_bar_grad_losing.png")
MW2022HUD.Materials.ScoreGradientLosingInverse = Material("iw9ui/hud_score_bar_grad_losing_reverse.png")

MW2022HUD.Materials.ScoreTick = Material("iw9ui/hud_score_bar_tick.png")
MW2022HUD.Materials.ScoreTickInverse = Material("iw9ui/hud_score_bar_tick_reverse - Copy.png")

local OutlineBlack = Color(66,66,66,55)
local GamemodeGray = Color(185,185,185,183)
local ScoreBG = Color(44,44,44,94)
local MaterialColor = Material("color")

local AllyColor = Color(0,151,48)
local EnemyColor = Color(162,24,0)
local AllyColorGradient = Color(0,205,66)
local EnemyColorGradient = Color(248,39,0)

MW2022HUD.Score.Draw = function()
    draw.SimpleText(string.upper("// " .. MW2022HUD.Score.GamemodeName), "MW2022GamemodeName", MW2022HUD.LeftMargin + 25 * MW2022HUD.Scale, MW2022HUD.TopMargin + 246 * MW2022HUD.Scale, GamemodeGray, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleTextOutlined("49", "MW2022ScoreWinning", MW2022HUD.LeftMargin + 55 * MW2022HUD.Scale, MW2022HUD.TopMargin + 259 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)
    draw.SimpleTextOutlined("30", "MW2022ScoreLosing", MW2022HUD.LeftMargin + 55 * MW2022HUD.Scale, MW2022HUD.TopMargin + 331 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5, OutlineBlack)

    -- don't even fucking *think* of touching this stencil mess, we clear?
    render.SetScissorRect(MW2022HUD.LeftMargin + 58 * MW2022HUD.Scale, MW2022HUD.TopMargin + 313 * MW2022HUD.Scale,
        MW2022HUD.LeftMargin + 58 * MW2022HUD.Scale + 188, MW2022HUD.TopMargin + 313 * MW2022HUD.Scale + 22, true)
    surface.SetMaterial(MW2022HUD.Materials.Score)
    surface.SetDrawColor(ScoreBG)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale, MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 188, 10)
    surface.SetMaterial(MW2022HUD.Materials.ScoreInverse)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale, MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 188, 10)

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
    surface.DrawTexturedRectRotated(MW2022HUD.LeftMargin + 58 * MW2022HUD.Scale, MW2022HUD.TopMargin + 325 * MW2022HUD.Scale, 12, 12, 45)
    surface.DrawTexturedRectRotated(MW2022HUD.LeftMargin + 58 * MW2022HUD.Scale, MW2022HUD.TopMargin + 321 * MW2022HUD.Scale, 12, 12, 45)
    render.SetStencilFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_GREATER)
    render.SetStencilReferenceValue(8)

    surface.SetMaterial(MW2022HUD.Materials.Score)
    surface.SetDrawColor(AllyColor)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale - (CurTime() * 15 % 90 / 90 * 188), MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 188, 10)
    surface.SetMaterial(MW2022HUD.Materials.ScoreGradient)
    surface.SetDrawColor(AllyColorGradient)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 225 * MW2022HUD.Scale - (CurTime() * 15 % 90 / 90 * 188), MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 23, 10)
    surface.SetMaterial(MW2022HUD.Materials.ScoreTick)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 239 * MW2022HUD.Scale - (CurTime() * 15 % 90 / 90 * 188), MW2022HUD.TopMargin + 312 * MW2022HUD.Scale, 10, 10)

    surface.SetMaterial(MW2022HUD.Materials.ScoreInverse)
    surface.SetDrawColor(EnemyColor)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 59 * MW2022HUD.Scale - (CurTime() * 15 % 90 / 90 * 188), MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 188, 10)
    surface.SetMaterial(MW2022HUD.Materials.ScoreGradientLosingInverse)
    surface.SetDrawColor(EnemyColorGradient)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 225 * MW2022HUD.Scale - (CurTime() * 15 % 90 / 90 * 188), MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 23, 10)
    surface.SetMaterial(MW2022HUD.Materials.ScoreTickInverse)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(MW2022HUD.LeftMargin + 239 * MW2022HUD.Scale - (CurTime() * 15 % 90 / 90 * 188), MW2022HUD.TopMargin + 324 * MW2022HUD.Scale, 10, 10)

    render.SetStencilEnable(false)
    render.SetScissorRect(0,0,0,0,false)
end