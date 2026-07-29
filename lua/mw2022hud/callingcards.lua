-- note: TECHNICALLY the filename is inaccurate as MWII's - and specifically MWII's, no other COD game to my knowledge -- top right
--   calling cards for whatever fucking reason...do not actually display your calling card; this has since been rectified in MWIII
-- infinity ward, what in the fuck?

-- all this was VERY inspired by MW2CC by StarFrost: https://github.com/IcyStarFrost/mw2-callcards-remastered

MW2022HUD.CallingCards = {}
MW2022HUD.CallingCards.Queue = {}
--[[ calling card format, I guess: {
    name = (string),
    color = (Color()),
    comment = (string),
    isSelf = (bool) -- MWII colors its calling card visuals *slightly* differently based off whether it's yourself or not
                     -- also note the lack of an ent here; I don't feel like IsValid()'ing every frame
}
]]

local selfColor = Color(255,255,0)

MW2022HUD.CallingCards.Draw = function()
    if !MW2022HUD.CallingCards.Queue[1] then return end

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
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRectRotated(MW2022HUD.RightMargin - 326 * MW2022HUD.Scale, MW2022HUD.TopMargin + 138 * MW2022HUD.Scale, 23 * MW2022HUD.Scale, 23 * MW2022HUD.Scale, 45)

    render.SetStencilFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_GREATER)
    render.SetStencilReferenceValue(8)

    surface.SetDrawColor(color_black)
    surface.DrawRect(MW2022HUD.RightMargin - 326 * MW2022HUD.Scale, MW2022HUD.TopMargin + 138 * MW2022HUD.Scale, MW2022HUD.ScreenWidth, 78 * MW2022HUD.Scale)
    surface.SetDrawColor(MW2022HUD.CallingCards.Queue[1].color)
    surface.DrawRect(MW2022HUD.RightMargin - 326 * MW2022HUD.Scale, MW2022HUD.TopMargin + 211 * MW2022HUD.Scale, MW2022HUD.ScreenWidth, 5 * MW2022HUD.Scale)

    draw.DrawText("PlayerName", "MW2022CallCardPlayerName", MW2022HUD.RightMargin - 181 * MW2022HUD.Scale, MW2022HUD.TopMargin + 143 * MW2022HUD.Scale, MW2022HUD.CallingCards.Queue[1].color, TEXT_ALIGN_LEFT)
    draw.DrawText("ON A 5 KILL STREAK!", "MW2022CallCardComment", MW2022HUD.RightMargin - 181 * MW2022HUD.Scale, MW2022HUD.TopMargin + 176 * MW2022HUD.Scale, color_white, TEXT_ALIGN_LEFT)

    render.SetStencilEnable(false)
    render.SetScissorRect(0,0,0,0,false)
end

MW2022HUD.CallingCards.AddToQueue = function(ent, comment)
    local data = {
        name = ent:IsPlayer() and ent:Nick() or language.GetPhrase("#" .. ent:GetClass()),
        color = ent == LocalPlayer() and selfColor or ent:IsPlayer() and team.GetColor(ent:Team()) or Color(128,128,128),
        comment = comment,
        isSelf = ent == LocalPlayer() and true or false
    }

    table.insert(MW2022HUD.CallingCards.Queue, data)
end

-- MW2022HUD.CallingCards.AddToQueue(LocalPlayer(), "lame bucko")