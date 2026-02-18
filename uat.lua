local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "uat", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    Misc = Window:CreateTab{
        Title = "Misc",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local titansFolder

_G.autofarm = false
_G.dupe = false


-- Essentials

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

plr.CharacterAdded:Connect(function()
    char = plr.Character
    align.Attachment0 = char:WaitForChild("HumanoidRootPart"):WaitForChild("RootAttachment")
end)


-- Functions

function noClip()
    for i,v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

function killTitan(titan, times)
    local falseTitan = {
      HumanoidRootPart = plr.Character.HumanoidRootPart,
      Parent = titansFolder,
      Name = titan.Name
    }
    
    for i=1,(times or 1) do
        game.ReplicatedStorage.DamageEvent:FireServer(nil, titan.Humanoid, "&@&*&@&", falseTitan)
    end
end

function checkAlive(titan)
    if titan:FindFirstChild("Humanoid") and titan.Humanoid.Health > 0 then
        return true
    else
        return false
    end
end

function getTitan(bool)
    local returner
    local tab = {}
    local closest = 999999999
    
    for i,v in pairs(titansFolder:GetChildren()) do
        if bool then
            if checkAlive(v) and v.Name == "Titan" and plr:DistanceFromCharacter(v.Head.Position) < 100 then
                table.insert(tab, v)
            end
        else
            if checkAlive(v) and v.Name == "Titan" and plr:DistanceFromCharacter(v.HumanoidRootPart.Position) < closest then
                closest = plr:DistanceFromCharacter(v.HumanoidRootPart.Position)
                returner = v
            end
        end
    end
    
    if bool then
        return tab
    else
        return returner
    end
end


-- Hooks

local namecall
namecall = hookmetamethod(game,"__namecall",function(self,...)
    local args = {...}
    local method = getnamecallmethod():lower()
    if self.Name == "GearSpinFinished" and _G.dupe and not checkcaller() then
        return
    end
    return namecall(self,...)
end)


-- Script


--Main

if game.PlaceId ~= 6372960231 then

    titansFolder = workspace.Entities.Titans
        
    local autofarmToggle = Tabs.Main:CreateToggle("autofarmToggle", {Title = "Auto Farm", Default = false})
    autofarmToggle:OnChanged(function()
        _G.autofarm = Options.autofarmToggle.Value
        
        local titan
        
        while _G.autofarm do task.wait()
            noClip()
            if titansFolder:FindFirstChild("Beast Titan") then
                
            elseif titansFolder:FindFirstChild("ColossalTitan") then
                killTitan(titansFolder.ColossalTitan, 700)
                break
            elseif titansFolder:FindFirstChild("Female Titan") then
                killTitan(titansFolder["Female Titan"], 700)
                break
            else
                if titan and checkAlive(titan) then
                    part.CFrame = titan.Head.CFrame * CFrame.new(0,10,0)
                    
                    for i,v in pairs(getTitan(true)) do
                        killTitan(v)
                    end
                    task.wait(.05)
                else
                    titan = getTitan()
                end
            end
        end
    end)
    
    Tabs.Main:CreateInput("InputSpeed", {Title = "Fly Speed", Default = tostring(align.MaxVelocity), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(value)
        align.MaxVelocity = tonumber(value)
    end})
end

-- MISC

local dupeToggle = Tabs.Misc:CreateToggle("dupeToggle", {Title = "Dupe", Default = false})
dupeToggle:OnChanged(function()
    _G.dupe = Options.dupeToggle.Value
end)
