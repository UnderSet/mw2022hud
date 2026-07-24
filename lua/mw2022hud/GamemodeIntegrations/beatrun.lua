MW2022HUD.Score.SetScores = function()
	local isinfection = GetGlobalBool("GM_INFECTION")
    local isdatatheft = GetGlobalBool("GM_DATATHEFT")
    local isdeathmatch = GetGlobalBool("GM_DEATHMATCH")

    MW2022HUD.Score.Enabled = (isdatatheft or isdeathmatch or isinfection) and true or false

    local enemyscore = 0

    local ply = LocalPlayer()

    local allply = allply or player.GetAll()
    local displayPlayers = {}

	for _, p in ipairs(allply) do
		if !IsValid(p) or (p == LocalPlayer() and !isinfection) then continue end

		if iseventmode then
			local sk = p:GetNW2String("EPlayerStatus", "Member")
			if sk == "Manager" then continue end
		end

		table.insert(displayPlayers, p)
	end

	for k, v in ipairs(displayPlayers) do
		if IsValid(v) then
			if isdatatheft then
				enemyscore = v:GetNW2Int("DataBanked", 0)
			elseif isdeathmatch then
				enemyscore = v:GetNW2Int("DeathmatchKills", 0)
			elseif isinfection and v:GetNW2Bool("Infected") then
				enemyscore = enemyscore + 1
			end
		end
	end

	local InfectionEndTime = enemyscore < #allply and Infection_EndTime or CurTime()

    if isdatatheft then
        MW2022HUD.ScoreData.AllyScore = ply:GetNW2Int("DataBanked")
    elseif isdeathmatch then
        MW2022HUD.ScoreData.AllyScore = ply:GetNW2Int("DeathmatchKills")
	elseif isinfection then
		MW2022HUD.ScoreData.AllyScore = #allply - enemyscore
    end
    MW2022HUD.ScoreData.EnemyScore = enemyscore
    MW2022HUD.ScoreData.MaxScore = isinfection and #allply or math.max(MW2022HUD.ScoreData.AllyScore, MW2022HUD.ScoreData.EnemyScore)

	MW2022HUD.ScoreData.RemainingTime = isinfection and math.Round(math.max(InfectionEndTime - CurTime(), 0)) or -1
	if CurTime() < Infection_StartTime then
		MW2022HUD.ScoreData.RemainingTime = math.Round(Infection_StartTime - CurTime())
	end

    MW2022HUD.Score.OverrideGamemodeName = isinfection and "INFECTION" or isdatatheft and "DATA THEFT" or isdeathmatch and "DEATHMATCH" or ""

	if ply:GetNW2Bool("Infected") then
		MW2022HUD.ScoreData.AllyScore, MW2022HUD.ScoreData.EnemyScore = MW2022HUD.ScoreData.EnemyScore, MW2022HUD.ScoreData.AllyScore
	end
end

-- as it turns out...to do this you need to modify beatrun itself
-- net.Receive("Infection_Start", function() InfectionEndTime = 0 end)
-- net.Receive("Infection_End", function() InfectionEndTime = net.ReadFloat() end)