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
local lastCheck = nil
local distance = 10
local foundServer = false

_G.autofarm = false
_G.automerchant = false

if plr.PlayerGui.FirstMenu.Enabled == true then
    game:GetService("GuiService").SelectedObject = plr.PlayerGui.FirstMenu.Play.PlayButton
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Return", false, game)
    task.wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "Return", false, game)
    
    repeat task.wait(.1) until plr.Character
end


-- =-=-=-=-=-= MAIN =-=-=-=-=-=

-- AUTO ALOC

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
        distance = 7
    elseif liveFolder.Bosses:FindFirstChild("Akaza") and checkAlive(liveFolder.Bosses:FindFirstChild("Akaza")) then
        returner = liveFolder.Bosses:FindFirstChild("Akaza")
        distance = 9
    end
    
    return returner
end

function m1()
    local nichirin = plr.Character:FindFirstChild("Nichirin") or plr.Character:FindFirstChild("Old Nichirin") or plr.Character:FindFirstChild("Training Nichirin")
    
    if not nichirin then
        nichirin = plr.Backpack:FindFirstChild("Nichirin") or plr.Backpack:FindFirstChild("Old Nichirin") or plr.Character:FindFirstChild("Training Nichirin")
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
        if tick() - (lastCheck or 0) >= 2 then
            for i,v in pairs(game.Players:GetChildren()) do
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Name ~= plr.Name then
                    if (workspace.Environment["Booskap\196\177s\196\177"].AlocButton.Position - v.Character.HumanoidRootPart.Position).Magnitude <= 450 then
                        _G.autofarm = false
                        
                        game:GetService("StarterGui"):SetCore("PromptBlockPlayer", v)
                        task.wait(10)
                        for i=1,10 do
                            game:GetService("TeleportService"):Teleport(game.PlaceId)
                            task.wait(3)
                        end
                    end
                end
            end
        end
      
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


-- AUTO MERCHANT

function checkMerchant()
    local returner
    
    for i,v in pairs(workspace:GetChildren()) do
        if string.find(v.Name, "Merchant") and v.Name ~= "Merchant" then
            returner = v
            foundServer = true
            break
        end
    end
    
    return returner
end

function selectEnter(button)
    game:GetService("GuiService").SelectedObject = button
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Return", false, game)
    task.wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "Return", false, game)
    task.wait(.1)
end

local diagMenu = plr.PlayerGui:WaitForChild("DialogueMain")

local automerchantToggle = Tabs.Main:CreateToggle("automerchantToggle", {Title = "Auto Merchant", Default = false})
automerchantToggle:OnChanged(function()
    _G.automerchant = Options.automerchantToggle.Value
    local merchant = checkMerchant()
    local lastTp

    while _G.automerchant do task.wait()
        if merchant then
            plr.Character.HumanoidRootPart.CFrame = merchant.HumanoidRootPart.CFrame
            fireproximityprompt(merchant.Torso.ProximityPrompt)
            selectEnter(diagMenu["Dialogue"]["Answer1"])
            selectEnter(diagMenu["Dialogue2"]["Answer1"])
            selectEnter(diagMenu["Dialogue3"]["Answer1"])
        elseif foundServer == false then
            for i,v in pairs(workspace.EventEncounters["Lost Woods1"]:GetChildren()) do
                plr.Character.HumanoidRootPart.CFrame = v.CFrame
                task.wait(.5)
                if lastTp then
                    if lastTp:FindFirstChild("Attachment") then break end
                else
                    lastTp = v
                end
            end
            task.wait(.5)
            
            merchant = checkMerchant()
            if not merchant then foundServer = true end
            
            selectEnter(diagMenu["Dialogue"]["Answer2"])
            selectEnter(diagMenu["Dialogue2"]["Answer2"])
            selectEnter(diagMenu["Dialogue3"]["Answer2"])
        else
            if #game.Players:GetChildren() > 1 then
                for i,v in pairs(game.Players:GetChildren()) do
                    if v.Name ~= plr.Name then
                        game:GetService("StarterGui"):SetCore("PromptBlockPlayer", v)
                        task.wait(10)
                        break
                    end
                end
            end
            
            for i=1,10 do
                game:GetService("TeleportService"):Teleport(game.PlaceId)
                task.wait(3)
            end
        end
    end
end)

local autosunToggle = Tabs.Main:CreateToggle("autosunToggle", {Title = "Auto Sun", Default = false})
autosunToggle:OnChanged(function()
    _G.autofarm = Options.autosunToggle.Value
    local mob
    
    if _G.autofarm then spawn(function() noClip() end) end
    
    while _G.autofarm do task.wait()
        mob = workspace.Live.Npcs:FindFirstChild("Shura") or workspace.Live.Npcs:FindFirstChild("MoonEnemy")
        if mob then
            if v.Name == "Shura" then distance = 10 else distance = 9 end
            plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,distance,0)
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
            
            m1()
        end
    end
end)
