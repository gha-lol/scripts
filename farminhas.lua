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
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/InfinitiveUI",true))()
local win = lib:CreateWindow("BizBlox",1,nil,nil)

-- Tab1
local tab1,name1 = win:CreateTab("Farms",function() end)

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

local function autorebirth()
    task.wait(1)
    for i=1,5 do
        game.ReplicatedStorage.Remote.GameEvent:FireServer("GetBackPack", plr.BackPackBox["Rebirth Arrow"])
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

tab1:CreateDropdown("Quest",questTable,false,function(quest)
    _G.ques = quest
    t.ques = quest
end)

tab1:CreateSlider("Distance",5,15,t.dis,function(valor)
    _G.dis = valor
    t.dis = valor
end)

tab1:CreateToggle("Auto-Farm",false,function(bool)
    _G.autofarm = bool
    t.autofarm = bool
    
    autofarm()
end)

-- Tab2
local tab2,name2 = win:CreateTab("Auto Misc",function() end)

tab2:CreateDropdown("Stat",{"Health", "Stamina", "Strength"},false,function(stat)
    _G.statt = stat
    t.statt = stat
end)

tab2:CreateToggle("Auto-Points",false,function(bool)
    _G.autopoints = bool
    t.autopoints = bool
    
    autopoints()
end)

local conPlrAdded
tab2:CreateToggle("Auto Use Rebirth",false,function(bool)
    _G.autorebirth = bool
    
    if bool then
        autorebirth()
        
        conPlrAdded = plr.CharacterAdded:Connect(autorebirth)
    else
        conPlrAdded:Disconnect()
    end
end)

tab2:CreateToggle("Block Player And Rejoin",false,function(bool)
    _G.autoblock = bool
    t.autoblock = bool
    
    blockrejoin()
end)

-- Tab3
local tab3,name3 = win:CreateTab("Misc",function() end)

local codeList = {}
for i,v in pairs(plr.Confirmed_Code:GetChildren()) do
    table.insert(codeList,v.Name)
end

tab3:CreateDropdown("Code List",codeList,false,function(stat)
    _G.codeToUse = stat
    t.code = stat
end)

tab3:CreateButton("Use Code",function()
    game.ReplicatedStorage.Remote.GameEvent:FireServer("GetCode", _G.codeToUse)
end)

tab3:CreateButton("Teleportar Spawn",function()
    plr.Character.HumanoidRootPart.CFrame = CFrame.new(179, 3.4, -3.2)
end)

tab3:CreateButton("Get Arrows",function()
    for i,v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") then
            plr.Character.Humanoid:EquipTool(v)
        end
    end
end)

local dupeAmount = 1
tab3:CreateSlider("Dupe Amount",1,5000,1,function(valor)
    dupeAmount = valor
end)

tab3:CreateButton("Dupe Rebirth",function()
    local rebirthArrow = plr.Backpack:FindFirstChild("Rebirth Arrow") or plr.Character:FindFirstChild("Rebirth Arrow")
    
    if rebirthArrow then
        for i=1,dupeAmount do
            game.ReplicatedStorage.Remote.GameEvent:FireServer("StoreBackPack", rebirthArrow)
        end
    end
end)

tab3:CreateButton("Tp Italy",function()
    game:GetService("TeleportService"):Teleport(93140024895832)
end)

autofarm()
autopoints()
blockrejoin()
