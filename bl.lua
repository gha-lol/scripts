--[[if _G.tickLoads then
    if tick() - _G.tickLoads < 10 then
        return
    end
else
    _G.tickLoads = tick()
end]]

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "bl", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1500, 900), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    AutoFarm = Window:CreateTab{
        Title = "AutoFarm",
        Icon = "phosphor-users-bold"
    },
    Automation = Window:CreateTab{
        Title = "Automation",
        Icon = "phosphor-users-bold"
    },
    Teleport = Window:CreateTab{
        Title = "Teleport",
        Icon = "phosphor-users-bold"
    },
    AutoArrowConfig = Window:CreateTab{
        Title = "Auto Arrow Config",
        Icon = "phosphor-users-bold"
    },
    Config = Window:CreateTab{
        Title = "Config",
        Icon = "phosphor-users-bold"
    },
    File = Window:CreateTab{
        Title = "File",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local Service = game:GetService("HttpService")
local noSave = {Identifier = 0, selectedBus = "1", selectedTpNpc = "Chumbo"}
local t = {
    autofarm = false,
    autoraid = false,
    autosell = false,
    autochest = false,
    autopoints = false,
    autoarrow = false,
    autoshop = false,
    distance = 8,
    position = "Down",
    selectedTarget = "dahsdshaudahus",
    selectedShop = "Jotaro Kujo",
    selectedStats = {
      DefenseStat = 0,
      DestructiveEnergyStat = 0,
      DestructivePowerStat = 0,
      PowerStat = 0,
      StrengthStat = 0,
      WeaponStat = 0
    },
    selectedRarity = {
      Common = false,
      Uncommon = false,
      Rare = false,
      Legendary = false
    },
    arrowConfig = {
      shiny = false,
      stands = {}
    },
    keys = {
      M2 = false,
      E = false,
      R = false,
      Z = false,
      X = false,
      C = false,
      V = false
    }
}

if isfile("bl.json") then
    for i,v in pairs(Service:JSONDecode(readfile("bl.json"))) do
        t[i] = v
    end
end


-- Variables

local plr = game.Players.LocalPlayer
local char = plr.Character

local plrData = plr.PlayerData.SlotData
local get_data = game.ReplicatedStorage.requests.miscellaneous.get_data

if char == nil and plr.PlayerGui:FindFirstChild("Main Menu") then
    repeat task.wait(.2)
        pcall(function()
            game:GetService("GuiService").SelectedObject = plr.PlayerGui["Main Menu"].Buttons:WaitForChild("Quick Play")
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Return", false, game)
            task.wait()
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Return", false, game)
        end)
    until plr.Character

    char = plr.Character
end


-- Important 

local part = Instance.new("Part", workspace)
part.Transparency = 1
part.Anchored = true
part.Massless = true
part.CanCollide = false
part.CFrame = char.HumanoidRootPart.CFrame
Instance.new("Attachment", part)

local align = Instance.new("AlignPosition", part)
align.MaxForce = 99e99
align.MaxVelocity = 400
align.Responsiveness = 200
align.Attachment0 = char.HumanoidRootPart.RootAttachment
align.Attachment1 = part.Attachment

local orient = Instance.new("AlignOrientation", part)
orient.MaxTorque = math.huge
orient.Responsiveness = 200
orient.Attachment0 = char.HumanoidRootPart.RootAttachment
orient.Attachment1 = part.Attachment

plr.CharacterAdded:Connect(function(cha)
    char = cha
    if t.autofarm or t.autoraid then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    end
end)


-- Functions

function saveSettings()
    writefile("bl.json", Service:JSONEncode(t))
end

function getInventory()
    return Service:JSONDecode(plrData.Inventory.Value)
end

function getNpc(tab)
    local returner
    
    if tab.All then
        returner = {}
        for _,d in pairs({workspace.Npcs, game.ReplicatedStorage.assets.npc_cache}) do
            for i,v in pairs(d:GetChildren()) do
                table.insert(returner, v.Name)
            end  
        end
    elseif tab.Name then
        returner = workspace.Npcs:FindFirstChild(tab.Name) or game.ReplicatedStorage.assets.npc_cache:FindFirstChild(tab.Name)
    end
  
    return returner
end

local chestsList = {"Rare Chest", "Common Chest"--[[, "Legendary Chest"]]}
function openChests(esperar)
    local opened = false
    for _,item in pairs(getInventory()) do
        if table.find(chestsList, item.Name) then
            opened = true
            game.ReplicatedStorage.requests.character.use_item:FireServer(item.Name, {UseAll = true})
        end
    end
    
    if esperar and opened then
        repeat task.wait() until workspace.Effects:FindFirstChild(chestsList[1]) or workspace.Effects:FindFirstChild(chestsList[2]) --or workspace.Effects:FindFirstChild(chestsList[3])
        
        repeat task.wait(.2) until not workspace.Effects:FindFirstChild(chestsList[1]) and not workspace.Effects:FindFirstChild(chestsList[2]) --and not workspace.Effects:FindFirstChild(chestsList[3])
    end
end

function getData(arg)
    local dataTab = get_data:InvokeServer(arg.Send)
    local returner = {}
    
    if arg.Send == "stand" then
        for i,v in pairs(dataTab) do
            table.insert(returner, v.Name)
        end
    elseif arg.Send == "trait" then
        if arg.Desc then
            if dataTab[arg.Desc] then
                returner = dataTab[arg.Desc].Description
            end
        else
            for i,v in pairs(dataTab) do
                table.insert(returner, i)
            end
        end
    end
    
    return returner
end

function autoShop()
    local function buy(thing)
        local times = 1
        if thing == "Legendary Chest" then times = 3 end
        
        for i=1,times do
            game.ReplicatedStorage.requests.character.raid_shop:FireServer(thing, t.selectedShop)
        end
    end
  
    while t.autoshop do
        local decoded = Service:JSONDecode(plrData.RaidShopPurchases.Value)
        local shop = decoded[decoded.Version]

        if shop then shop = decoded[decoded.Version][t.selectedShop] end
        
        if shop then
            for i,v in pairs({["Legendary Chest"] = 3, ["Lucky Arrow"] = 1}) do
                if shop[i] then
                    if shop[i] < v then
                        buy(i)
                    end
                else
                    buy(i)
                end
            end
        else
            buy("Lucky Arrow")
            buy("Legendary Chest")
        end
        task.wait(5)
    end
end

function autoSell()
    local allAccessorys = get_data:InvokeServer("accessory")
    local sellList = {}
    
    for _,tab in pairs(getInventory()) do
        if tab["Pips"] and allAccessorys[tab.Name] and t.selectedRarity[allAccessorys[tab.Name].Rarity] and not tab.Locked then
            if not tab["duplicates"] then tab["duplicates"] = 1 end
            table.insert(sellList, tab)
        end
    end
    
    game.ReplicatedStorage.requests.general.SellItem:FireServer(sellList)
end

function autoPoints()
    while t.autopoints do
        if plrData.StatPoints.Value > 0 then
            for i,v in pairs(t.selectedStats) do
                if plrData[i].Value < v then
                    local numero = 0
                    
                    if plrData.StatPoints.Value + plrData[i].Value > v then
                        numero = v - plrData[i].Value
                    else
                        numero = plrData.StatPoints.Value
                    end
                    
                    game.ReplicatedStorage.requests.character.increase_stat:FireServer(i,numero)
                end
            end
        end
    task.wait(1) end
end

local gradeNum = {
    S = 5,
    A = 4,
    B = 3,
    C = 2
}

function checkStand()
    local returner = false
    local equipped = Service:JSONDecode(plrData.Stand.Value)
    
    if equipped.Skin and t.arrowConfig.shiny then
        returner = true
    else
        for _,standd in pairs(t.arrowConfig.stands) do
            local matches = 0
            local numChecks = 5
            --if (v.Stand == "Any" or equipped.Name == v.Stand) and (v.Trait == "Any" or equipped.Trait == v.Trait)
            for i,v in pairs(standd) do
                if v ~= "Any" and i ~= "Identifier" then
                    if (i == "Name" or i == "Trait") and equipped[i] == v or i ~= "Name" and i ~= "Trait" and equipped[i] >= gradeNum[v] then
                        matches += 1
                    end
                elseif v == "Any" then
                    numChecks -= 1
                end
            end
            
            if matches == numChecks then returner = true break end
        end
    end
    
    return returner
end

function autoArrow()
    local function useArrow()
        local before = plrData.Stand.Value
            
        repeat task.wait(.5)
            game.ReplicatedStorage.requests.character.use_item:FireServer("Stand Arrow")
        until plrData.Stand.Value ~= before or t.autoarrow == false
    end
    
    while t.autoarrow do task.wait()
        if not checkStand() then
            useArrow()
        else
            local choose
            local equipped = Service:JSONDecode(plrData.Stand.Value)
            local skin = equipped.Skin or "None"
            local autoArrowBindable = Instance.new("BindableFunction")
            
            autoArrowBindable.OnInvoke = function(txt)
                choose = txt
                autoArrowBindable:Destroy()
            end
            
            game.StarterGui:SetCore("SendNotification", {
                Title = "Stand Gotten!",
                Text = "Stand: " .. equipped.Name .. "\n" .. "Skin: " .. skin .. "\n" .. "Trait: " .. equipped.Trait,
                Duration = 999,
                Callback = autoArrowBindable,
                Button1 = "Keep",
                Button2 = "Roll"
            })
          
            repeat task.wait() until choose
            
            if choose == "Keep" then
                break
            else
                useArrow()
            end
        end
    end
    return false
end

function noClip()
    for i,v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

function checkAlive(enemy)
    local returner = false
    if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
        returner = true
    end
    return returner
end

function getEnemy(a)
    local returner
    
    if a.All then
        local aa = {}
        
        for i,v in pairs(workspace.Live:GetChildren()) do
            if not table.find(aa, v.Name:sub(1, -7)) and not string.find(v.Name, "entity clone") and not game.Players:FindFirstChild(v.Name) and v.Name ~= "Server" then
                table.insert(aa, v.Name:sub(1, -7))
            end
        end
        
        returner = aa
    else
        for i,v in pairs(workspace.Live:GetChildren()) do
            if a.Selected then
                if string.find(v.Name, t.selectedTarget) and checkAlive(v) then
                    returner = v
                    break
                end
            else
                if checkAlive(v) and not game.Players:FindFirstChild(v.Name) and v.Name ~= "Server" then
                    returner = v
                    break
                end
            end
        end
    end
    
    return returner
end

function autofarm(bool, ignoreName, tab)
    local enemy
    local posY = -t.distance
    local cfAng = 90
    
    if t[bool] then
        if bool == "autoraid" and game.PlaceId == 14890802310 then return end
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
        
        if bool == "autofarm" and t.autoraid then t.autoraid = false
        elseif bool == "autoraid" and t.autofarm then t.autofarm = false end
    else
        align.Attachment0 = nil
        orient.Attachment0 = nil
    end
  
    while t[bool] do task.wait()
        if t.position == "Top" then
            posY = t.distance
            cfAng = -90
        else
            posY = -t.distance
            cfAng = 90
        end
        
        if bool == "autoraid" and plr.PlayerGui:FindFirstChild("raidcomplete") then
            task.wait(5)
            --queueonteleport('if _G.tickLoads then if tick() - _G.tickLoads < 10 then return end else _G.tickLoads = tick() end loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/bl.lua",true))()')
            queueonteleport('function loadScript(skip) if  _G.tickLoads and not skip then if tick() - _G.tickLoads < 10 then return end else _G.tickLoads = tick() end local s,e = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/bl.lua",true))() end) if not s then task.wait(1) loadScript(true) end end loadScript()')
            
            if t.autochest then
                openChests(true)
            end
            if t.autosell then
                autoSell()
                task.wait(3)
            end
            
            game.ReplicatedStorage.requests.character.retryraid:FireServer()
            task.wait(20)
        end
        
        if not workspace.Effects:FindFirstChild("."..plr.Name.."'s Stand") and not char:FindFirstChild("Stand_Weapon") then
            char["client_character_controller"].SummonStand:FireServer()
            task.wait()
        end

        noClip()
        
        if enemy and checkAlive(enemy) and (ignoreName or string.find(enemy.Name, t.selectedTarget)) then
            if plr:DistanceFromCharacter(enemy.HumanoidRootPart.Position) > 500 then
                char.HumanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,-8,0))
            end
            
            part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,posY,0)) * CFrame.Angles(math.rad(cfAng),0,0)
            
            for i,v in pairs(t.keys) do
                if i ~= "M2" and v then
                    char["client_character_controller"].Skill:FireServer(tostring(i),true)
                elseif i == "M2" and v then
                    char["client_character_controller"]["M2"]:FireServer(true,false)
                end
            end
            
            char["client_character_controller"]["M1"]:FireServer(true,false)
        else
            enemy = getEnemy(tab)
        end
    end
end


-- Script


-- AutoFarm Tab

-- Raids Section

Tabs.AutoFarm:CreateParagraph("Aligned Paragraph", {Title = "Raids Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local autoraidToggle = Tabs.AutoFarm:CreateToggle("autoraidToggle", {Title = "Auto Raid", Default = t.autoraid})
autoraidToggle:OnChanged(function()
    t.autoraid = Options.autoraidToggle.Value
        
    autofarm("autoraid", true, {})
end)

local autochestToggle = Tabs.AutoFarm:CreateToggle("autochestToggle", {Title = "Auto Open Chest", Default = t.autochest})
autochestToggle:OnChanged(function()
    t.autochest = Options.autochestToggle.Value
end)

local autosellToggle = Tabs.AutoFarm:CreateToggle("autosellToggle", {Title = "Auto Sell", Default = t.autosell})
autosellToggle:OnChanged(function()
    t.autosell = Options.autosellToggle.Value
end)

-- Main Game Section

Tabs.AutoFarm:CreateParagraph("Aligned Paragraph", {Title = "Main Game Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local autofarmToggle = Tabs.AutoFarm:CreateToggle("autofarmToggle", {Title = "Auto Farm Selected", Default = t.autofarm})
autofarmToggle:OnChanged(function()
    t.autofarm = Options.autofarmToggle.Value
        
    autofarm("autofarm", false, {Selected = true})
end)

selectDropdown = Tabs.AutoFarm:CreateDropdown("selectDropdown", {Title = "Target", Values = {}, Searchable = true, Multi = false, Default = t.selectedTarget})
selectDropdown:OnChanged(function(Value)
    t.selectedTarget = Value
end)
selectDropdown:SetValues(getEnemy({All = true}))

Tabs.AutoFarm:CreateButton{Title = "Update Target List", Description = "", Callback = function()
    selectDropdown:SetValues(getEnemy({All = true}))
end}


-- Automation Tab

-- Auto Shop Section

Tabs.Automation:CreateParagraph("Aligned Paragraph", {Title = "Auto Shop Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local autoshopToggle = Tabs.Automation:CreateToggle("autoshopToggle", {Title = "Auto Shop", Default = t.autoshop})
autoshopToggle:OnChanged(function()
    t.autoshop = Options.autoshopToggle.Value

    autoShop()
end)

local allShops = {}
for i,v in pairs(Service:JSONDecode(plrData.RaidTokens.Value)) do
    table.insert(allShops, i)
end

local autoshopDrop = Tabs.Automation:CreateDropdown("autoshopDrop", {Title = "Shop To Buy", Values = allShops, Multi = false, Default = t.selectedShop})
autoshopDrop:OnChanged(function(Value)
    t.selectedShop = Value
end)

-- Auto Arrow Section

Tabs.Automation:CreateParagraph("Aligned Paragraph", {Title = "Auto Arrow Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local autoarrowToggle = Tabs.Automation:CreateToggle("autoarrowToggle", {Title = "Auto Arrow", Default = t.autoarrow})
autoarrowToggle:OnChanged(function()
    t.autoarrow = Options.autoarrowToggle.Value

    if game.PlaceId == 14890802310 then
        local e = autoArrow()
        if not e then
            t.autoarrow = false
            autoarrowToggle:SetValue(false)
        end
    end
end)

local stopshinyToggle = Tabs.Automation:CreateToggle("stopshinyToggle", {Title = "Stop on Shiny", Default = t.arrowConfig.shiny})
stopshinyToggle:OnChanged(function()
    t.arrowConfig.shiny = Options.stopshinyToggle.Value
end)

local dropss = {"Stand", "Trait", "Strength", "Specialty", "Speed"}
local descTrait

for i,v in pairs(dropss) do
    local tabb = {}
    if v == "Stand" then
        tabb = {"Any", table.unpack(getData({Send = "stand"}))}
    elseif v == "Trait" then
        tabb = {"Any", table.unpack(getData({Send = "trait"}))}
    else
        tabb = {"Any", "S", "A", "B", "C"}
    end
  
    local selectTopDown = Tabs.Automation:CreateDropdown("selectadsdasd"..v, {Title = v, Values = tabb, Multi = false, Default = "Any"})
    selectTopDown:OnChanged(function(Value)
        noSave[v] = Value
        
        if v == "Trait" then
            pcall(function()
                descTrait:SetValue(getData({Send = "trait", Desc = Value}))
            end)
        end
    end)
    if v == "Trait" then
        descTrait = Tabs.Automation:CreateParagraph("Aligned Paragraph", {Title = "Description:", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})
    end
end

Tabs.Automation:CreateButton{Title = "Add Stand", Description = "", Callback = function()
    table.insert(t.arrowConfig.stands, {Name = noSave.Stand, Trait = noSave.Trait, Strength = noSave.Strength, Specialty = noSave.Specialty, Speed = noSave.Speed, Identifier = math.random(1,999)})
end}

Tabs.Automation:CreateButton{Title = "Print All Stands", Description = "", Callback = function()
    for i,v in pairs(t.arrowConfig.stands) do
        print("---------")
        print("Stand "..tostring(i))
        for k,l in pairs(v) do
            print(k,l)
        end
    end
end}

Tabs.Automation:CreateInput("InputIndenadsdsa", {Title = "Input Identifier", Default = tostring(0), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(value)
    noSave.Identifier = tonumber(value)
end})

Tabs.Automation:CreateButton{Title = "Delete Stand", Description = "", Callback = function()
    for i,v in pairs(t.arrowConfig.stands) do
        if v.Identifier == noSave.Identifier then
            table.remove(t.arrowConfig.stands, i)
            break
        end
    end
end}

-- Auto Points Section

Tabs.Automation:CreateParagraph("Aligned Paragraph", {Title = "Auto Points Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local autopointsToggle = Tabs.Automation:CreateToggle("autopointsToggle", {Title = "Auto Points", Default = t.autopoints})
autopointsToggle:OnChanged(function()
    t.autopoints = Options.autopointsToggle.Value
        
    autoPoints()
end)

for i,v in pairs(t.selectedStats) do
    Tabs.Automation:CreateInput("InputStat"..tostring(i), {Title = i, Default = tostring(v), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(value)
        t.selectedStats[i] = tonumber(value)
    end})
end


-- Teleport Tab

-- Npc Section

Tabs.Teleport:CreateParagraph("Aligned Paragraph", {Title = "Npcs Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

npcTpDown = Tabs.Teleport:CreateDropdown("npcTpDown", {Title = "Npc", Values = getNpc({All = true}), Searchable = true, Multi = false, Default = noSave.selectedTpNpc})
npcTpDown:OnChanged(function(Value)
    noSave.selectedTpNpc = Value
end)

Tabs.Teleport:CreateButton{Title = "Teleport to Npc", Description = "", Callback = function()
    char:PivotTo(getNpc({Name = noSave.selectedTpNpc}):GetPivot())
end}

-- Bus Section

Tabs.Teleport:CreateParagraph("Aligned Paragraph", {Title = "Bus Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local busTable = {}
for i=1,20 do table.insert(busTable, tostring(i)) end
busDown = Tabs.Teleport:CreateDropdown("busDown", {Title = "Bus Stop", Values = busTable, Searchable = true, Multi = false, Default = "1"})
busDown:OnChanged(function(Value)
    noSave.selectedBus = Value
end)

Tabs.Teleport:CreateButton{Title = "Teleport to Bus Stop", Description = "", Callback = function()
    char:PivotTo(workspace.Map["Bus Stops"][noSave.selectedBus]:GetPivot())
end}


-- Config Tab

-- Global Section

Tabs.Config:CreateParagraph("Aligned Paragraph", {Title = "Global Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

Tabs.Config:CreateInput("InputDistance", {Title = "Distance", Default = tostring(t.distance), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(value)
    t.distance = tonumber(value)
end})

selectTopDown = Tabs.Config:CreateDropdown("selectTopDown", {Title = "Farm Position", Values = {"Top", "Down"}, Multi = false, Default = t.position})
selectTopDown:OnChanged(function(Value)
    t.position = Value
end)


-- Auto Sell Section

Tabs.Config:CreateParagraph("Aligned Paragraph", {Title = "Auto Sell Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

for i,v in pairs(t.selectedRarity) do
    local key = Tabs.Config:CreateToggle("rarity"..tostring(i), {Title = "Sell "..tostring(i), Default = v})
    key:OnChanged(function()
        t.selectedRarity[i] = Options["rarity"..tostring(i)].Value
    end)
end


-- Skills Section

Tabs.Config:CreateParagraph("Aligned Paragraph", {Title = "Skills Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

for i,v in pairs(t.keys) do
    local key = Tabs.Config:CreateToggle("key"..tostring(i), {Title = "Use "..tostring(i), Default = v})
    key:OnChanged(function()
        t.keys[i] = Options["key"..tostring(i)].Value
    end)
end


-- File

Tabs.File:CreateButton{Title = "Save Config", Description = "", Callback = function()
    saveSettings()
end}


--[[ Activating Toggles Etc
task.wait()
autofarmToggle:SetValue(t.autofarm)
autoraidToggle:SetValue(t.autoraid)
autochestToggle:SetValue(t.autochest)]]
autosellToggle:SetValue(t.autosell)
autoshopToggle:SetValue(t.autoshop)
