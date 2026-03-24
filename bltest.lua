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
    Config = Window:CreateTab{
        Title = "Config",
        Icon = "phosphor-users-bold"
    },
    File = Window:CreateTab{
        Title = "File",
        Icon = "phosphor-users-bold"
    },
    AutoArrowConfig = Window:CreateTab{
        Title = "Auto Arrow Config",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local Service = game:GetService("HttpService")
local noSave = {Identifier = 0, selectedBus = "1", selectedTpNpc = "Chumbo", cds = {}, autoarrow = false}
local t = {
    autofarm = false,
    autoraid = false,
    autosell = false,
    autochest = false,
    autopoints = false,
    autoshop = false,
    instakill = false,
    noVfx = false,
    blackscreen = false,
    keepPvEDmg = false,
    holdskill = "Z",
    distance = 8,
    position = "Down",
    selectedTarget = "dahsdshaudahus",
    selectedShop = "Jotaro Kujo",
    keepPvEAccessory = {
        Common = false,
        Uncommon = false,
        Rare = false,
        Legendary = false,
        Mythical = false
    },
    shopConfig = {
        buyCashShop = false,
        items = {}
    },
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
      Legendary = false,
      Mythical = false
    },
    arrowConfig = {
      shiny = false,
      stands = {},
      ignoreSkinRarity = {Common = false, Rare = false, Legendary = false, Secret = false}
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


-- Variables

local plr = game.Players.LocalPlayer
local char = plr.Character

local plrData = plr.PlayerData.SlotData
local get_data = game.ReplicatedStorage.requests.miscellaneous.get_data
local allSkills = get_data:InvokeServer("ability")


-- Pressing Start

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

local UIElements = {}

function createElement(tab, elementType, id, data, callback)
    local element

    -- Criador dinâmico
    if elementType == "Toggle" then
		element = tab:CreateToggle(id, data)
	elseif elementType == "Paragraph" then
		element = tab:CreateParagraph(id, data)
	elseif elementType == "Button" then
		element = tab:CreateButton(data)
	elseif elementType == "Dropdown" then
		element = tab:CreateDropdown(id, data)
	end

    if not element then
        warn("Failed to create element:", elementType, id)
        return nil
    end

    -- Salva global
    if not elementType == "Paragraph" then
        UIElements[id] = element
    end

    -- Auto OnChanged
    if callback and element.OnChanged then
        element:OnChanged(function(...)
            callback(element, ...)
        end)
    end

    -- Auto Option shortcut
    if Options[id] then
        element.Option = Options[id]
    end

    return element
end

local part = Instance.new("Part", workspace)
part.Transparency = 1
part.Anchored = true
part.Massless = true
part.CanCollide = false
part.CFrame = char.HumanoidRootPart.CFrame
Instance.new("Attachment", part)

local align = Instance.new("AlignPosition", part)
align.MaxForce = 99e99
align.MaxVelocity = 500
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
    if t.autofarm or t.autoraid and game.PlaceId ~= 14890802310 then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    end
end)

if isfile("bl.json") then
    for i,v in pairs(Service:JSONDecode(readfile("bl.json"))) do
        if typeof(v) == "table" then
            for k,l in pairs(v) do
                t[i][k] = l
            end
        else
            t[i] = v
        end
    end
end

if not _G.fphh then
  	_G.fphh = true
  	local ind
  	ind = hookmetamethod(game,"__index",newcclosure(function(self, v)
  		  if not checkcaller() and self == workspace and v == "FallenPartsDestroyHeight" then
  			    return -500
  		  end
  	  	return ind(self,v)
  	end))
end

game.ReplicatedStorage.requests.character_server_client.communicate.OnClientEvent:Connect(function(tab)
    noSave.cds = tab.Cooldowns
end)


-- Functions

function saveSettings()
    writefile("bl.json", Service:JSONEncode(t))
end

function getInventory()
    return Service:JSONDecode(plrData.Inventory.Value)
end

function isCooldown(button)
    local returner = true
    local equipped = Service:JSONDecode(plrData.Stand.Value)
    
    for i,v in pairs(allSkills) do
        if tostring(i):match(equipped.Name .. ": ") and v.Keybind == button and not noSave.cds[v.Name] then
            returner = false
            break
        end
    end
    
    return returner
end

local allScreens = {}
function blackScreen()
    if t.blackscreen then
        for _,v in pairs(allScreens) do v:Destroy() end
        local a = Instance.new("ScreenGui", plr.PlayerGui)
    		a.IgnoreGuiInset = true
    		local b = Instance.new("Frame", a)
    		b.Size = UDim2.new(2,0,2,0)
    		b.Position = UDim2.new(0,0,0,0)
    		b.BackgroundColor3 = Color3.new(0,0,0)
    		b.ZIndex = -100
        
        table.insert(allScreens, a)
    else
        for _,v in pairs(allScreens) do v:Destroy() end
    end
end

function changeVfx()
    local a = getconnections(game:GetService("ReplicatedStorage").requests.general.vfx.OnClientEvent)

    for _,v in pairs(a) do
        if t.noVfx then
            v:Disable()
        else
            v:Enable()
        end
    end
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
    elseif arg.Send == "stand_skin" then
        returner = dataTab
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

local isAutoShop = false
function autoShop()
    if isAutoShop then return end
    isAutoShop = true

    local function buy(thing, sho)
        if sho == "raid" then
            local times = 1
            if thing == "Legendary Chest" then times = 3 end
            
            for i=1,times do
                game.ReplicatedStorage.requests.character.raid_shop:FireServer(thing, t.selectedShop)
            end
        else
            game.ReplicatedStorage.requests.character.cash_shop:FireServer(thing)
        end
    end
  
    while t.autoshop do
        local decoded = Service:JSONDecode(plrData.RaidShopPurchases.Value)
        local shop = decoded[decoded.Version]

        if shop then shop = decoded[decoded.Version][t.selectedShop] end
        
        if shop then
            for i,v in pairs({["Lucky Arrow"] = 1, ["Legendary Chest"] = 3}) do
                if shop[i] then
                    if shop[i] < v then
                        buy(i, "raid")
						task.wait(1)
                    end
                else
                    buy(i, "raid")
                end
            end
        else
            buy("Lucky Arrow", "raid")
            buy("Legendary Chest", "raid")
        end

        task.wait(1)

        if t.shopConfig.buyCashShop then
            local decodedCashPurchases = Service:JSONDecode(plrData.CashShopPurchases.Value)
            local decodedCashShop = Service:JSONDecode(plrData.CashShop.Value)

            for i,v in pairs(t.shopConfig.items) do
                if decodedCashShop[v] and not decodedCashPurchases[v] then
                    buy(v, "cash")
                end
            end
        end
        task.wait(4)
    end
    isAutoShop = false
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

    if t.keepPvEDmg then
        for i,v in pairs(sellList) do
            if t.keepPvEAccessory[allAccessorys[v.Name].Rarity] then
                local count = 0

                for _,pip in pairs(v.Pips) do
                    if pip == "PvEDamage" then
                        count += 1
                    end
                end

                if count >= 2 then
                    table.remove(sellList, i)
                end
            end
        end
    end
    
    game.ReplicatedStorage.requests.general.SellItem:FireServer(sellList)
end

local isAutoPoints = false
function autoPoints()
    if isAutoPoints then return end
    isAutoPoints = true

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
    isAutoPoints = false
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
    
    if equipped.Skin and t.arrowConfig.shiny and not t.arrowConfig.ignoreSkinRarity[getData({Send="stand_skin"})[equipped.Name][equipped.Skin]] then
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

local isAutoArrow = false
function autoArrow()
    if isAutoArrow then return end
    isAutoArrow = true

    local function useArrow()
        local before = plrData.Stand.Value
            
        repeat task.wait(.5)
            game.ReplicatedStorage.requests.character.use_item:FireServer("Stand Arrow")
        until plrData.Stand.Value ~= before or noSave.autoarrow == false
    end
    
    while noSave.autoarrow do task.wait()
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
    isAutoArrow = false
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

function setAligns(a)
    if a then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    else
        align.Attachment0 = nil
        orient.Attachment0 = nil
    end
end

local isAutoFarming = false
function autofarm(bool, ignoreName, tab)
    if t[bool] then
        if bool == "autoraid" and game.PlaceId == 14890802310 then setAligns(false) return end
        setAligns(true)
        
        if bool == "autofarm" and t.autoraid then t.autoraid = false task.wait(1)
        elseif bool == "autoraid" and t.autofarm then t.autofarm = false task.wait(1) end
    else
        if not t.autoraid and not t.autofarm then
            setAligns(false)
        end
    end

    if isAutoFarming then return end
    isAutoFarming = true

    local enemy
    local canInsta = false
    local isBoss = false
    local bossMaxHealth = nil
    local lastHealth = 9999
    local repeating
    
    local posY = -t.distance
    local cfAng = 90
  
    while t[bool] do task.wait()
        if t.position == "Top" then
            posY = t.distance
            cfAng = -90
        else
            posY = -t.distance
            cfAng = 90
        end
        
        if bool == "autoraid" and plr.PlayerGui:FindFirstChild("raidcomplete") then
            task.wait(1.5)
            --queueonteleport('if _G.tickLoads then if tick() - _G.tickLoads < 10 then return end else _G.tickLoads = tick() end loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/bl.lua",true))()')
            queueonteleport('function loadScript(skip) if  _G.tickLoads and not skip then if tick() - _G.tickLoads < 10 then return end else _G.tickLoads = tick() end local s,e = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/bl.lua",true))() end) if not s then task.wait(1) loadScript(true) end end loadScript()')
            
            if t.autochest then
                openChests(true)
            end
            if t.autosell then
                autoSell()
                task.wait(1)
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

            if enemy.Humanoid.MaxHealth > 1400 and t.instakill then
                isBoss = true
                bossMaxHealth = enemy.Humanoid.MaxHealth
                if lastHealth == nil then lastHealth = enemy.Humanoid.Health end
                
                if enemy.Humanoid.Health - lastHealth > 25 and not canInsta and not repeating then
                    repeating = true

                    local con = game:GetService("ReplicatedStorage").requests.general.vfx.OnClientEvent:Connect(function(_,tab)

                        if tab.Part and tab.Part.Parent.Parent.Name:lower() == "awakening" and tab.WeldPart.Parent == enemy then
                            task.wait(.1)
                            canInsta = true
                            con:Disconnect()
                        end

                    end)
                end

                if enemy.Humanoid.Health < lastHealth then
                    lastHealth = enemy.Humanoid.Health
                end
            else
                repeating = false
                canInsta = false
                isBoss = false
            end

            if not enemy:FindFirstChild("IFrame") then
                local done = 0
                local subst = nil
                local vvalue = false
    				
                for i,v in pairs(t.keys) do
                    done += 1
                    if done == 1 and isBoss and t.instakill and i ~= t.holdskill then
                        subst = i
                        vvalue = v
      						
                        i = t.holdskill
                        v = true
          					elseif done > 1 and subst and i == t.holdskill then
                        i = subst
                        v = vvalue
                    end
					
                    if i ~= "M2" and v then
                        if i == t.holdskill and isBoss and t.instakill then
                            if canInsta then
                                char["client_character_controller"].Skill:FireServer(tostring(i),true)
                            end
                        elseif not isCooldown(i) then
                            char["client_character_controller"].Skill:FireServer(tostring(i),true)
                        end
                    elseif i == "M2" and v then
                        char["client_character_controller"]["M2"]:FireServer(true,false)
                    end
                end
                
                char["client_character_controller"]["M1"]:FireServer(true,false)
            elseif char:FindFirstChild("IFrame") and t.instakill and canInsta then
                workspace.FallenPartsDestroyHeight = -5000
                setAligns(false)
                
                local oldCf = char.HumanoidRootPart.CFrame
                local lastTick = tick()
                
                repeat task.wait()
                    char.HumanoidRootPart.CFrame = CFrame.new(0,-550, 0)
                until tick() - lastTick >= 3 or not checkAlive(enemy) or enemy == nil
                
                char.HumanoidRootPart.CFrame = oldCf
                setAligns(true)
            end
        else
            enemy = getEnemy(tab)
        end
    end
    isAutoFarming = false
end


-- Script


-- AutoFarm Tab

-- Raids Section

createElement(Tabs.AutoFarm, "Paragraph", "Aligned Paragraph", {Title = "Raids Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local autoraidToggle = createElement(Tabs.AutoFarm, "Toggle", "autoraidToggle", {Title = "Auto Raid", Default = t.autoraid}, function(self)
    t.autoraid = self.Option.Value
    autofarm("autoraid", true, {})
end)

local instakillToggle = createElement(Tabs.AutoFarm, "Toggle", "instakillToggle", {Title = "Insta Kill", Default = t.instakill}, function(self)
    t.instakill = self.Option.Value
end)

holdskillDropdown = createElement(Tabs.AutoFarm, "Dropdown", "holdskillDropdown", {Title = "Skill To Hold", Values = {"R","Z","X","C","V"}, Default = t.holdskill}, function(self, val)
    t.holdskill = val
end)

createElement(Tabs.AutoFarm, "Toggle", "autochestToggle", {Title = "Auto Open Chest", Default = t.autochest}, function(self)
    t.autochest = self.Option.Value
end)

createElement(Tabs.AutoFarm, "Toggle", "autosellToggle", {Title = "Auto Sell", Default = t.autosell}, function(self)
    t.autosell = self.Option.Value
end)


-- Main Game Section

createElement(Tabs.AutoFarm, "Paragraph", "Aligned Paragraph", {Title = "Main Game Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local autofarmToggle = createElement(Tabs.AutoFarm, "Toggle", "autofarmToggle", {Title = "Auto Farm Selected", Default = t.autofarm}, function(self)
    t.autofarm = self.Option.Value
    autofarm("autofarm", false, {Selected = true})
end)

local selectDropdown = createElement(Tabs.AutoFarm, "Dropdown", "selectDropdown", {Title = "Target", Values = getEnemy({All = true}), Default = t.selectedTarget, Searchable = true}, function(self, val)
    t.selectedTarget = val
end)

createElement(Tabs.AutoFarm, "Button", nil, {Title = "Update Target List", Callback = function()
    selectDropdown:SetValues(getEnemy({All = true}))
end})
