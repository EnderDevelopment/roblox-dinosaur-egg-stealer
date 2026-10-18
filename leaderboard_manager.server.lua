-- Leaderboard Manager Script

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local playerDataStore = DataStoreService:GetDataStore("PlayerData")

local function createLeaderstats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local eggs = Instance.new("IntValue")
    eggs.Name = "Eggs"
    eggs.Value = 0
    eggs.Parent = leaderstats

    local money = Instance.new("IntValue")
    money.Name = "Money"
    money.Value = 0
    money.Parent = leaderstats

    local rebirths = Instance.new("IntValue")
    rebirths.Name = "Rebirths"
    rebirths.Value = 0
    rebirths.Parent = leaderstats
end

local function savePlayerData(player)
    local data = {
        Eggs = player.leaderstats.Eggs.Value,
        Money = player.leaderstats.Money.Value,
        Rebirths = player.leaderstats.Rebirths.Value
    }
    
    local success, err = pcall(function()
        playerDataStore:SetAsync(player.UserId, data)
    end)
    
    if not success then
        warn("Failed to save player data: " .. err)
    end
end

local function loadPlayerData(player)
    local success, data = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        player.leaderstats.Eggs.Value = data.Eggs or 0
        player.leaderstats.Money.Value = data.Money or 0
        player.leaderstats.Rebirths.Value = data.Rebirths or 0
    else
        warn("Failed to load player data: " .. (data or "Unknown error"))
    end
end

Players.PlayerAdded:Connect(function(player)
    createLeaderstats(player)
    loadPlayerData(player)

    player.CharacterAdded:Connect(function(character)
        -- Additional character setup if needed
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
end)

-- Example of how to update leaderstats
-- local player = game.Players.LocalPlayer
-- player.leaderstats.Eggs.Value = player.leaderstats.Eggs.Value + 1