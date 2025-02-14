_G.ques = ""
_G.autofarm = false
_G.arrowfarm = false

local plr = game.Players.LocalPlayer
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/InfinitiveUI",true))()
local win = lib:CreateWindow("BizBlox",1,nil,nil)
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
        if _G.autofarm then
            plr.Character.Humanoid:ChangeState(11)
        else
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

tab1:CreateDropdown("Quest",questTable,false,function(quest)
    _G.ques = quest
end)

tab1:CreateToggle("Auto-Farm",false,function(bool)
    spawn(function()
        _G.autofarm = bool
        noClip()
        local mob
        
        while _G.autofarm do task.wait()
            if not plr.Quest:FindFirstChild("Target") then
                game.ReplicatedStorage.Remote.GameEvent:FireServer("Quest", _G.ques)
            else
                if workspace.Enemies:FindFirstChild(plr.Quest.Target.Value) then
                    if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90), 0, 0) + Vector3.new(0,-8,0)
                        game.ReplicatedStorage.Remote.HumonEvent:FireServer("M1", true, plr.Character.HumanoidRootPart.CFrame.LookVector)
                    else
                        mob = getMob()
                    end
                else
                    plr.Character.HumanoidRootPart.CFrame = workspace.Enemies.Pos[plr.Quest.Target.Value].CFrame * CFrame.new(0,-15,0)
                end
            end
        end
    end)
end)
