local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/libEditHawk.lua", true))()
local win = lib:Window({ScriptName = "Jujutsu", DestroyIfExists = true, Theme = "Dark"})
win:Minimize({visibility = true, OpenButton = true, Callback = function() end})
local plr = game.Players.LocalPlayer

function remote(name, args)
    local rem = game.ReplicatedStorage:FindFirstChild(name, true)
    
    if rem then
        if rem:IsA("RemoteEvent") then
            rem:FireServer(unpack(args))
        elseif rem:IsA("RemoteFunction") then
            rem:InvokeServer(unpack(args))
        end
    end
end


-- PARTIDA TAB

local tab1 = win:Tab("Partida")
local tab1Section = tab1:Section("Unit Placement")

local unitListPartida
local partidaSelected
local spawnedSelected
local spawnedDropdown
local upgradeSelected = "1"
local placePriceLabel
local upgradePriceBruh
local transformUpgrade = "1"
local transformSelected
local transformPrice
local transformList

function unitPartidaTable()
    local tab = {}
    
    for i,v in pairs(game.ReplicatedStorage.Towers:GetChildren()) do
        if v.Name ~= "Upgrades" then
            table.insert(tab, v.Name)
        end
    end
    
    return tab
end

function getSpawnedUnits()
    local tab = {}
    
    for i,v in pairs(workspace.Towers:GetChildren()) do
        table.insert(tab, v.Name)
    end
    
    return tab
end

tab1Section:TextBox("Search Unit", "Name Here", function(unitt)
    if unitt == " " then
        unitListPartida:Refresh(unitPartidaTable())
    else
        local tab = {}
        
        for i,v in pairs(game.ReplicatedStorage.Towers:GetChildren()) do
            if v.Name:lower():find(unitt:lower()) and v.Name ~= "Upgrades" then
                table.insert(tab, v.Name)
            end
        end
        
        unitListPartida:Refresh(tab)
    end
end)

unitListPartida = tab1Section:Dropdown("Unit List", unitPartidaTable(), function(sele)
    partidaSelected = sele
    placePriceLabel:UpdateLabel("Placement Price: " .. tostring(game.ReplicatedStorage.Towers[sele].Config.Price.Value),"")
end)

placePriceLabel = tab1Section:Label("Placement Price: ","") 

tab1Section:Button("Spawn Selected",function()
    remote("SpawnTower", {partidaSelected, plr.Character.HumanoidRootPart.CFrame})
end)


local tab1Section2 = tab1:Section("Already Placed Units")

local spawnedDropdown = tab1Section2:Dropdown("Spawned Units", getSpawnedUnits(), function(unitt)
    spawnedSelected = unitt
    upgradePriceBruh:UpdateLabel("Upgrade Price: " .. tostring(game.ReplicatedStorage.Towers.Upgrades[spawnedSelected .. tostring(upgradeSelected)].Config.Price.Value),"")
end)

tab1Section2:Dropdown("Select Upgrade", {1,2,3,4}, function(unitt)
    upgradeSelected = tostring(unitt)
    upgradePriceBruh:UpdateLabel("Upgrade Price: " .. tostring(game.ReplicatedStorage.Towers.Upgrades[spawnedSelected .. tostring(upgradeSelected)].Config.Price.Value),"")
end)

upgradePriceBruh = tab1Section2:Label("Upgrade Price: ","")

tab1Section2:Button("Upgrade Unit", function()
    local nomeReal
    local inst = workspace.Towers[spawnedSelected]
    
    if spawnedSelected:sub(-1):match("%d") then
        nomeReal = spawnedSelected:sub(1,-2)
    else
        nomeReal = spawnedSelected
    end
    
    remote("SpawnTower", {nomeReal .. tostring(upgradeSelected), inst.HumanoidRootPart.CFrame, inst})
end)

local tab1Section3 = tab1:Section("Transform Selected Spawned Unit")

tab1Section3:TextBox("Search Unit", "Name Here", function(unitt)
    if unitt == " " then
        transformList:Refresh(unitPartidaTable())
    else
        local tab = {}
        
        for i,v in pairs(game.ReplicatedStorage.Towers:GetChildren()) do
            if v.Name:lower():find(unitt:lower()) and v.Name ~= "Upgrades" then
                table.insert(tab, v.Name)
            end
        end
        
        transformList:Refresh(tab)
    end
end)

transformList = tab1Section3:Dropdown("Unit List", unitPartidaTable(), function(sele)
    transformSelected = sele
    transformPrice:UpdateLabel("Placement Price: " .. tostring(game.ReplicatedStorage.Towers.Upgrades[sele .. tostring(transformUpgrade)].Config.Price.Value),"")
end)

tab1Section3:Dropdown("Select Upgrade", {1,2,3,4}, function(sele)
    transformUpgrade = tostring(sele)
    transformPrice:UpdateLabel("Placement Price: " .. tostring(game.ReplicatedStorage.Towers.Upgrades[transformSelected .. tostring(transformUpgrade)].Config.Price.Value),"")
end)

transformPrice = tab1Section3:Label("Transform Price: ","")

tab1Section3:Button("Transform",function()
    local inst = workspace.Towers[spawnedSelected]
    
    remote("SpawnTower", {transformSelected .. tostring(transformUpgrade), inst.HumanoidRootPart.CFrame, inst})
end)

workspace.Towers.ChildAdded:Connect(function()
    spawnedDropdown:Refresh(getSpawnedUnits(), false)
end)
workspace.Towers.ChildRemoved:Connect(function()
    spawnedDropdown:Refresh(getSpawnedUnits(), false)
end)


-- TRADE TAB

local tab2 = win:Tab("Trade")

local unitListDrop
local selectedUnit
local plrName = ""
local amountToAdd = 1

function unitTable()
    local tab = {}
    
    for i,v in pairs(game.ReplicatedStorage.AnimationsCase:GetChildren()) do
        table.insert(tab, v.Name)
    end
    
    return tab
end

tab2:TextBox("Trading With", "Player Name", function(unitt)
    plrName = unitt
end)

tab2:TextBox("Search Unit", "Name Here", function(unitt)
    if unitt == " " then
        unitListDrop:Refresh(unitTable())
    else
        local tab = {}
        
        for i,v in pairs(game.ReplicatedStorage.AnimationsCase:GetChildren()) do
            if v.Name:lower():find(unitt:lower()) then
                table.insert(tab, v.Name)
            end
        end
        
        unitListDrop:Refresh(tab)
    end
end)

unitListDrop = tab2:Dropdown("Unit List", unitTable(), function(sele)
    selectedUnit = sele
end)

tab2:TextBox("Amount to Add", "Amount Here", function(unitt)
    amountToAdd = tonumber(unitt)
end)

tab2:Button("Add To Trade", function()
    pcall(function()
        for i=1,amountToAdd do
            remote("UpdateTowers", {selectedUnit, game.Players[plrName], "Add"})
        end
    end)
end)


-- MISC TAB

local mahoragaAmount = 1

local tab3 = win:Tab("Misc")

tab3:Button("Get Money",function()
    for i=1,9990 do
        remote("RDT", {7})
    end
end)

tab3:TextBox("Amount of Mahoraga", "Amount Here", function(amount)
    mahoragaAmount = tonumber(amount)
end)

tab3:Button("Spawn Mahoragas", function()
    remote("Unit", {"Mahoraga", mahoragaAmount, workspace.Map:FindFirstChildOfClass("Folder")})
end)
