AddCSLuaFile("shared.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("functions.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("rp_southside_data.lua")
AddCSLuaFile("load_sounds.lua")
AddCSLuaFile("load_vehicles.lua")

include("shared.lua")
include("functions.lua")
include("load_sounds.lua")
include("rp_southside_data.lua")

util.AddNetworkString("Timer4Lobby")
util.AddNetworkString("Timer4Match")
util.AddNetworkString("Timer4PostGame")

-- All time measures in seconds
local lobby_time_duration = 30
local match_time_duration = 1200
local match_end_time_duration = 20
local strider_spawn_time = 300
local strider_message_time = 360

local startGameKey = false
local postGameKey = false

hook.Add( "GetFallDamage", "RealisticDamage", function( ply, speed )
    return ( speed / 11 )
end )

hook.Add("PlayerCanPickupWeapon", "PreventSpectatorWeaponPickup", function(ply, weapon)
    if ply:Team() == TEAM_SPECTATOR then
        return false
    end
end)

hook.Add("PlayerUse", "PreventSpectatorEntityUse", function(ply, ent)
    if ply:Team() == TEAM_SPECTATOR then
        return false
    end
end)

function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function aliveSpawn(ply)
    ply:SetJumpPower(275)
    ply:SetupHands()
    ply:SetTeam(1001)
    ply:UnSpectate()
    ply:SetModel("models/player/combine_soldier.mdl")
    ply:AllowFlashlight(true)
    ply:Give("weapon_crowbar")
    ply:SetNoTarget( false )
end

function deadSpawn(ply)
    ply:SetTeam(1002)
    ply:AllowFlashlight(false)
    ply:Spectate(6)
    ply:SetNoTarget( true )
end

function GM:PlayerInitialSpawn(ply, bool)
    ply:SetNWInt('spec_mode', 0)
end

function GM:PlayerSpawn( ply )
    if startGameKey == true and postGameKey == false then
        if (ply:GetNWInt('spec_mode') == 0) then
            aliveSpawn(ply)
        else
            deadSpawn(ply) 
        end
    end
    if startGameKey == false and postGameKey == true then
        deadSpawn(ply)
    end
    if startGameKey == false and postGameKey == false then
        aliveSpawn(ply)
    end
end

-- Verification if the match is ready to start.
function checkKey()
    local playerAmount = player:GetCount()
    local currentMap = game.GetMap()

    if playerAmount >= 2 then
        if currentMap == "rp_southside" then
            timer.Stop("LobbyTimer")
            startGamemode()
        end
    else
        placeholder()
        timer.Start("LobbyTimer")
    end
end

-- Revoke all players' godmode
function revokeGodAll()
    for _, ply in pairs(player.GetAll()) do
        ply:GodDisable()
        local message = ply:Name()..", the hunt started."
        ply:PrintMessage(4, message)
        timer.Remove("GodModeTimer")
    end
end

-- Reset a player kill and death counters
function resetPlayerScore(ply)
    ply:SetFrags(0) -- Reset kills
    ply:SetDeaths(0) -- Reset deaths
end

-- Reset ALL players kill and death counters
function resetAllPlayerScores()
    for _, ply in pairs(player.GetAll()) do 
        resetPlayerScore(ply)
    end
end

-- IMPORTANT: Creation of the lobby timer
timer.Create("LobbyTimer", lobby_time_duration, 0, checkKey)

-- Funçãtion for Lobby Restart
-- Exclusive for the MatchEndTimer timer's internal function
function restartLobby()
    
    timer.Stop("MatchEndTimer")
    timer.Start("LobbyTimer")

    postGameKey = false
    startGameKey = false

    for _, ply in pairs(player.GetAll()) do
        ply:SetNWInt("relics", 0)
        ply:KillSilent()
        ply:Spawn()
    end

    RemoveSpawnedWeapons()
    RemoveSpawnedVehicles()
    RemoveRelics()
    removeStriders()
end

-- IMPORTANT: Creation of the match's end timer
timer.Create("MatchEndTimer", match_end_time_duration, 0, restartLobby)
timer.Stop("MatchEndTimer")

-- End the match
function endMatch()

    timer.Stop("MatchTimer")
    timer.Start("MatchEndTimer")

    postGameKey = true
    startGameKey = false

    survivors = {}

    for _, ply in pairs(player.GetAll()) do

        local status = ply:GetObserverMode()

        if status == 0 and ply:Alive() then
            survivor = ply:GetName()
            survivors[survivor] = ply:GetNWInt('relics')
        end

    end

    local lastHigherRelicCounter = 0
    for ply, relics in pairs(survivors) do
        if relics >= lastHigherRelicCounter then
            lastHigherRelicCounter = relics
            round_winner = ply
        end
    end

    for _, ply in pairs(player.GetAll()) do
        ply:ChatPrint("Winner of the round: "..round_winner.."!")
        ply:EmitSound("hazard_env")
    end
end

-- IMPORTANT: Creation of the match's timer
timer.Create("MatchTimer", match_time_duration, 0, endMatch)
timer.Stop("MatchTimer")

-- Check if there's only 1 or no players alive.
function checkAlivePlayers(victim, inflictor, attacker)
    if postGameKey == true then return end
    if startGameKey == false then return end

    victim:SetNWInt('spec_mode', 60)

    if ( victim == attacker ) then
        victim:SetNWInt('relics', toint(3 * victim:GetNWInt('relics')/4.0) )
    else
        if (attacker:IsPlayer()) and (victim:IsPlayer()) then
            attacker:SetNWInt('relics', attacker:GetNWInt('relics') + toint((victim:GetNWInt('relics')/4.0)) )
            attacker:ChatPrint("You got "..toint((victim:GetNWInt('relics')/4.0)).." relics by this kill!")
            victim:SetNWInt('relics', toint(3 * victim:GetNWInt('relics')/4.0))
        end
        if (victim:IsPlayer()) then
            victim:SetNWInt('relics', toint(3 * victim:GetNWInt('relics')/4.0))
        end
    end
end

-- Start the match
function startGamemode()
    timer.Stop("LobbyTimer")

    resetAllPlayerScores()
    strider_can_spawn = true
    strider_message = true
    
    -- Respawn + Loadout commands
    for _, ply in pairs(player.GetAll()) do
        ply:KillSilent()
        ply:SetNWInt('spec_mode', 0)
        ply:Spawn()
        ply:GodEnable()
        ply:PrintMessage(4, "You're invulnerable for 30s. Use this downtime wisely.")
    end

    postGameKey = false
    startGameKey = true
    
    timer.Create("GodModeTimer", 30, 0, revokeGodAll)

    timer.Start("MatchTimer")

    for _, ply in pairs(player.GetAll()) do
        ply:SetNWInt('relics', 0)
    end

    local mapName = game.GetMap()

    if mapName == "rp_southside" then
        rp_southsideSpawn()
        striderSpawnPoints = southside_striderSpawnPoints
        for _, ply in pairs(player.GetAll()) do
            ply:ChatPrint(#spawnedRelics.." relics spawned throughout the map.")
        end
    else
        print("Placeholder for different maps")
    end

    hook.Add("PlayerDeath", "VerifyAlivePlayers", checkAlivePlayers)
end

function matchProgression()

    -- STRIDER
    if startGameKey == true and postGameKey == false then
        local remaining_match_time = timer.TimeLeft("MatchTimer")
        
        if (remaining_match_time != nil) then
            if (remaining_match_time >= strider_spawn_time) and (remaining_match_time < strider_spawn_time + 1) and (strider_can_spawn == true) then 
                strider_can_spawn = false
                spawnStriders(striderSpawnPoints)
                for _, ply in pairs(player.GetAll()) do
                    ply:PrintMessage(4, "Striders arrived!")
                end
            end
        end

        if (remaining_match_time != nil) then
            if (remaining_match_time >= strider_message_time) and (remaining_match_time < strider_message_time + 1) and (strider_message == true) then 
                strider_message = false
                for _, ply in pairs(player.GetAll()) do
                    ply:PrintMessage(4, "Striders will arrive in one minute!")
                    ply:EmitSound("strider_siren")
                end
            end
        end
    end

end

function deadPlayerTimer(ply)
    if ply:GetNWInt('spec_mode') <= 0 then return end
    if ply:GetNWInt('spec_mode') > 0 then
        ply:SetNWInt('spec_mode', ply:GetNWInt('spec_mode') - 1) 
    end
end

function respawnDeadPlayer(ply)
    if (ply:Team() == TEAM_SPECTATOR) and (ply:GetNWInt('spec_mode') == 0) then
        ply:Spawn()
    end
end

function sendTimerData()
    if startGameKey == false and postGameKey == false then
        local remaining_lobby_time = timer.TimeLeft("LobbyTimer")
        if remaining_lobby_time != nil then
            timeSentToClient = toint(remaining_lobby_time)
            net.Start("Timer4Lobby")
            net.WriteInt(timeSentToClient,6)
            net.Broadcast()
        end

    elseif startGameKey == true and postGameKey == false then
        local remaining_match_time = timer.TimeLeft("MatchTimer")

        if remaining_match_time != nil then
            timeSentToClient = toint(remaining_match_time)
            net.Start("Timer4Match")
            net.WriteInt(timeSentToClient,12)
            net.Broadcast()
        end
    
    elseif postGameKey == true then
        local remaining_match_end_time = timer.TimeLeft("MatchEndTimer")
        if remaining_match_end_time != nil then
            timeSentToClient = toint(remaining_match_end_time)
            net.Start("Timer4PostGame")
            net.WriteInt(timeSentToClient,6)
            net.Broadcast()
        end
    end
end

timer.Create("TimerIterator", 1, -1, function()
    sendTimerData()

    if player.GetAll() != 0 then
        for _, ply in pairs(player.GetAll()) do
            deadPlayerTimer(ply)
            respawnDeadPlayer(ply)
        end
    end

    matchProgression()
end)
