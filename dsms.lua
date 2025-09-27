local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "dsms", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    Teleport = Window:CreateTab{
        Title = "Teleport",
        Icon = "phosphor-users-bold"
    },
    Misc = Window:CreateTab{
        Title = "Misc",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local plr = game.Players.LocalPlayer
local liveFolder = workspace.Live
local distance = 10

_G.autofarm = false


-- MAIN

function noClip()
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

function checkAlive(mob)
    local returner = false
    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
        returner = true
    end
    return returner
end

function getMob()
    local returner
    
    if liveFolder.BossMinions:FindFirstChildOfClass("Model") and checkAlive(liveFolder.BossMinions:FindFirstChildOfClass("Model")) then
        returner = liveFolder.BossMinions:FindFirstChildOfClass("Model")
        distance = -7
    elseif liveFolder.Bosses:FindFirstChild("Akaza") and checkAlive(liveFolder.Bosses:FindFirstChild("Akaza")) then
        returner = liveFolder.Bosses:FindFirstChild("Akaza")
        distance = -9
    end
    
    return returner
end

function m1()
    local nichirin = plr.Character:FindFirstChild("Nichirin") or plr.Character:FindFirstChild("Old Nichirin")
    
    if not nichirin then
        nichirin = plr.Backpack:FindFirstChild("Nichirin") or plr.Backpack:FindFirstChild("Old Nichirin")
        plr.Character.Humanoid:EquipTool(nichirin)
    end
    
    nichirin.RemoteEvent:FireServer("M1")
    nichirin.RemoteEvent:FireServer("Hitbox", 1, "M1")
end

local autofarmToggle = Tabs.Main:CreateToggle("autofarmToggle", {Title = "Auto Farm", Default = false})
autofarmToggle:OnChanged(function()
    _G.autofarm = Options.autofarmToggle.Value
    local mob
    
    if _G.autofarm then spawn(function() noClip() end) end
    
    while _G.autofarm do task.wait()
        if liveFolder.BossMinions:FindFirstChildOfClass("Model") == nil and liveFolder.Bosses:FindFirstChild("Akaza") == nil then
            plr.Character.HumanoidRootPart.CFrame = workspace.Environment["Booskap\196\177s\196\177"].AlocButton.CFrame
            task.wait(1)
            fireproximityprompt(workspace.Environment["Booskap\196\177s\196\177"].AlocButton.ProximityPrompt)
        else
            mob = getMob()
            if mob then
                plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,distance,0)
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                
                m1()
            end
        end
    end
end)
