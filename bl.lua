local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "bl", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    AutoFarm = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    AutoRaid = Window:CreateTab{
        Title = "Misc",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options


-- Variables

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local selectedTarget = "ahsduahs9dauhshh"


-- Important 

local part = Instance.new("Part", workspace)
part.Transparency = 1
part.Anchored = true
part.Massless = true
part.CanCollide = false
part.CFrame = char.HumanoidRootPart.CFrame
Instance.new("Attachment", part)

local align = Instance.new("AlignPosition", part)
align.MaxForce = 99e99
align.MaxVelocity = 400
align.Responsiveness = 200
align.Attachment0 = char.HumanoidRootPart.RootAttachment
align.Attachment1 = part.Attachment

local orient = Instance.new("AlignOrientation", part)
orient.MaxTorque = math.huge
orient.Responsiveness = 200
orient.Attachment0 = char.HumanoidRootPart.RootAttachment
orient.Attachment1 = part.Attachment

plr.CharacterAdded:Connect(function(cha)
    char = cha
    if _G.testt then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    end
end)


-- Functions

function noClip()
    for i,v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

function checkAlive(enemy)
    local returner = false
    if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
        returner = true
    end
    return returner
end

function getEnemy(a)
    local returner
    
    if a.All then
        local aa = {}
        
        for i,v in pairs(workspace.Live:GetChildren()) do
            if not table.find(aa, v.Name:sub(1, -7)) and not string.find(v.Name, "entity clone") and not game.Players:FindFirstChild(v.Name) and not v.Name == "Server" then
                table.insert(aa, v.Name:sub(1, -7))
            end
        end
        
        returner = aa
    else
        for i,v in pairs(workspace.Live:GetChildren()) do
            if a.Selected then
                if string.find(v.Name, selectedTarget) and checkAlive(v) then
                    returner = v
                    break
                end
            else
                if checkAlive(v) and not game.Players:FindFirstChild(v.Name) and not v.Name == "Server" then
                    returner = v
                    break
                end
            end
        end
    end
    
    return returner
end


-- Script


-- AutoFarm Tab

local autoraidToggle = Tabs.AutoFarm:CreateToggle("autoraidToggle", {Title = "Auto Raid", Default = false})
autoraidToggle:OnChanged(function()
    _G.autoraid = Options.autoraidToggle.Value
        
    local enemy
    if _G.autoraid then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    else
        align.Attachment0 = nil
        orient.Attachment0 = nil
    end
    
    if _G.testt then _G.testt = false end
    
    while _G.autoraid do task.wait()
        noClip()
        
        if enemy and checkAlive(enemy) then
            if plr:DistanceFromCharacter(enemy.HumanoidRootPart.Position) > 500 then
                char.HumanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,-8,0))
            end
            
            part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,-8,0)) * CFrame.Angles(math.rad(90),0,0)
            plr.Character:WaitForChild("client_character_controller"):WaitForChild("M1"):FireServer(true,false)
        else
            enemy = getEnemy()
        end
    end
end)

local autofarmToggle = Tabs.AutoFarm:CreateToggle("autofarmToggle", {Title = "Auto Farm Selected", Default = false})
autofarmToggle:OnChanged(function()
    _G.testt = Options.autofarmToggle.Value
        
    local enemy
    if _G.testt then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    else
        align.Attachment0 = nil
        orient.Attachment0 = nil
    end
    
    if _G.autoraid then _G.autoraid = false end
    
    while _G.testt do task.wait()
        noClip()
        
        if enemy and checkAlive(enemy) and string.find(v.Name, selectedTarget) then
            if plr:DistanceFromCharacter(enemy.HumanoidRootPart.Position) > 500 then
                char.HumanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,-8,0))
            end
            
            part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,-8,0)) * CFrame.Angles(math.rad(90),0,0)
            plr.Character:WaitForChild("client_character_controller"):WaitForChild("M1"):FireServer(true,false)
        else
            enemy = getEnemy({Selected = true})
        end
    end
end)

selectDropdown = Tabs.AutoFarm:CreateDropdown("selectDropdown", {Title = "Target", Values = {}, Multi = false, Default = ""})
selectDropdown:OnChanged(function(Value)
    selectedTarget = Value
end)

Tabs.AutoFarm:CreateButton{Title = "Update Target List", Description = "", Callback = function()
    selectDropdown:SetValues(getEnemy({All = true}))
end}


-- AutoRaid Tab
