local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "dsms", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    Tudo = Window:CreateTab{
        Title = "All-in-one",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local plr = game.Players.LocalPlayer

if not _G.antiafkk then
    _G.antiafkk = true
    
    game.Players.LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end

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
        if v:IsA("Model") and game.Players:FindFirstChild(v.Name) == nil and v.Name ~= "Dummy" and v.Name ~= "Dummy2" and checkAlive(v) and not string.find(v.Name, "'s Soldier") then
            returner = v
            break
        end
    end
    
    return returner
end

function serverSide(args)
    game.ReplicatedStorage.Remotes.Serverside:FireServer(unpack(args))
end

function attack(bool)
    serverSide({"Server", "Special", "M1s", 1, "Akaza"})
    
    if bool then
        for i=1,5 do
            serverSide({"Server", "Special", "Move"..tostring(i), nil, "Akaza", plr.Character.HumanoidRootPart.CFrame})
        end
    end
end

function useHaki()
    if plr.Character and not plr.Character:FindFirstChild("HakiActive") then
        serverSide({"Server", "Misc", "Haki", true})
        task.wait(.2)
    end
end

function wandereich()
    useHaki()
    if plr.MissionData.Active.Value == false then
        pcall(function()
            plr.Character.HumanoidRootPart.CFrame = workspace.Npc.Quest["Mission 3"].HumanoidRootPart.CFrame * CFrame.new(0,0,-1)
            task.wait(.5)
            
            workspace.Npc.Quest["Mission 3"].ProximityPrompt:InputHoldBegin()
            task.wait(workspace.Npc.Quest["Mission 3"].ProximityPrompt.HoldDuration)
            workspace.Npc.Quest["Mission 3"].ProximityPrompt:InputHoldEnd()
        end)
        
    else
        if string.find(plr.MissionData["Quest Title"].Value, "Destroy Core") then
            if workspace.Main.Wardenreich["Core Of Wardenreich"]:FindFirstChild("Core Of Wardenreich") then
                pcall(function()
                    plr.Character.HumanoidRootPart.CFrame = workspace.Main.Wardenreich["Core Of Wardenreich"]["Core Of Wardenreich"].HumanoidRootPart.CFrame * CFrame.new(0,0,1)
                    plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    
                    attack()
                end)
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
                    
                    attack()
                end)
            else
                mob = getMob(workspace.Main.Wardenreich.Quincy)
            end
        elseif string.find(plr.MissionData["Quest Title"].Value, "Uryu") then
            if mob and checkAlive(mob) and mob.Name == "Uryu [Lv.???]" then
                pcall(function()
                    plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
                    plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    
                    attack()
                end)
            else
                mob = getMob(workspace.Main.Wardenreich.Uryu)
            end
        end
    end
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
                
                useHaki()
                attack()
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
        wandereich()
    end
end)


--=-=-=-= TAB 2 -=-=-=-=--

function killMob(mob, bool, cf)
    if not cf then cf = CFrame.new(0,0,5) end
    
    repeat task.wait()
        pcall(function()
            plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * cf
            plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            
            attack(bool)
        end)
    until mob == nil or mob and checkAlive(mob) == false
end

Tabs.Tudo:CreateToggle("dioTudoToggle", {Title = "Kill Dio", Default = false}):OnChanged(function()
    _G.dioTudo = Options.dioTudoToggle.Value
end)
Tabs.Tudo:CreateToggle("fallenTudoToggle", {Title = "Kill Fallen Knight", Default = false}):OnChanged(function()
    _G.fallenTudo = Options.fallenTudoToggle.Value
end)
Tabs.Tudo:CreateToggle("eclipseTudoToggle", {Title = "Auto Eclipse", Default = false}):OnChanged(function()
    _G.eclipseTudo = Options.eclipseTudoToggle.Value
end)
Tabs.Tudo:CreateToggle("repTudoToggle", {Title = "Auto Wandereich", Default = false}):OnChanged(function()
    _G.repTudo = Options.repTudoToggle.Value
end)

local tudoToggle = Tabs.Tudo:CreateToggle("tudoToggle", {Title = "Auto Everything", Default = false})
tudoToggle:OnChanged(function()
    _G.tudoAuto = Options.tudoToggle.Value
    
    if _G.tudoAuto then
        _G.autofarm = false
        _G.wanderFarm = false
        _G.oreFarm = false
        -- COLOCAR OS TOGGLES NO OFF
    end
    
    while _G.tudoAuto do task.wait()
        useHaki()
        if _G.dioTudo and workspace.Main["The World Over Heaven"]:FindFirstChildOfClass("Model") and workspace.Main["The World Over Heaven"]:FindFirstChildOfClass("Model"):FindFirstChild("Humanoid") and workspace.Main["The World Over Heaven"]:FindFirstChildOfClass("Model").Humanoid.Health > 0 then
            killMob(getMob(workspace.Main["The World Over Heaven"]), false)
            
        elseif _G.fallenTudo and workspace.Main["Fallen Angel"]:FindFirstChildOfClass("Model") and workspace.Main["Fallen Angel"]:FindFirstChildOfClass("Model"):FindFirstChild("Humanoid") and workspace.Main["Fallen Angel"]:FindFirstChildOfClass("Model").Humanoid.Health > 0 then
            killMob(getMob(workspace.Main["Fallen Angel"]), false)
            
        elseif _G.eclipseTudo and workspace.Map["Blood Island"].Spawned.Value then
            if plr.MissionData.Active.Value == false then
                pcall(function()
                    plr.Character.HumanoidRootPart.CFrame = workspace.Npc.Schierke.HumanoidRootPart.CFrame * CFrame.new(0,0,-1)
                    task.wait(.5)
                    
                    workspace.Npc.Schierke.ProximityPrompt:InputHoldBegin()
                    task.wait(workspace.Npc.Schierke.ProximityPrompt.HoldDuration)
                    workspace.Npc.Schierke.ProximityPrompt:InputHoldEnd()
                    task.wait(.2)
                end)
                
            else
                if string.find(plr.MissionData["Quest Title"].Value, "Guts") or string.find(plr.MissionData["Quest Title"].Value, "Falcon") then
                    killMob(getMob(workspace.Main), true)
            
                else
                    pcall(function()
                        plr.Character.Head:Destroy()
                        plr.CharacterAdded:Wait()
                    end)
                end
            end
        elseif _G.repTudo then
            wandereich()
        end
    end
end)
