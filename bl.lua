--[[if _G.tickLoads then
    if tick() - _G.tickLoads < 10 then
        return
    end
else
    _G.tickLoads = tick()
end]]

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "bl", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    AutoFarm = Window:CreateTab{
        Title = "AutoFarm",
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
local t = {
    autofarm = false,
    autoraid = false,
    autosell = false,
    autochest = false,
    distance = 8,
    position = "Down",
    selectedTarget = "dahsdshaudahus",
    selectedRarity = {
      Common = false,
      Uncommon = false,
      Rare = false,
      Legendary = false
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
    return Service:JSONDecode(plr.PlayerData.SlotData.Inventory.Value)
end

local chestsList = {"Rare Chest", "Common Chest"--[[, "Legendary Chest"]]}
function openChests(esperar)
    for _,item in pairs(getInventory()) do
        if table.find(chestsList, item.Name) then
            game.ReplicatedStorage.requests.character.use_item:FireServer(item.Name, {UseAll = true})
        end
    end
    
    if esperar then
        repeat task.wait() until workspace.Effects:FindFirstChild(chestsList[1]) or workspace.Effects:FindFirstChild(chestsList[2]) --or workspace.Effects:FindFirstChild(chestsList[3])
        
        repeat task.wait(.2) until not workspace.Effects:FindFirstChild(chestsList[1]) and not workspace.Effects:FindFirstChild(chestsList[2]) --and not workspace.Effects:FindFirstChild(chestsList[3])
    end
end

function autoSell()
    local allAccessorys = game.ReplicatedStorage.requests.miscellaneous.get_data:InvokeServer("accessory")
    local sellList = {}
    
    for _,tab in pairs(getInventory()) do
        if tab["Pips"] and allAccessorys[tab.Name] and t.selectedRarity[allAccessorys[tab.Name].Rarity] and not tab.Locked then
            if not tab["duplicates"] then tab["duplicates"] = 1 end
            table.insert(sellList, tab)
        end
    end
    
    game.ReplicatedStorage.requests.general.SellItem:FireServer(sellList)
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
        
    if game.PlaceId ~= 14890802310 then
        autofarm("autoraid", true, {})
    end
end)

local autochestToggle = Tabs.AutoFarm:CreateToggle("autochestToggle", {Title = "Auto Open Chest", Default = t.autochest})
autochestToggle:OnChanged(function()
    t.autochest = Options.autochestToggle.Value
end)

-- Main Game Section

Tabs.AutoFarm:CreateParagraph("Aligned Paragraph", {Title = "Main Game Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local autofarmToggle = Tabs.AutoFarm:CreateToggle("autofarmToggle", {Title = "Auto Farm Selected", Default = t.autofarm})
autofarmToggle:OnChanged(function()
    t.autofarm = Options.autofarmToggle.Value
        
    autofarm("autofarm", false, {Selected = true})
end)

selectDropdown = Tabs.AutoFarm:CreateDropdown("selectDropdown", {Title = "Target", Values = {}, Multi = false, Default = t.selectedTarget})
selectDropdown:OnChanged(function(Value)
    t.selectedTarget = Value
end)
selectDropdown:SetValues(getEnemy({All = true}))

Tabs.AutoFarm:CreateButton{Title = "Update Target List", Description = "", Callback = function()
    selectDropdown:SetValues(getEnemy({All = true}))
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

local autosellToggle = Tabs.Config:CreateToggle("autosellToggle", {Title = "Auto Sell", Default = t.autosell})
autosellToggle:OnChanged(function()
    t.autosell = Options.autosellToggle.Value
end)

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


-- Activating Toggles Etc
task.wait()
autofarmToggle:SetValue(t.autofarm)
autoraidToggle:SetValue(t.autoraid)
autochestToggle:SetValue(t.autochest)
autosellToggle:SetValue(t.autosell)
