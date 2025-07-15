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
    local infoTrait = "None"
    local wantedTrait = {}
    local unitsDropdown
    local toggleUnit
    local toggleTrait
    local infoLabelSummoning
    local infoLabelLevel
    local infoLabelTrait
    local selectedTraitsLabel
    
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
                
                if v.Trait then
                    returner["trait"] = v.Trait
                else
                    returner["trait"] = "None"
                end
                
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
        infoLabelTrait:UpdateLabel("Trait: " .. infoTrait)
    end
    
    function updateTraitSelected()
        local texto = ""
        
        for i,v in pairs(wantedTrait) do
            texto = texto .. v .. "  "
        end
        
        selectedTraitsLabel:UpdateLabel(texto)
    end
    
    function getPossibleTraits()
        local returner = {}
        
        local traits = require(game.ReplicatedStorage.Modules.PossibleTraits)
        
        for i,v in pairs(traits.traits) do
            table.insert(returner, tostring(i))
        end
        
        return returner
    end
    
    getUnits()
    
    local tab3 = win:Tab("Auto Feed")
    
    tab3:TextBox("Search Unit", "Name Here", function(unitt)
        getUnits()
        
        local outrTable = {}
      
        for i,v in pairs(unitsTable) do
            if v:find(unitt) then
                table.insert(outrTable, v)
            end
        end
        
        unitsDropdown:Refresh(outrTable, false)
    end)
    
    unitsDropdown = tab3:Dropdown("Units", unitsTable, function(unit)
        selectedUnit = unit
    end)
    
    tab3:Dropdown("Traits", getPossibleTraits(), function(unit)
        if table.find(wantedTrait, unit) then
            for i,v in pairs(wantedTrait) do
                if v == unit then
                    table.remove(wantedTrait,i)
                end
            end
        else
            table.insert(wantedTrait, unit)
        end
        updateTraitSelected()
    end)
    
    selectedTraitsLabel = tab3:Label("")
    updateTraitSelected()
    
    toggleTrait = tab3:Toggle("Auto Trait", "", function(bool)
        _G.autotrait = bool
        
        while _G.autotrait do task.wait(.1)
            local info = getSelectedUnit()
            
            if info then
              
                infoTrait = info.trait
                updateInfo()
                
                if not table.find(wantedTrait, info.trait) then
                    local pegou = false
                  
                    repeat task.wait(0.4)
                        
                        local trait = game.ReplicatedStorage.Remotes.RollTrait:InvokeServer(info.id)
                        
                        if table.find(wantedTrait, trait) then
                            pegou = true
                        end

                        infoTrait = trait
                        updateInfo()
                        
                    until pegou == true or _G.autotrait == false or plr.Data.Crystals.Value == 0
                else
                    _G.autotrait = false
                end
            end
        end
    end)
    
    toggleUnit = tab3:Toggle("Auto Feed", "", function(bool)
        _G.autofeed = bool
        
        while _G.autofeed do task.wait()
            local info = getSelectedUnit()
            
            if info then
              
                infoLevel = tostring(info.lvl)
                updateInfo()
              
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
    
    local infoSection = tab3:Section("Info")
    
    infoLabelLevel = infoSection:Label("Character Level: " .. infoLevel)
    infoLabelSummoning = infoSection:Label("Is Summoning: " .. infoSummoning)
    infoLabelTrait = infoSection:Label("Trait: " .. infoTrait)
    
else
  
  
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

        --v.HumanoidRootPart.CanCollide = false
        --v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
        v.HumanoidRootPart.Transparency = 1
        --v.Humanoid:ChangeState(11)
        --v.Humanoid:ChangeState(14)
        if v.Humanoid:FindFirstChild("Animator") then
            --v.Humanoid.Animator:Destroy()
        end
    end
  
    function autofarm()
        local mob
        local statueAttack = false
        
        while _G.e do task.wait()
            pcall(function()
                if workspace.FX:FindFirstChild("WaveSilo") then
                    task.wait(2)
                    plr.Character.HumanoidRootPart.CFrame = workspace.FX.WaveSilo.CFrame
                end
    
                if workspace.FX:FindFirstChild("CamGod") then
                    repeat task.wait() until workspace.FX:FindFirstChild("CamGod") == nil
                    task.wait(_G.sogwait)
                    mob = getMob()
                end
                
                if mob.Name == "Statue Of God" and statueAttack == false then
                    repeat task.wait()
                      
                        pcall(function()
                            if mob:FindFirstChild("Highlight") then
                                task.wait(_G.sogwait)
                                statueAttack = true
                            end
                        end)
                      
                    until statueAttack == true or _G.e == false or mob == nil
                end
            end)
            if mob and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                if mob.Name == "Statue Of God" and statueAttack == false then continue end
                pcall(function()
                    plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,_G.dis,0)
                    plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
        
                    --if mob:FindFirstChild("Head") then mob.Head:Destroy() end
                    --if not mob.HumanoidRootPart:FindFirstChild("fno") then createForce(mob) end
                  
                    mob.Humanoid.Health = 0
                    --game:GetService("Workspace").FallenPartsDestroyHeight = 0 / 0
                    --mob.Humanoid:ChangeState(11)
                    --mob.Humanoid:ChangeState(14)
                    sethiddenproperty(plr, "SimulationRadius", math.huge)
    
                    if _G.useM1 then
                        Remote({"Light"})
                    end

                    if _G.delaySkill > 0 then
                        delay(_G.delaySkill, function()
                            for i,v in pairs(_G.skillsToUseee) do
                                Remote({"Skill", tostring(v)})
                            end
                        end)
                    else
                        for i,v in pairs(_G.skillsToUseee) do
                            Remote({"Skill", tostring(v)})
                        end
                    end
                    Remote({"Skill", "TeamAssist"})
                end)
            else
                statueAttack = false
                mob = getMob()
            end
        end
    end
  
    _G.e = false
    _G.dis = 6.5
    _G.sogwait = 2
    _G.skillsToUseee = {}
    _G.useM1 = true
    _G.delaySkill = 0
    
    function addRemoveSkill(skill)
        if table.find(_G.skillsToUseee, skill) then
          
            for i,v in pairs(_G.skillsToUseee) do
                if v == skill then
                    table.remove(_G.skillsToUseee, i)
                end
            end
            
        else
            
            table.insert(_G.skillsToUseee, skill)
            
        end
    end
    
    local tab1 = win:Tab("Config")
    
    tab1:Toggle("Farm", "", function(bool)
        _G.e = bool
        
        autofarm()
    end)
    
    tab1:TextBox("Distance", "6.5", function(unitt)
        _G.dis = tonumber(unitt)
    end)
    
    tab1:TextBox("SOG wait", "2", function(unitt)
        _G.sogwait = tonumber(unitt)
    end)

    tab1:TextBox("Skill Delay", "0", function(unitt)
         _G.delaySkill = tonumber(unitt)
    end)
    
    for i=1,4 do
        local nom = "Use Skill " .. tostring(i)
        local e = tab1:Toggle(nom, "", function(bool)
            addRemoveSkill(i)
        end)
    end
    
    local m1s = tab1:Toggle("Use M1s", "", function(bool)
        _G.useM1 = bool
    end)
    m1s:UpdateToggle(true)

    local tab2 = win:Tab("Pre Set Config")
    
    tab2:Button("Statue Config",function()
        _G.dis = 20
        _G.sogwait = 10
        _G.skillsToUseee = {1}
        _G.useM1 = false
        _G.delaySkill = 0.5
    end)
    
end
