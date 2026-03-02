local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "bl", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    AutoFarm = Window:CreateTab{
        Title = "AutoFarm",
        Icon = "phosphor-users-bold"
    },
    Config = Window:CreateTab{
        Title = "Config",
        Icon = "phosphor-users-bold"
    },
    File = Window:CreateTab{
        Title = "File",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local Service = game:GetService("HttpService")
local t = {
    autofarm = false,
    autoraid = false,
    selectedTarget = "dahsdshaudahus",
    keys = {
        M2 = false,
        E = false,
        R = false,
        Z = false,
        X = false,
        C = false,
        V = false
    }
}

if isfile("bl.json") then
    t = Service:JSONDecode(readfile("bl.json"))
end


-- Variables

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()


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
    if t.autofarm or t.autoraid then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    end
end)


-- Functions

function saveSettings()
    writefile("bl.json", Service:JSONEncode(t))
end

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
            if not table.find(aa, v.Name:sub(1, -7)) and not string.find(v.Name, "entity clone") and not game.Players:FindFirstChild(v.Name) and v.Name ~= "Server" then
                table.insert(aa, v.Name:sub(1, -7))
            end
        end
        
        returner = aa
    else
        for i,v in pairs(workspace.Live:GetChildren()) do
            if a.Selected then
                if string.find(v.Name, t.selectedTarget) and checkAlive(v) then
                    returner = v
                    break
                end
            else
                if checkAlive(v) and not game.Players:FindFirstChild(v.Name) and v.Name ~= "Server" then
                    returner = v
                    break
                end
            end
        end
    end
    
    return returner
end

function autofarm(bool, ignoreName, tab)
    local enemy
  
    while t[bool] do task.wait()
        if not workspace.Effects:FindFirstChild("."..plr.Name.."'s Stand") then
            char["client_character_controller"].SummonStand:FireServer()
            task.wait()
        end

        noClip()
        
        if enemy and checkAlive(enemy) and (ignoreName or string.find(enemy.Name, t.selectedTarget)) then
            if plr:DistanceFromCharacter(enemy.HumanoidRootPart.Position) > 500 then
                char.HumanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,-8,0))
            end
            
            part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,-8,0)) * CFrame.Angles(math.rad(90),0,0)
            
            for i,v in pairs(t.keys) do
                if i ~= "M2" and v then
                    char["client_character_controller"].Skill:FireServer(tostring(i),true)
                elseif i == "M2" and v then
                    char["client_character_controller"]["M2"]:FireServer(true,false)
                end
            end
            
            char["client_character_controller"]["M1"]:FireServer(true,false)
        else
            enemy = getEnemy(tab)
        end
    end
end


-- Script


-- AutoFarm Tab

local autoraidToggle = Tabs.AutoFarm:CreateToggle("autoraidToggle", {Title = "Auto Raid", Default = t.autoraid})
autoraidToggle:OnChanged(function()
    t.autoraid = Options.autoraidToggle.Value
        
    local enemy
    if t.autoraid then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    else
        align.Attachment0 = nil
        orient.Attachment0 = nil
    end
    
    if t.autofarm then t.autofarm = false end
    
    autofarm("autoraid", true, {})
end)
autoraidToggle:SetValue(t.autoraid)

local autofarmToggle = Tabs.AutoFarm:CreateToggle("autofarmToggle", {Title = "Auto Farm Selected", Default = t.autofarm})
autofarmToggle:OnChanged(function()
    t.autofarm = Options.autofarmToggle.Value
        
    local enemy
    if t.autofarm then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    else
        align.Attachment0 = nil
        orient.Attachment0 = nil
    end
    
    if t.autoraid then t.autoraid = false end
    
    autofarm("autofarm", false, {Selected = true})
end)
autofarmToggle:SetValue(t.autofarm)

selectDropdown = Tabs.AutoFarm:CreateDropdown("selectDropdown", {Title = "Target", Values = {}, Multi = false, Default = t.selectedTarget})
selectDropdown:OnChanged(function(Value)
    t.selectedTarget = Value
end)
selectDropdown:SetValues(getEnemy({All = true}))

Tabs.AutoFarm:CreateButton{Title = "Update Target List", Description = "", Callback = function()
    selectDropdown:SetValues(getEnemy({All = true}))
end}


-- Config

for i,v in pairs(t.keys) do
    local key = Tabs.Config:CreateToggle("key"..tostring(i), {Title = "Use "..tostring(i), Default = v})
    key:OnChanged(function()
        t.keys[i] = Options["key"..tostring(i)].Value
    end)
end


-- File

Tabs.File:CreateButton{Title = "Save Config", Description = "", Callback = function()
    saveSettings()
end}
