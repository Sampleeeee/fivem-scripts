local FormattedToken = "Bot "..Config.DiscordToken
local cache = {}

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function send(src, msg)
    --TriggerClientEvent('chat:addMessage', src, {
    --   args = { msg }
    --})
end

function GetUnixTimestamp()
    return os.time(os.date "!*t")
end

function GetRoles(user)
    if cache[user] and cache[user].lastUpdated < GetUnixTimestamp() + 60 then
        return cache[user].roles
    end

	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			send(user, "Found discord id: "..discordId)
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.GuildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            cache[user] = {
                lastUpdated = GetUnixTimestamp(),
                roles = json.decode(member.data).roles
            }

            return json.decode(member.data).roles
        elseif member.code == 429 then
            print(GetPlayerName(user).." has been ratelimited by discord while getting permissions.")
            -- TriggerClientEvent("chat:addMessage", user, {
            --     args = { "Discord Permissions", "Discord has ratelimited the permissions system. You may not have permissions, if you don't, contact a server developer." }
            -- })
            return false
		else
			send(user, "An error occured, maybe they arent in the discord? Error: "..member.data)
			return false
		end
	else
		send(user, "missing identifier")
		return false
	end
end

function IsRolePresent(user, role)
    if not Config.Roles[role] then return false end

    local roles = GetRoles(user)
    if roles == false then return false end

    for k, v in pairs(roles) do
        if v == Config.Roles[role] then
            return true
        end
    end

    return false
end

function IsCop(player)
    for k, v in pairs(Config.CopRoles) do
        if IsRolePresent(player, Config.Roles[v]) then
            return true
        end
    end
    
    return false
end

function GetAllCops()
    local t = {}
    for k, v in ipairs(GetPlayers()) do
        if IsCop(v) then
            t[#t + 1] = v
        end
    end

    return t
end

exports("GetRoles", GetRoles)
exports("IsRolePresent", IsRolePresent)
exports("IsCop", IsCop)
exports("GetAllCops", GetAllCops)

function AddAcePermissions(player)
    local roles = GetRoles(player)

    if roles then
        for k, v in pairs(roles) do
            for k2, v2 in pairs(Config.RolesToAce) do
                if Config.Roles[k2] == v then
                    print("Found discord role `"..k2.."` on player "..GetPlayerName(player)..". Giving `"..v2.."`.")
                    for k3, v3 in pairs(GetPlayerIdentifiers(player)) do
                        ExecuteCommand("add_principal identifier."..v3.." "..v2)
                    end
                end
            end
        end

        --TriggerClientEvent("sample_util:ForceExecute", player)
    end
end

RegisterNetEvent "sample_util:PlayerReady"
AddEventHandler("sample_util:PlayerReady", function()
    local player = source

    AddAcePermissions(player)
    TriggerClientEvent("sample_util:RolesGiven", player)
end)

RegisterCommand("refreshpermissions", function(source)
    AddAcePermissions(source)
end)