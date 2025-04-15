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
    
    missionDropdown = tab1:Dropdown("Maps", missionsTable, function(mission)
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
end
