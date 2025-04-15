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
            plr.Backpack.Input.Remote:FireServer({unpack(tab)})
        end)
    end
    
    function createForce(part)
        local bv = instance.new("BodyVelocity")
        bv.Name = "fno"
        bv.MaxForce = Vector3.new(1/0,1/0,1/0)
        bv.P = 1/0
        bv.Velocity = Vector3.new(30,30,30)
        bv.Parent = part
    end
    
    while _G.e do task.wait()
        if mob and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,-_G.dis,0)
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
    
                if mob:FindFirstChild("Head") then mob.Head:Destroy() end
                if not mob.HumanoidRootPart:FindFirstChild("fno") then createForce(mob.HumanoidRootPart) end
              
                mob.Humanoid.Health = 0
                game:GetService("Workspace").FallenPartsDestroyHeight = 0 / 0
                sethiddenproperty(plr, "SimulationRadius", 200000)
                
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
