GM.Name = "Manhunt"
GM.Author = "Hyperion"
GM.Email = "giovanicamargo99@gmail.com"
GM.Website = "N/A"

DeriveGamemode("base")

include("load_vehicles.lua")

spawnedWeapons = {}
spawnedRelics = {}
spawnedStriders = {}
spawnedVehicles = {}

function GM:Initialize()
    -- Initialize
end

function AddSpawnedWeapon(weaponEntity)
    table.insert(spawnedWeapons, weaponEntity)
end

function RemoveSpawnedWeapons()
    for _, weaponEntity in ipairs(spawnedWeapons) do
        if IsValid(weaponEntity) then
            weaponEntity:Remove()
        end
    end
    spawnedWeapons = {}
end

function AddRelic(relic)
    table.insert(spawnedRelics, relic)
end

function RemoveRelics()
    for _, relic in ipairs(spawnedRelics) do
        if IsValid(relic) then
            relic:Remove()
        end
    end
    spawnedRelics = {}
end

function AddSpawnedVehicle(vehicleEntity)
    table.insert(spawnedVehicles, vehicleEntity)
end

function RemoveSpawnedVehicles()
    for _, vehicleEntity in ipairs(spawnedVehicles) do
        if IsValid(vehicleEntity) then
            vehicleEntity:Remove()
        end
    end
    spawnedVehicles = {}
end

function SpawnVehicleCoord(lista, pos)
    local randomVehicle = lista[math.random(1, #lista)]
    local spawnPos = pos

    local vehicleEntity = ents.Create(randomVehicle)
    if IsValid(vehicleEntity) then
        vehicleEntity:SetModel("models/airboat.mdl")
        vehicleEntity:SetPos(spawnPos)
        vehicleEntity:Spawn()
        AddSpawnedVehicle(vehicleEntity)
    end
end

function SpawnWeaponCoord(lista, pos)
    local randomWeapon = lista[math.random(1, #lista)]
    local spawnPos = pos

    local weaponEntity = ents.Create(randomWeapon)
    if IsValid(weaponEntity) then
        weaponEntity:SetPos(spawnPos)
        weaponEntity:Spawn()
        -- Add the spawned weapon to the list
        AddSpawnedWeapon(weaponEntity)
    end
end

function SpawnRelic(pos)
    local chance = 0.5
    local try_spawn = math.Rand(0, 1)
    local spawnPos = pos
    local ref_relic = "entity_relic"

    if try_spawn <= chance then
        local relic = ents.Create(ref_relic)
        if IsValid(relic) then
            relic:SetPos(spawnPos)
            relic:Spawn()
            -- Add the spawned relic to the list
            AddRelic(relic)
        end
    end
end

local function SpawnStriderAtPosition(pos)
    local Pos = pos
    local strider = ents.Create("npc_strider")
    if not IsValid(strider) then return end
    table.insert(spawnedStriders, strider)
    strider:SetPos(Pos)
    strider:Spawn()
end

function spawnStriders(list)
    local spawnCount = 0
    local timerName = "SpawnStriderTimer"

    local function SpawnStriderTimer()
        spawnCount = spawnCount + 1
        SpawnStriderAtPosition(list[spawnCount])
        if spawnCount >= #list then
            timer.Remove(timerName)
        end
    end
    timer.Create(timerName, 0.1, #list, SpawnStriderTimer)
end

function removeStriders()
    for _, strider in ipairs(spawnedStriders) do
        if IsValid(strider) then
            strider:Remove()
        end
    end
    spawnedStriders = {}
end
