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

local titansFolder = workspace.Entities.Titans

_G.autofarm = false


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
align.MaxVelocity = 150
align.Responsiveness = 200
align.Attachment0 = char.HumanoidRootPart.RootAttachment
align.Attachment1 = part.Attachment


-- Functions

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
    
    for i,v in pairs(titansFolder:GetChildren()) do
        if bool then
            if checkAlive(v) and v.Name == "Titan" and plr:DistanceFromCharacter(v.HumanoidRootPart.Position) < 75 then
                table.insert(tab, v)
            end
        else
            if checkAlive(v) and v.Name == "Titan" then
                returner = v
                break
            end
        end
    end
    
    if bool then
        return tab
    else
        return returner
    end
end


-- Script


local autofarmToggle = Tabs.Main:CreateToggle("autofarmToggle", {Title = "Auto Farm", Default = false})
autofarmToggle:OnChanged(function()
    _G.autofarm = Options.autofarmToggle.Value
    
    local titan
    
    while _G.autofarm do task.wait()
        if titansFolder:FindFirstChild("Beast Titan") then
            
        elseif titansFolder:FindFirstChild("ColossalTitan") then
            killTitan(titansFolder.ColossalTitan, 700)
            break
        elseif titansFolder:FindFirstChild("Female Titan") then
            killTitan(titansFolder["Female Titan"], 700)
            break
        else
            if titan then
                part.CFrame = titan.Head.CFrame * CFrame.new(0,10,0)
                
                for i,v in pairs(getTitan(true)) do
                    killTitan(v)
                end
                task.wait(.08)
            else
                titan = getTitan()
            end
        end
    end
end)


-- MISC
