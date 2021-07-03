local bottoken = "Bot " .. Config.Bot_Token 

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) 
    deferrals.defer();
    local src = source
    local ids = ExtractIdentifiers(src);
    local steam = ids.steam:gsub("steam:", "");
    local steamDec = tostring(tonumber(steam,16));
    steam = "https://steamcommunity.com/profiles/" .. steamDec;
    deferrals.update("Checking Banned Users For The Discord Server ".. GetGuildName() .. "...")
    Citizen.Wait(0); -- Necessary Citizen.Wait() before deferrals.done()
       local banstatus = checkBans(src)
        if not banstatus then 
            print('[Discord Ban Sync] Allowing the user '.. GetPlayerName(src) .. ' to connect as they are not banned in Discord')
            deferrals.done()
        elseif banstatus == 'there was an issue' then
            print('[Discord Ban Sync] disallowing the user '.. GetPlayerName(src) .. ' to connect as there was an issue checking their ban status')
            deferrals.done(Config.ThereWasAnIssue)
            CancelEvent()
        elseif banstatus then
            sendToDisc("[Discord Ban Sync] Banned Member Attempted Connection!", ''.. GetPlayerName(src) .. " was declined connection due to them being banned from " .. GetGuildName() .. '\nSteam: **' .. steam .. '**\nDiscord Tag: ** <@' .. ids.discord:gsub('discord:', '') .. '> **\nDiscord UID: **' .. ids.discord:gsub('discord:', '') .. '**\nIP:** ||'.. ids.ip:gsub('ip:', '').. '||**');
        print('[Discord Ban Sync] disallowing the user '.. GetPlayerName(src) .. ' to connect as they are banned in the discord')
        deferrals.done('Sorry, it seems that you are banned from '.. GetGuildName() .. '...')
        CancelEvent()
        end
end)

-- FUNCTIONS --

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
end
    return identifiers
end


function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = bottoken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function checkBans(user)
        local discordID = nil
        for _, id in ipairs(GetPlayerIdentifiers(user)) do
            if string.match(id, "discord:") then
                discordID = string.gsub(id, "discord:", "")
                break
            end
        end
        if discordID then 
            local bandata = DiscordRequest("GET", "guilds/"..Config.Guild_ID.."/bans/"..discordID, {})
                if bandata.code == 200 then
                else
                    return 'there was an issue'
                end
        return bandata
        else 
            return nil
        end
end

function GetGuildName()
	local guild = DiscordRequest("GET", "guilds/"..Config.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		return data.name;
	else
	end
	return nil;
end

function sendToDisc(title, message, footer)
    local embed = {}
    embed = {
        {
            ["color"] = 16711680, -- GREEN = 65280 --- RED = 16711680
            ["title"] = "**".. title .."**",
            ["description"] = "" .. message ..  "",
            ["footer"] = {
                ["text"] = '[Discord Ban Sync] Created By: Jordan.#2139',
            },
        }
    }
    PerformHttpRequest(Config.webhookURL, 
    function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end
