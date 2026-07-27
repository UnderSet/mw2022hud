MW2022HUD.Killfeed = {}
MW2022HUD.Killfeed.Kills = {}

local AllyColor = Color(0,205,66)
local EnemyColor = Color(255, 34, 0)
local SelfColor = Color(255,255,0) -- color used for LocalPlayer (hence self)

local vertshift = 0

MW2022HUD.Killfeed.Draw = function()
    local localnick = LocalPlayer():Nick()

    for i=1,#MW2022HUD.Killfeed.Kills do
        if MW2022HUD.Killfeed.Kills[i].Attacker then
            surface.SetFont("MW2022KillfeedPlayerName")
            local attackerw = select(1, surface.GetTextSize(MW2022HUD.Killfeed.Kills[i].Attacker))
            local inflictorhasicon = killicon.Exists(MW2022HUD.Killfeed.Kills[i].Inflictor)
            local inflictorw, inflictorh = surface.GetTextSize("[" .. MW2022HUD.Killfeed.Kills[i].Inflictor .. "]")
            local victimw = select(1, surface.GetTextSize(MW2022HUD.Killfeed.Kills[i].Victim))

            surface.SetTextColor(MW2022HUD.Killfeed.Kills[i].Attacker != localnick and MW2022HUD.Killfeed.Kills[i].AttackTeamColor or SelfColor)
            surface.SetTextPos(MW2022HUD.LeftMargin + 25 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - (539 - i * 29) * MW2022HUD.Scale)
            surface.DrawText(MW2022HUD.Killfeed.Kills[i].Attacker)
            if inflictorhasicon or weapons.IsBasedOn(MW2022HUD.Killfeed.Kills[i].Inflictor, "arc9_base") then
                inflictorw, inflictorh = killicon.GetSize(MW2022HUD.Killfeed.Kills[i].Inflictor, false)
                killicon.Render(MW2022HUD.LeftMargin + 40 * MW2022HUD.Scale + attackerw, MW2022HUD.BottomMargin - vertshift - (539 - i * 29) * MW2022HUD.Scale - (inflictorh / 5),
                    MW2022HUD.Killfeed.Kills[i].Inflictor, 255)
            else
                surface.SetTextColor(color_white)
                surface.SetTextPos(MW2022HUD.LeftMargin + 40 * MW2022HUD.Scale + attackerw, MW2022HUD.BottomMargin - vertshift - (539 - i * 29) * MW2022HUD.Scale)
                surface.DrawText("[" .. MW2022HUD.Killfeed.Kills[i].Inflictor .. "]")
            end

            -- some kill icons are a FONT (e.g. default HL2 weapons) so reset font here just to be safe
            surface.SetFont("MW2022KillfeedPlayerName")
            surface.SetTextColor(MW2022HUD.Killfeed.Kills[i].Victim != localnick and MW2022HUD.Killfeed.Kills[i].VictimTeamColor or SelfColor)
            surface.SetTextPos(MW2022HUD.LeftMargin + 55 * MW2022HUD.Scale + attackerw + inflictorw, MW2022HUD.BottomMargin - vertshift - (539 - i * 29) * MW2022HUD.Scale)
            surface.DrawText(MW2022HUD.Killfeed.Kills[i].Victim)
        else
            surface.SetFont("MW2022KillfeedPlayerName")
            local inflictorw, inflictorh = surface.GetTextSize(MW2022HUD.Killfeed.Kills[i].Inflictor == "worldspawn" and "[Falling]" or "[Suicide]")

            surface.SetTextPos(MW2022HUD.LeftMargin + 25 * MW2022HUD.Scale, MW2022HUD.BottomMargin - vertshift - (539 - i * 29) * MW2022HUD.Scale)
            surface.SetTextColor(color_white)
            surface.DrawText(MW2022HUD.Killfeed.Kills[i].Inflictor == "worldspawn" and "[Falling]" or "[Suicide]")
            surface.SetTextPos(MW2022HUD.LeftMargin + 40 * MW2022HUD.Scale + inflictorw, MW2022HUD.BottomMargin - vertshift - (539 - i * 29) * MW2022HUD.Scale)
            surface.SetTextColor(MW2022HUD.Killfeed.Kills[i].Victim != localnick and MW2022HUD.Killfeed.Kills[i].VictimTeamColor or SelfColor)
            surface.DrawText(MW2022HUD.Killfeed.Kills[i].Victim)
        end
    end

    vertshift = math.Approach(vertshift, 0, FrameTime() * 120)

    for i=#MW2022HUD.Killfeed.Kills,1,-1 do
        if MW2022HUD.Killfeed.Kills[i].Expire < CurTime() then
            table.remove(MW2022HUD.Killfeed.Kills, i)
        end
    end
end

hook.Add("AddDeathNotice", "MW2022AddDeathNotice", function(attacker, atkTeam, inflictor, victim, victimTeam) 
    vertshift = (#MW2022HUD.Killfeed.Kills <= 0 and vertshift) or vertshift + 29 * MW2022HUD.Scale

    local killdata = {
        ["Expire"] = CurTime() + 8,
        ["Attacker"] = attacker,
        ["AttackTeam"] = atkTeam,
        ["AttackTeamColor"] = (atkTeam == -1 and EnemyColor or atkTeam == -2 and AllyColor or team.GetColor(atkTeam)),
        ["Inflictor"] = inflictor,
        ["Victim"] = victim,
        ["VictimTeam"] = victimTeam,
        ["VictimTeamColor"] = (victimTeam == -1 and EnemyColor or victimTeam == -2 and AllyColor or team.GetColor(victimTeam))
    }
    table.insert(MW2022HUD.Killfeed.Kills, 1, killdata)
end)

hook.Add("DrawDeathNotice", "MW2022HideDeathNotice", function()
    if MW2022HUD.Enable:GetBool() then return false end
end)

print("[MWIIHUD] Killfeed loaded")