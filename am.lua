local plr = game.Players.LocalPlayer
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/libHawk.lua", true))()
local win = lib:Window({ScriptName = "A.M.", DestroyIfExists = true, Theme = "Dark"})
win:Minimize({visibility = true, OpenButton = true, Callback = function() end})

if game.PlaceId == 6284881984 then
  
    -- TAB MISSIONS
    
    local tab1 = win:Tab("Missions")
    
    local mapsTable = {}
    local missionsTable = {}
    local missionDropdown
    local selectedMission
    
    for i,v in pairs(game.ReplicatedStorage.Maps:GetChildren()) do
        table.insert(mapsTable, v.Name)
    end
    
    tab1:Dropdown("Maps", mapsTable, function(map)
        table.clear(missionsTable)
        
        for i,v in pairs(game.ReplicatedStorage.Maps[map]:GetChildren()) do
            if v.Name ~= "Req" then
                table.insert(missionsTable, v.Name)
            end
        end
        
        missionDropdown:Refresh(missionsTable, false)
    end)
    
    missionDropdown = tab1:Dropdown("Mission", missionsTable, function(mission)
        selectedMission = mission
    end)
    
    tab1:Button("Teleport", function()
        game.ReplicatedStorage.Remotes.CreateRoom:InvokeServer(selectedMission, "asjkd")
        task.wait(.5)
        game.ReplicatedStorage.Remotes.BeginRoom:FireServer()
    end)
    
    -- TAB AUTO ORBS
    
    local tab2 = win:Tab("Auto Orbs")
    
    tab2:Toggle("Auto Orbs", "", function(bool)
        _G.autoOrbs = bool
        
        local blacklist = {}
        
        spawn(function()
            while _G.autoOrbs do task.wait(.1)
                for i,v in pairs(workspace.Orbs:GetChildren()) do
                    if v:FindFirstChildOfClass("TouchTransmitter") and not table.find(blacklist, v) then
                        firetouchinterest(plr.Character.HumanoidRootPart, v, 0)
                        table.insert(blacklist, v)
                    end
                end
            end
        end)
    end)
    
    
    -- TAB AUTO FEED
    
    local selectedUnit = ""
    local unitsTable = {}
    local infoLevel = "1"
    local infoSummoning = "false"
    local unitsDropdown
    local toggleUnit
    local infoLabelSummoning
    local infoLabelLevel
    
    function getUnits()
        table.clear(unitsTable)
      
        local unitsTab = game.ReplicatedStorage.Remotes.CharacterSelection:InvokeServer()
        
        for id,v in pairs(unitsTab) do
            if not table.find(unitsTable, v.Name) then
                table.insert(unitsTable, v.Name)
            end
        end
    end
    
    function getSelectedUnit()
        local returner = {}
        
        local unitsTab = game.ReplicatedStorage.Remotes.CharacterSelection:InvokeServer()
        
        for id,v in pairs(unitsTab) do
            if v.Name == selectedUnit then
                returner["id"] = id
                returner["lvl"] = v.Level
                returner["xp"] = v.Experience
                break
            end
        end
        
        return returner
    end
    
    function getFodders()
        local returner = {}
        
        local unitsTab = game.ReplicatedStorage.Remotes.CharacterSelection:InvokeServer()
        
        for id,v in pairs(unitsTab) do
            if game.ReplicatedStorage.Characters[v.Name].Rarity.Value == "Fodder" and not v.Favorite then
                returner[id] = true
            end
        end
        
        return returner
    end
    
    function updateInfo()
        infoLabelLevel:UpdateLabel("Character Level: " .. infoLevel)
        infoLabelSummoning:UpdateLabel("Is Summoning: " .. infoSummoning)
    end
    
    getUnits()
    
    local tab3 = win:Tab("Auto Feed")
    
    tab3:TextBox("Search Unit", "Name Here", function(unitt)
        getUnits()
      
        for i,v in pairs(unitsTable) do
            if not string.find(v:lower(), unitt:lower()) then
                table.remove(unitsTable, i)
            end
        end
        
        unitsDropdown:Refresh(unitsTable, false)
    end)
    
    unitsDropdown = tab3:Dropdown("Units", unitsTable, function(unit)
        selectedUnit = unit
    end)
    
    toggleUnit = tab3:Toggle("Auto Feed", "", function(bool)
        _G.autofeed = bool
        
        while _G.autofeed do task.wait()
            local info = getSelectedUnit()
            
            infoLevel = tostring(info.lvl)
            updateInfo()
            
            if info then
                local summonsNecessary = math.ceil((((info.lvl * 5) - info.xp) / 10) / 10)
                
                if summonsNecessary >= 1 and info.lvl < 100 then
                    local successSummons = 0
                    
                    infoSummoning = tostring("true")
                    updateInfo()
                    
                    repeat task.wait(.25)
                        
                        local results = game.ReplicatedStorage.Remotes["Rollx10"]:InvokeServer(true)
                        if results ~= "SLOW DOWN" then successSummons += 1 end
                        
                    until successSummons == summonsNecessary
                    
                    game.ReplicatedStorage.Remotes.FeedCharacter:InvokeServer(getFodders(), info.id)
                    
                    infoSummoning = tostring("false")
                    updateInfo()
                else
                    infoLevel = tostring(info.lvl)
                    updateInfo()
                  
                    _G.autofeed = false
                    toggleUnit:UpdateToggle(false)
                end
            end
        end
    end)
    
    local infoSection = tab3:Section("Auto Feed Info")
    
    infoLabelLevel = infoSection:Label("Character Level: " .. infoLevel)
    infoLabelSummoning = infoSection:Label("Is Summoning: " .. infoSummoning)
    
else
    
    _G.e = true
    _G.dis = 6.5
    
    local mob
    
    function getMob()
        local returner
        
        for i,v in pairs(workspace.Living:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and not game.Players:FindFirstChild(v.Name) then
                returner = v
                break
            end
        end
        
        return returner
    end
    
    function Remote(tab)
        pcall(function()
            game.ReplicatedStorage.Remotes.Input:FireServer({unpack(tab)})
        end)
    end
    
    function createForce(v)
        --[[local bv = Instance.new("BodyVelocity")
        bv.Name = "fno"
        bv.MaxForce = Vector3.new(1/0,1/0,1/0)
        bv.P = 1/0
        bv.Velocity = Vector3.new(30,30,30)
        bv.Parent = v.HumanoidRootPart]]
        local e = Instance.new("NumberValue",v.HumanoidRootPart)
        e.Name = "fno"

        v.HumanoidRootPart.CanCollide = false
        v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
        v.HumanoidRootPart.Transparency = 1
        --v.Humanoid:ChangeState(11)
        --v.Humanoid:ChangeState(14)
        if v.Humanoid:FindFirstChild("Animator") then
            v.Humanoid.Animator:Destroy()
        end
    end
    
    while _G.e do task.wait()
        if mob and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,_G.dis,0)
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
    
                if mob:FindFirstChild("Head") then mob.Head:Destroy() end
                if not mob.HumanoidRootPart:FindFirstChild("fno") then createForce(mob) end
              
                mob.Humanoid.Health = 0
                game:GetService("Workspace").FallenPartsDestroyHeight = 0 / 0
                --mob.Humanoid:ChangeState(11)
                --mob.Humanoid:ChangeState(14)
                sethiddenproperty(plr, "SimulationRadius", math.huge)
                
                Remote({"Light"})
                for i=1,4 do
                    Remote({"Skill", tostring(i)})
                end
            end)
        else
            mob = getMob()
        end
    end
    
end
