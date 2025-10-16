local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "dsms", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local plr = game.Players.LocalPlayer

function checkAlive(mob)
    local returner = false
    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
        returner = true
    end
    return returner
end

function getMob(par)
    local returner
    local getFrom = par or workspace.Main
    
    for i,v in pairs(getFrom:GetChildren()) do
        if v:IsA("Model") and v.Name ~= plr.Name and checkAlive(v) then
            returner = v
            break
        end
    end
    
    return returner
end

local autofarmToggle = Tabs.Main:CreateToggle("autofarmToggle", {Title = "Auto Farm", Default = false})
autofarmToggle:OnChanged(function()
    _G.autofarm = Options.autofarmToggle.Value
    local mob
    
    while _G.autofarm do task.wait()
        if mob and checkAlive(mob) then
            pcall(function()
                plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
                plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                game.ReplicatedStorage.Remotes.Serverside:FireServer("Server", "Special", "M1s", 1, "Akaza")
            end)
        else
            mob = getMob()
        end
    end
end)

local oreToggle = Tabs.Main:CreateToggle("oreToggle", {Title = "Auto Ore", Default = false})
oreToggle:OnChanged(function()
    _G.oreFarm = Options.oreToggle.Value
    
    while _G.oreFarm do task.wait()
        for i,v in pairs(workspace.Main.Ore:GetChildren()) do
            if not _G.oreFarm then
                break
            end
            
            if v:IsA("Model") and v:FindFirstChild("{}") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Stone.Position + Vector3.new(0,3,0))
                task.wait(.5)
                v["{}"]:InputHoldBegin()
                task.wait(v["{}"].HoldDuration)
            end
        end
    end
end)


local wanderToggle = Tabs.Main:CreateToggle("wanderToggle", {Title = "Auto Wandereich", Default = false})
wanderToggle:OnChanged(function()
    _G.wanderFarm = Options.wanderToggle.Value
    
    local mob
    
    while _G.wanderFarm do task.wait()
        if plr.MissionData.Active.Value == false then
            plr.Character.HumanoidRootPart.CFrame = workspace.Npc.Quest["Mission 3"].HumanoidRootPart.CFrame * CFrame.new(0,0,-1)
            task.wait(.5)
            workspace.Npc.Quest["Mission 3"].ProximityPrompt:InputHoldBegin()
            task.wait(workspace.Npc.Quest["Mission 3"].ProximityPrompt.HoldDuration)
            workspace.Npc.Quest["Mission 3"].ProximityPrompt:InputHoldEnd()
        else
            if string.find(plr.MissionData["Quest Title"].Value, "Destroy Core") then
                if workspace.Main.Wardenreich["Core Of Wardenreich"]:FindFirstChild("Core Of Wardenreich") then
                    plr.Character.HumanoidRootPart.CFrame = workspace.Main.Wardenreich["Core Of Wardenreich"]["Core Of Wardenreich"].HumanoidRootPart.CFrame * CFrame.new(0,0,1)
                    plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    game.ReplicatedStorage.Remotes.Serverside:FireServer("Server", "Special", "M1s", 1, "Akaza")
                end
                
            elseif string.find(plr.MissionData["Quest Title"].Value, "Reiatsu Aura") then
                plr.Character.HumanoidRootPart.CFrame = workspace.Main["Mission Quest 3"]["1"].Aura.CFrame
                task.wait(.5)
                workspace.Main["Mission Quest 3"]["1"].Aura.ProximityPrompt:InputHoldBegin()
                task.wait(workspace.Main["Mission Quest 3"]["1"].Aura.ProximityPrompt.HoldDuration)
                workspace.Main["Mission Quest 3"]["1"].Aura.ProximityPrompt:InputHoldEnd()
                task.wait(.1)
                
            elseif string.find(plr.MissionData["Quest Title"].Value, "Quincy") then
                if mob and checkAlive(mob) and mob.Name == "Quincy [Lv.5000]" then
                    pcall(function()
                        plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
                        plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        game.ReplicatedStorage.Remotes.Serverside:FireServer("Server", "Special", "M1s", 1, "Akaza")
                    end)
                else
                    mob = getMob(workspace.Main.Wardenreich.Quincy)
                end
            elseif string.find(plr.MissionData["Quest Title"].Value, "Uryu") then
                if mob and checkAlive(mob) and mob.Name == "Uryu [Lv.???]" then
                    pcall(function()
                        plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
                        plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        game.ReplicatedStorage.Remotes.Serverside:FireServer("Server", "Special", "M1s", 1, "Akaza")
                    end)
                else
                    mob = getMob(workspace.Main.Wardenreich.Uryu)
                end
            end
        end
    end
end)
