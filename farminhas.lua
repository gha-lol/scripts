local Service = game:GetService("HttpService")
local t = {
  ques = "",
  dis = 8,
  statt = "Strength",
  code = "",
  autofarm = false,
  arrowfarm = false,
  autopoints = false,
  autoblock = false
}

if isfile("bizblox.json") then
    t = Service:JSONDecode(readfile("bizblox.json"))
end

local function saveSettings()
    writefile("bizblox.json", Service:JSONEncode(t))
end

_G.ques = t.ques
_G.dis = t.dis
_G.statt = t.statt
_G.codeToUse = t.code
_G.autofarm = t.autofarm
_G.arrowfarm = t.arrowfarm
_G.autopoints = t.autopoints
_G.autoblock = t.autoblock
_G.autorebirth = false

local plr = game.Players.LocalPlayer
local conPlrAdded
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/libHawk.lua", true))()
local win = lib:Window({ScriptName = "farminhas kk", DestroyIfExists = true, Theme = "Dark"})
win:Minimize({visibility = true, OpenButton = true, Callback = function() end})

-- FUNCTIONS

local questTable = {}
for i,v in pairs(workspace.Enemies.Pos:GetChildren()) do
    if not table.find(questTable, v.Name) then
        table.insert(questTable, v.Name)
    end
end

local function noClip()
    local stepped
    stepped = game:GetService('RunService').Stepped:Connect(function()
        if plr.Character.Humanoid.Health <= 0 then
            plr.Character.Humanoid:ChangeState(2)
        elseif _G.autofarm then
            plr.Character.Humanoid:ChangeState(11)
        else
            plr.Character.Humanoid:ChangeState(2)
            stepped:Disconnect()
        end
    end)
end

local function getMob()
    local returner
    
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == plr.Quest.Target.Value and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            returner = v
            break
        end
    end
    
    return returner
end

local function autofarm()
    spawn(function()
        noClip()
        local mob
        
        while _G.autofarm do task.wait()
            pcall(function()
                plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end)
            if not plr.Quest:FindFirstChild("Target") then
                game.ReplicatedStorage.Remote.GameEvent:FireServer("Quest", _G.ques)
            else
                if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    pcall(function()
                        if _G.ques == "Diavolo" then
                            plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,_G.dis,0)
                            plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                            game.ReplicatedStorage.Remote.HumonEvent:FireServer("M1", true, plr.Character.HumanoidRootPart.CFrame.LookVector)
                        else
                            plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,-_G.dis,0)
                            plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                            game.ReplicatedStorage.Remote.HumonEvent:FireServer("M1", true, plr.Character.HumanoidRootPart.CFrame.LookVector)
                        end
                    end)
                else
                    if workspace.Enemies:FindFirstChild(plr.Quest.Target.Value) then
                        mob = getMob()
                    else
                        pcall(function()
                            local studss = -20
                            if _G.ques == "Diavolo" then studss = 20 end
                            plr.Character.HumanoidRootPart.CFrame = workspace.Enemies.Pos[plr.Quest.Target.Value].CFrame * CFrame.new(0,studss,0)
                        end)
                    end
                end
            end
        end
    end)
end

local function autopoints()
    spawn(function()
        while _G.autopoints do task.wait(1)
            if plr.Stats.Points.Value > 0 then
                plr.PlayerGui.UiService.StatsFrame.upstats:InvokeServer(_G.statt, "up", plr.Stats.Points.Value)
            end
        end
    end)
end

local function blockrejoin()
    spawn(function()
        while _G.autoblock do task.wait(1)
            for i,v in pairs(game.Players:GetChildren()) do
                if v.Name ~= plr.Name then
                    _G.autofarm = false
                    _G.autorebirth = false
                    pcall(function() conPlrAdded:Disconnect() end)
                    
                    
                    local s = Instance.new("Sound",game.Workspace)
                    s.Name = "ItemSound"
                    s.SoundId = "http://www.roblox.com/asset?id=171270157"
                    s.Volume = 3
                    s.Looped = false
                    s:Play()
                    
                    saveSettings()
                    queueonteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/farminhas.lua",true))()')
                    
                    game:GetService("StarterGui"):SetCore("PromptBlockPlayer", v)
                    task.wait(10)
                    for i=1,10 do
                        game:GetService("TeleportService"):Teleport(game.PlaceId)
                        task.wait(3)
                    end
                end
            end
        end
    end)
end

local function useRebirths()
    task.wait(1)
    for i=1,(plr.BackPackBox["Rebirth Arrow"].Value - 1) do
        game.ReplicatedStorage.Remote.GameEvent:FireServer("GetBackPack", plr.BackPackBox["Rebirth Arrow"])
        task.wait(4)
    end
    task.wait(1)
    
    for i,v in pairs(plr.Backpack:GetChildren()) do
        if v.Name == "Rebirth Arrow" then
            plr.Character.Humanoid:EquipTool(v)
            repeat task.wait() until plr.PlayerGui:FindFirstChild("Drop")
            for i=1,10 do
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(520,  300,  0, true, game, 1)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(520,  300,  0, false, game, 1)
                task.wait(0.04)
            end
        end
    end
end

local function autorebirth()
    if plr.BackPackBox["Rebirth Arrow"].Value == 4 then
        useRebirths()
    elseif plr.BackPackBox["Rebirth Arrow"].Value > 0 then
        game.ReplicatedStorage.Remote.GameEvent:FireServer("GetBackPack", plr.BackPackBox["Rebirth Arrow"])
        repeat task.wait() until plr.Backpack:FindFirstChild("Rebirth Arrow")
        
        while task.wait() do
            if game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() > 300 then
                repeat task.wait() until game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() < 300
            end
          
            for i=1,10000 do
                game.ReplicatedStorage.Remote.GameEvent:FireServer("StoreBackPack", plr.Backpack:FindFirstChild("Rebirth Arrow"))
            end

            print("Antes do wait " .. game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            task.wait(5)
            print("Depois do wait " .. game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            
            if plr.BackPackBox["Rebirth Arrow"].Value == 4 then
                repeat task.wait() until game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() < 300
                task.wait(4)
                break
            end
        end
        
        useRebirths()
    else
        local Notifications = Hawk:AddNotifications()
        Notifications:Notification("Erro","Sem Rebirth No Storage","Warning",5)
    end
end


-- Tab1
local tab1 = win:Tab("Farms")

tab1:Dropdown("Quest",questTable,function(quest)
    _G.ques = quest
    t.ques = quest
end)

local disSlider = tab1:Slider("Distance",5,15,function(valor)
    _G.dis = valor
    t.dis = valor
end)
disSlider:SetValue(t.dis)

local autofarmToggle = tab1:Toggle("Auto-Farm","",function(bool)
    _G.autofarm = bool
    t.autofarm = bool
    
    autofarm()
end)
autofarmToggle:UpdateToggle(t.autofarm)


-- Tab2
local tab2 = win:Tab("Auto Misc")

tab2:Dropdown("Stat",{"Health", "Stamina", "Strength"},function(stat)
    _G.statt = stat
    t.statt = stat
end)

local autopointsToggle = tab2:Toggle("Auto-Points","",function(bool)
    _G.autopoints = bool
    t.autopoints = bool
    
    autopoints()
end)
autopointsToggle:UpdateToggle(t.autopoints)

tab2:Toggle("Auto Use Rebirth","",function(bool)
    _G.autorebirth = bool
    
    if bool then
        autorebirth()
        
        conPlrAdded = plr.CharacterAdded:Connect(autorebirth)
    else
        conPlrAdded:Disconnect()
    end
end)

local autoblockToggle = tab2:Toggle("Block Player And Rejoin","",function(bool)
    _G.autoblock = bool
    t.autoblock = bool
    
    blockrejoin()
end)
autoblockToggle:UpdateToggle(t.autoblock)

-- Tab3
local tab3 = win:Tab("Misc")

local codeList = {}
for i,v in pairs(plr.Confirmed_Code:GetChildren()) do
    table.insert(codeList,v.Name)
end

tab3:Dropdown("Code List",codeList,function(stat)
    _G.codeToUse = stat
    t.code = stat
end)

tab3:Button("Use Selected Code",function()
    game.ReplicatedStorage.Remote.GameEvent:FireServer("GetCode", _G.codeToUse)
end)

tab3:Button("Get Arrows","Collects all spawned arrows",function()
    for i,v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") then
            plr.Character.Humanoid:EquipTool(v)
        end
    end
end)

local dupeAmount = 1
tab3:Slider("Dupe Amount",1,10000,function(valor)
    dupeAmount = valor
end)

tab3:Button("Dupe Rebirth",function()
    local rebirthArrow = plr.Backpack:FindFirstChild("Rebirth Arrow") or plr.Character:FindFirstChild("Rebirth Arrow")
    
    if rebirthArrow then
        for i=1,dupeAmount do
            game.ReplicatedStorage.Remote.GameEvent:FireServer("StoreBackPack", rebirthArrow)
        end
    end
end)

tab3:Button("Save Settings",function()
    saveSettings()
end)


-- Tab4
local tab4 = win:Tab("Teleports")

tab4:Button("Teleportar Spawn",function()
    plr.Character.HumanoidRootPart.CFrame = CFrame.new(179, 3.4, -3.2)
end)

tab4:Button("Tp Italy",function()
    game:GetService("TeleportService"):Teleport(93140024895832)
end)

tab4:Button("Test Server",function()
    game:GetService("TeleportService"):Teleport(104259677668546)
end)

tab4:Button("Rejoin",function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
    queueonteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/farminhas.lua",true))()')
end)

game.ReplicatedStorage.Remote.GameEvent:FireServer("PvP", false)
if #game.Players:GetChildren() > 1 and _G.blockrejoin == false or _G.blockrejoin and #game.Players:GetChildren() == 1 then
    autofarm()
end
autopoints()
blockrejoin()
