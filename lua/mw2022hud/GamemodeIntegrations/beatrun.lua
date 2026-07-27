local isinfection = GetGlobalBool("GM_INFECTION")
local isdatatheft = GetGlobalBool("GM_DATATHEFT")
local isdeathmatch = GetGlobalBool("GM_DEATHMATCH")
local enemylead = nil

local function playersort(a, b)
	if isdatatheft then
		local ascore = a:GetNW2Int("DataBanked", 0)
		local bscore = b:GetNW2Int("DataBanked", 0)
		return ascore > bscore
	elseif isdeathmatch then
		local ascore = a:GetNW2Int("DeathmatchKills", 0)
		local bscore = b:GetNW2Int("DeathmatchKills", 0)
		return ascore > bscore
	else
		local ascore = a:GetNW2Int("DataBanked", 0)
		local bscore = b:GetNW2Int("DataBanked", 0)
		return ascore < bscore
	end
end

MW2022HUD.Score.SetScores = function()
	isinfection = GetGlobalBool("GM_INFECTION")
    isdatatheft = GetGlobalBool("GM_DATATHEFT")
    isdeathmatch = GetGlobalBool("GM_DEATHMATCH")

    MW2022HUD.Score.Enabled = (isdatatheft or isdeathmatch or isinfection) and true or false
	MW2022HUD.ScoreData.FFAMode = (isdatatheft or isdeathmatch) and true or false

    MW2022HUD.Score.OverrideGamemodeName = isinfection and "INFECTION" or isdatatheft and "DATA THEFT" or isdeathmatch and "DEATHMATCH" or ""

	if !isinfection and !isdatatheft and !isdeathmatch then return end

    local enemyscore = 0

    local ply = LocalPlayer()

    local allply = allply or player.GetAll()
    local displayPlayers = {}
	table.sort(allply, playersort)

	for _, p in ipairs(allply) do
		if !IsValid(p) then continue end
		-- if !IsValid(p) or (p == LocalPlayer() and !isinfection) then continue end

		if iseventmode then
			local sk = p:GetNW2String("EPlayerStatus", "Member")
			if sk == "Manager" then continue end
		end

		table.insert(displayPlayers, p)
	end

	if isinfection then
		for k, v in ipairs(displayPlayers) do
			if v:GetNW2Bool("Infected") then
				enemyscore = enemyscore + 1
			end
		end
	else
		if displayPlayers[1] == LocalPlayer() then
			enemylead = displayPlayers[2]
			enemyscore = isdatatheft and displayPlayers[2]:GetNW2Int("DataBanked", 0)
				or isdeathmatch and displayPlayers[2]:GetNW2Int("DeathmatchKills", 0)
			MW2022HUD.ScoreData.FFALocalPos = 1
		else
			enemylead = displayPlayers[1]
			enemyscore = isdatatheft and displayPlayers[1]:GetNW2Int("DataBanked", 0)
				or isdeathmatch and displayPlayers[1]:GetNW2Int("DeathmatchKills", 0)
			for k, v in ipairs(displayPlayers) do
				if v == LocalPlayer() then
					MW2022HUD.ScoreData.FFALocalPos = k
				end
			end
		end
	end

	if IsValid(enemylead) then
		MW2022HUD.ScoreData.FFAEnemyLeadName = enemylead:Nick()
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

	if ply:GetNW2Bool("Infected") then
		MW2022HUD.ScoreData.AllyScore, MW2022HUD.ScoreData.EnemyScore = MW2022HUD.ScoreData.EnemyScore, MW2022HUD.ScoreData.AllyScore
	end
end

-- as it turns out...to do this you need to modify beatrun itself
-- net.Receive("Infection_Start", function() InfectionEndTime = 0 end)
-- net.Receive("Infection_End", function() InfectionEndTime = net.ReadFloat() end)\

-- snippet used while testing sorting
for _, p in ipairs(player.GetAll()) do
	if !IsValid(p) then continue end

	p:SetNW2Int("DeathmatchKills", math.Rand(0, 32))
end