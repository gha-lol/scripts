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

local noSave = {Identifier = 0, selectedBus = "1", selectedTpNpc = "Chumbo", cds = {}, autoarrow = false, doingstory = false, storyTarget = ""}
local t = {
    autofarm = false,
    autoraid = false,
    autosell = false,
    autochest = false,
    autopoints = false,
    autoshop = false,
    autostory = false,
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
        Mythical = false,
        Secret = false
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
      Mythical = false,
      Secret = false
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
local allAccessorys = get_data:InvokeServer("accessory")
local allQuests = get_data:InvokeServer("quest")
local Service = game:GetService("HttpService")
local Options = Library.Options
local UIElements = {}


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
    elseif elementType == "Input" then
        element = tab:CreateInput(id, data)
	end

    if not element then
        warn("Failed to create element:", elementType, id)
        return nil
    end

    -- Salva global
    if id and elementType ~= "Paragraph" then
        UIElements[id] = element
    end

    -- Auto OnChanged
    if callback and element.OnChanged then
        element:OnChanged(function(...)
            callback(Options[id], ...)
        end)
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

function isMainGame()
    local returner = false

    if game.PlaceId == 14890802310 then
        returner = true
    end

    return returner
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

local isAutoChest = false
function autoChest()
    if isAutoChest or not isMainGame() then return end
    isAutoChest = true

    while t.autochest do task.wait(5)
        openChests(false)
    end

    isAutoChest = false
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

local isAutoSell = false
function autoSell(bool)
    if bool and isAutoSell then return end

    local function sell()
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

    if bool and isMainGame()  then
        isAutoSell = true

        while t.autosell do task.wait(5)
            sell()
        end

        isAutoSell = false
    else
        sell()
    end
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
    local distance = 9999999

    if a.Story then
        pcall(function()
            for i,v in pairs(workspace.Effects:GetChildren()) do
                if v.Name == "questbrick" and string.find(v["Quest Marker"].Image.Title.Text, noSave.storyTarget) then
                    char:PivotTo(v:GetPivot())
                end
            end
        end)
    end
    
    if a.All then
        local aa = {}
        
        for i,v in pairs(workspace.Live:GetChildren()) do
            if not table.find(aa, v:GetAttribute("DisplayName")) and not string.find(v.Name, "entity clone") and not game.Players:FindFirstChild(v.Name) and v.Name ~= "Server" then
                table.insert(aa, v:GetAttribute("DisplayName"))
            end
        end
        
        returner = aa
    else
        for i,v in pairs(workspace.Live:GetChildren()) do
            if a.Selected then
                if a.Story then
                    if v:GetAttribute("DisplayName") == noSave.storyTarget and checkAlive(v) and plr:DistanceFromCharacter(v.HumanoidRootPart.Position) < distance then
                        returner = v
                        distance = plr:DistanceFromCharacter(v.HumanoidRootPart.Position)
                    end
                else
                    if v:GetAttribute("DisplayName") == t.selectedTarget and checkAlive(v) and plr:DistanceFromCharacter(v.HumanoidRootPart.Position) < distance then
                        returner = v
                        distance = plr:DistanceFromCharacter(v.HumanoidRootPart.Position)
                    end
                end
            else
                if checkAlive(v) and not game.Players:FindFirstChild(v.Name) and v.Name ~= "Server" and plr:DistanceFromCharacter(v.HumanoidRootPart.Position) < distance then
                    returner = v
                    distance = plr:DistanceFromCharacter(v.HumanoidRootPart.Position)
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

function getNetherStar()
    local returner = false

    for i,v in pairs(workspace.Live:GetChildren()) do
        if table.find({"Netherstar1","Netherstar2","Netherstar3"}, v.Name) then
            returner = v
            break
        end
    end

    return returner
end

local allAwakenings = {}
for _,v in pairs(game:GetService("ReplicatedStorage").assets.effects.stands:GetChildren()) do
    for k,l in pairs(v:GetChildren()) do
        if l.Name:lower():match("awakening") then
            table.insert(allAwakenings, l)
        end
    end
end

function checkDescendant(part)
    local returner = false

    for i,v in pairs(allAwakenings) do
        if part:IsDescendantOf(v) then
            returner = true
            break
        end
    end

    return returner
end

local isAutoFarming = false
function autofarm(bool, ignoreName, tab)
    if t[bool] or noSave[bool] then
        if bool == "autoraid" and isMainGame() then setAligns(false) return end
        task.wait(.5)
        if bool == "autofarm" then
            t.autostory = false
            noSave.doingstory = false

            UIElements.autostoryToggle:SetValue(false)
        elseif bool == "autoraid" then
            t.autofarm = false
            noSave.doingstory = false

            UIElements.autofarmToggle:SetValue(false)
        elseif bool == "doingstory" then
            t.autofarm = false

            UIElements.autofarmToggle:SetValue(false)
        end
        task.wait(.5)
        setAligns(true)
    else
        if not isAutoFarming then
            setAligns(false)
        end
    end

    if isAutoFarming then return end
    isAutoFarming = true

    local enemy
    local canInsta = false
    local isBoss = false
    local lastHealth
    local repeating
    
    local posY = -t.distance
    local cfAng = 90

    local function checkToggles(tog)
        local returner = false
        if tog == "autofarm" and string.find(enemy.Name or "ashdashdajs", t.selectedTarget) and t.autofarm then
            returner = true
        elseif tog == "doingstory" and string.find(enemy.Name or "ashdashdajs", noSave.storyTarget) and noSave.doingstory then
            returner = true
        end
        return returner
    end
  
    while (t[bool] or noSave[bool]) do task.wait()
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
            queueonteleport('function loadScript(skip) if  _G.tickLoads and not skip then if tick() - _G.tickLoads < 10 then return end else _G.tickLoads = tick() end local s,e = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/bltest.lua",true))() end) if not s then task.wait(1) loadScript(true) end end loadScript()')
            
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
        
        if enemy and checkAlive(enemy) and (ignoreName or checkToggles(bool)) then
            if plr:DistanceFromCharacter(enemy.HumanoidRootPart.Position) > 500 then
                char.HumanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,-8,0))
            end
            
            if enemy.Name:match("Heaven Ascension DIO") then
                local star = getNetherStar()
                if not canInsta and star then
                    part.CFrame = CFrame.new(star.HumanoidRootPart.Position + Vector3.new(0,posY,0)) * CFrame.Angles(math.rad(cfAng),0,0)
                else
                    part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,posY,0)) * CFrame.Angles(math.rad(cfAng),0,0)
                end
            else
                part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,posY,0)) * CFrame.Angles(math.rad(cfAng),0,0)
            end

            if enemy:GetAttribute("Miniboss") and t.instakill then
                isBoss = true
                if lastHealth == nil then lastHealth = enemy.Humanoid.Health end
                
                if isMainGame() then
                    canInsta = true
                elseif enemy.Humanoid.Health - lastHealth > 25 and not canInsta and not repeating then
                    repeating = true

                    local con = game:GetService("ReplicatedStorage").requests.general.vfx.OnClientEvent:Connect(function(_,tab)
                        --[[if tab.WeldPart and tab.WeldPart:IsDescendantOf(enemy) then
                            for i,v in pairs(tab) do
                                if i == "Part" or i == "WeldPart" then
                                    print"------------"
                                    print(i,v)
                                    print("Parent: ",v.Parent.Name)
                                    print("Parents Parent: ",v.Parent.Parent.Name)
                                    print"------------"
                                end
                            end
                        end]]
                        if tab.Part and (checkDescendant(tab.Part) or tab.Part.Parent.Name == "intro 2") and tab.WeldPart.Parent == enemy then
                            task.wait(.1)
                            canInsta = true
                            con:Disconnect()
                        end

                    end)

                    if enemy.Humanoid.Health < lastHealth then
                        lastHealth = enemy.Humanoid.Health
                    end
                end
            else
                repeating = false
                canInsta = false
                isBoss = false
                lastHealth = nil
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
    setAligns(false)
    isAutoFarming = false
end

local isAutoStory = false
function autoStory()
    if isAutoStory or not isMainGame() then return end
    isAutoStory = true

    local chat = {}
    local con = game.ReplicatedStorage.requests.character.dialogue.OnClientEvent:Connect(function(...)
        chat = {...}
    end)

    while t.autostory do task.wait()
        local quests = Service:JSONDecode(plrData.CurrentQuests.Value)

        for _,quest in pairs(quests) do
            if quest.Name:match("Storyline") then
                
                if not plrData.TrackedQuest.Value:match("Storyline") then
                    game.ReplicatedStorage.requests.character.trackquest:FireServer(quest.Name)
                    repeat task.wait() until plrData.TrackedQuest.Value:match("Storyline")
                end
            
                if quest.Talk then
                    for i,v in pairs(quest.Talk) do
                        if not v then
                            local npc = getNpc({Name = i})

                            if npc then
                                char:PivotTo(npc:GetPivot())
                                repeat task.wait() char:PivotTo(npc:GetPivot()) until not plr.GameplayPaused

                                local llchat = chat
                                local lastTickk = tick()
                                repeat
                                    game.ReplicatedStorage.requests.character.dialogue:FireServer(npc, 1)
                                    task.wait(.5) 
                                until chat ~= llchat and npc:IsDescendantOf(workspace) or tick() - lastTickk > 10 and npc:IsDescendantOf(workspace)

                                local ended = false
                                local lastRepeatTick = tick()
                                repeat
                                    local lastChat = chat

                                    if chat[1] == npc then
                                        if #chat[2].Choices == 0 or not npc:IsDescendantOf(workspace) then
                                            ended = true
                                        else
                                            game.ReplicatedStorage.requests.character.dialogue:FireServer(npc, chat[2].Choices[1])
                                        end
                                    end

                                    local lastTick = tick()
                                    repeat task.wait() until tick() - lastTick >= 1 or chat ~= lastChat or ended
                                until ended or tick() - lastRepeatTick > 6
                            end
                        end
                    end
                elseif quest.Kills then
                    noSave.doingstory = true
                    noSave.storyTarget = "asdjas"
                    
                    spawn(function()
                        autofarm("doingstory", false, {Selected = true, Story = true})
                        setAligns(true)
                    end)

                    local keepLoop = true
                    repeat task.wait(.1)
                        local found = false

                        for i,v in pairs(Service:JSONDecode(plrData.CurrentQuests.Value)) do
                            if v.Name:match(quest.Name) then
                                found = true
                                local targ = ""

                                for enemy,killed in pairs(v.Kills) do
                                    if allQuests[v.Name].Kills[enemy] > killed then
                                        targ = enemy
                                    end
                                end

                                noSave.storyTarget = targ
                            end
                        end

                        if not found then
                            keepLoop = false
                            noSave.doingstory = false
                        end
                    until not keepLoop --and not isAutoFarming
                    task.wait(.2)
                    setAligns(false)
                end

            end
        end
    end

    noSave.doingstory = false
    isAutoStory = false
    con:Disconnect()
end


-- Script


-- AutoFarm Tab

-- Raids Section

createElement(Tabs.AutoFarm, "Paragraph", "Aligned Paragraph", {Title = "Raids Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.AutoFarm, "Toggle", "autoraidToggle", {Title = "Auto Raid", Default = t.autoraid}, function(self)
    t.autoraid = self.Value
    autofarm("autoraid", true, {})
end)

createElement(Tabs.AutoFarm, "Toggle", "instakillToggle", {Title = "Insta Kill", Default = t.instakill}, function(self)
    t.instakill = self.Value
end)

createElement(Tabs.AutoFarm, "Dropdown", "holdskillDropdown", {Title = "Skill To Hold", Values = {"R","Z","X","C","V"}, Default = t.holdskill}, function(self, val)
    t.holdskill = val
end)


-- Auto Story Section

createElement(Tabs.AutoFarm, "Paragraph", "Aligned Paragraph", {Title = "Story Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.AutoFarm, "Toggle", "autostoryToggle", {Title = "Auto Story", Default = t.autostory}, function(self)
    t.autostory = self.Value
    autoStory()
end)


-- Main Game Section

createElement(Tabs.AutoFarm, "Paragraph", "Aligned Paragraph", {Title = "Main Game Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.AutoFarm, "Toggle", "autofarmToggle", {Title = "Auto Farm Selected", Default = t.autofarm}, function(self)
    t.autofarm = self.Value
    autofarm("autofarm", false, {Selected = true})
end)

createElement(Tabs.AutoFarm, "Dropdown", "selectDropdown", {Title = "Target", Values = getEnemy({All = true}), Default = t.selectedTarget, Searchable = true}, function(self, val)
    t.selectedTarget = val
end)

createElement(Tabs.AutoFarm, "Button", nil, {Title = "Update Target List", Callback = function()
    UIElements.selectDropdown:SetValues(getEnemy({All = true}))
end})



-- Automation Tab

-- Auto Open Chest Section

createElement(Tabs.Automation, "Paragraph", "Aligned Paragraph", {Title = "Auto Open Chest Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Automation, "Toggle", "autochestToggle", {Title = "Auto Open Chest", Default = t.autochest}, function(self)
    t.autochest = self.Value
    autoChest()
end)

-- Auto Sell Section

createElement(Tabs.Automation, "Paragraph", "Aligned Paragraph", {Title = "Auto Sell Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Automation, "Toggle", "autosellToggle", {Title = "Auto Sell", Default = t.autosell}, function(self)
    t.autosell = self.Value
    autoSell(true)
end)

local allSellRarities, activesRarities = {}, {} for i,v in pairs(t.selectedRarity) do table.insert(allSellRarities, i) if v == true then table.insert(activesRarities, i) end end
createElement(Tabs.Automation, "Dropdown", "autosellDrop", {Title = "Rarity To Sell", Values = allSellRarities, Multi = true, Default = activesRarities}, function(_,Value)
    for i,v in pairs(t.selectedRarity) do
        t.selectedRarity[i] = Value[i] or false
    end
end)

createElement(Tabs.Automation, "Toggle", "keepPvEToggle", {Title = "Keep High PvEDmg Accessories", Default = t.keepPvEDmg}, function(self)
    t.keepPvEDmg = self.Value
end)

local allKeepRarities, activesKeepAcc = {}, {} for i,v in pairs(t.keepPvEAccessory) do table.insert(allKeepRarities, i) if v == true then table.insert(activesKeepAcc, i) end end
createElement(Tabs.Automation, "Dropdown", "keeppveaccessoryDrop", {Title = "PvEDmg Accessory To Keep", Values = allKeepRarities, Multi = true, Default = activesKeepAcc}, function(_,Value)
    for i,v in pairs(t.keepPvEAccessory) do
        t.keepPvEAccessory[i] = Value[i] or false
    end
end)

-- Auto Shop Section

createElement(Tabs.Automation, "Paragraph", "Aligned Paragraph", {Title = "Auto Shop Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Automation, "Toggle", "autoshopToggle", {Title = "Auto Shop", Default = t.autoshop}, function(self)
    t.autoshop = self.Value
    autoShop()
end)

createElement(Tabs.Automation, "Toggle", "autocashshopToggle", {Title = "Buy From Cash Shop", Default = t.shopConfig.buyCashShop}, function(self)
    t.shopConfig.buyCashShop = self.Value
end)

local activeShopItems = {} for i,v in pairs(t.shopConfig.items) do table.insert(activeShopItems, v) end
createElement(Tabs.Automation, "Dropdown", "cashshopDrop", {Title = "Cash Shop Items To Buy", Values = {"Stand Conjuration Essence","Stat Point Essence"}, Multi = true, Default = activeShopItems}, function(self, val)
    local tab = {}
    for i,_ in pairs(val) do table.insert(tab, i) end
    t.shopConfig.items = tab
end)

local allShops = {} for i,v in pairs(Service:JSONDecode(plrData.RaidTokens.Value)) do table.insert(allShops, i) end
createElement(Tabs.Automation, "Dropdown", "autoshopDrop", {Title = "Raid Shop To Buy", Values = allShops, Multi = false, Default = t.selectedShop}, function(self, Value)
    t.selectedShop = Value
end)

-- Auto Arrow Section

createElement(Tabs.Automation, "Paragraph", "Aligned Paragraph", {Title = "Auto Arrow Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Automation, "Toggle", "autoarrowToggle", {Title = "Auto Arrow", Default = noSave.autoarrow}, function(self)
    noSave.autoarrow = self.Value
    
    if isMainGame() then
        local e = autoArrow()
        if not e then
            noSave.autoarrow = false
            UIElements["autoarrowToggle"]:SetValue(false)
        end
    end
end)

createElement(Tabs.Automation, "Toggle", "stopshinyToggle", {Title = "Stop on Shiny", Default = t.arrowConfig.shiny}, function(self)
    t.arrowConfig.shiny = self.Value
end)

local skinignore = {} for i,v in pairs(t.arrowConfig.ignoreSkinRarity) do if v and (i == "Common" or i == "Rare") then table.insert(skinignore, i) end end
createElement(Tabs.Automation, "Dropdown", "ignoreSkinRarityDown", {Title = "Ignore Skin Rarities", Values = {"Common", "Rare"}, Multi = true, Default = skinignore}, function(self, Value)
    for i,v in pairs(t.arrowConfig.ignoreSkinRarity) do
        t.arrowConfig.ignoreSkinRarity[i] = Value[i] or false
    end
    t.arrowConfig.ignoreSkinRarity["Legendary"] = false
    t.arrowConfig.ignoreSkinRarity["Secret"] = false
end)

-- Auto Points Section

createElement(Tabs.Automation, "Paragraph", "Aligned Paragraph", {Title = "Auto Points Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Automation, "Toggle", "autopointsToggle", {Title = "Auto Points", Default = t.autopoints}, function(self)
    t.autopoints = self.Value
    autoPoints()
end)

for i,v in pairs(t.selectedStats) do
    createElement(Tabs.Automation, "Input", "InputStat"..tostring(i), {Title = i, Default = tostring(v), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(value)
        t.selectedStats[i] = tonumber(value)
    end})
end


-- Teleport Tab

-- Npc Section

createElement(Tabs.Teleport, "Paragraph", "Aligned Paragraph", {Title = "Npcs Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Teleport, "Dropdown", "npcTpDown", {Title = "Npc", Values = getNpc({All=true}), Searchable = true, Multi = false, Default = noSave.selectedTpNpc}, function(_, val)
    noSave.selectedTpNpc = val
end)

createElement(Tabs.Teleport, "Button", nil, {Title = "Teleport to Npc", Description = "", Callback = function()
    char:PivotTo(getNpc({Name=noSave.selectedTpNpc}):GetPivot())
end})

-- Bus Section

createElement(Tabs.Teleport, "Paragraph", "Aligned Paragraph", {Title = "Bus Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local busTable = {} for i=1,19 do table.insert(busTable, tostring(i)) end
createElement(Tabs.Teleport, "Dropdown", "busDown", {Title = "Bus Stop", Values = busTable, Searchable = false, Multi = false, Default = "1"}, function(_,Value)
    noSave.selectedBus = Value
end)

createElement(Tabs.Teleport, "Button", nil, {Title = "Teleport to Bus Stop", Description = "", Callback = function()
    char:PivotTo(workspace.Map["Bus Stops"][noSave.selectedBus]:GetPivot())
end})


-- Config Tab

-- Global Section

createElement(Tabs.Config, "Paragraph", "Aligned Paragraph", {Title = "Global Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Config, "Input", "InputDistance", {Title = "Distance", Default = tostring(t.distance), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(value)
    t.distance = tonumber(value)
end})

createElement(Tabs.Config, "Dropdown", "selectTopDown", {Title = "Farm Position", Values = {"Top", "Down"}, Multi = false, Default = t.position}, function(_, val)
    t.position = val
end)

createElement(Tabs.Config, "Toggle", "noVfx", {Title = "No VFX", Default = t.noVfx}, function(self)
    t.noVfx = self.Value
    changeVfx()
end)

createElement(Tabs.Config, "Toggle", "blackscreen", {Title = "Black Screen", Default = t.blackscreen}, function(self)
    t.blackscreen = self.Value
    blackScreen()
end)


-- Skills Section

createElement(Tabs.Config, "Paragraph", "Aligned Paragraph", {Title = "Skills Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local allKeyss, activeKeyss  = {}, {} for i,v in pairs(t.keys) do table.insert(allKeyss, i) if v == true then table.insert(activeKeyss, i) end end
createElement(Tabs.Config, "Dropdown", "autoskillKeys", {Title = "Skills To Use", Values = allKeyss, Multi = true, Default = activeKeyss}, function(_,Value)
    for i,v in pairs(t.keys) do
        t.keys[i] = Value[i] or false
    end
end)


-- File

createElement(Tabs.File, "Button", nil, {Title = "Save Config", Description = "", Callback = saveSettings})

createElement(Tabs.File, "Button", nil, {Title = "Print Save Table", Description = "", Callback = function()
    local function printTable(i,v, spc)
        local pp = v
        local isTab = false
        local spac = spc .. "  "

        if typeof(v) == "table" then pp = "" isTab = true end
        print(spac .. i .. ": " .. tostring(pp))

        if isTab then
            for k,l in pairs(v) do
                printTable(k,l,spac)
            end
        end
    end

    for i,v in pairs(t) do
        printTable(i,v, "")
    end
end})

-- Auto Arrow Config

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
  
    createElement(Tabs.AutoArrowConfig, "Dropdown", "selectadssa"..v, {Title = v, Values = tabb, Multi = false, Default = "Any"}, function(_,Value)
        noSave[v] = Value

        if v == "Trait" then
            pcall(function()
                descTrait:SetValue(getData({Send = "trait", Desc = Value}))
            end)
        end
    end)

    if v == "Trait" then
        descTrait = createElement(Tabs.AutoArrowConfig, "Paragraph", "Aligned Paragraph", {Title = "Description:", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})
    end
end

createElement(Tabs.AutoArrowConfig, "Button", nil, {Title = "Add Stand", Description = "", Callback = function()
    table.insert(t.arrowConfig.stands, {Name = noSave.Stand, Trait = noSave.Trait, Strength = noSave.Strength, Specialty = noSave.Specialty, Speed = noSave.Speed, Identifier = math.random(1,999)})
end})

createElement(Tabs.AutoArrowConfig, "Button", nil, {Title = "Print All Stands", Description = "", Callback = function()
    for i,v in pairs(t.arrowConfig.stands) do
        print("---------")
        print("Stand "..tostring(i))
        for k,l in pairs(v) do
            print(k,l)
        end
    end
end})

createElement(Tabs.AutoArrowConfig, "Input", "InputIndenadsdsa", {Title = "Input Identifier", Default = tostring(0), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(value)
    noSave.Identifier = tonumber(value)
end})

createElement(Tabs.AutoArrowConfig, "Button", nil, {Title = "Delete Stand", Description = "", Callback = function()
    for i,v in pairs(t.arrowConfig.stands) do
        if v.Identifier == noSave.Identifier then
            table.remove(t.arrowConfig.stands, i)
            break
        end
    end
end})


-- Activating Toggles Etc
task.wait(.1)
UIElements.autofarmToggle:SetValue(t.autofarm)
UIElements.autoraidToggle:SetValue(t.autoraid)
UIElements.autochestToggle:SetValue(t.autochest)
UIElements.autosellToggle:SetValue(t.autosell)
UIElements.autoshopToggle:SetValue(t.autoshop)
UIElements.noVfx:SetValue(t.noVfx)
UIElements.blackscreen:SetValue(t.blackscreen)
