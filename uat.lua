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

function getTitan(bool, whitelist)
    local returner
    local tab = {}
    local closest = 999999999
    
    for i,v in pairs(titansFolder:GetChildren()) do
        if bool then
            if checkAlive(v) and (v.Name == "Titan" or v.Name == whitelist) and plr:DistanceFromCharacter(v.Head.Position) < 100 then
                table.insert(tab, v)
            end
        else
            if checkAlive(v) and (v.Name == "Titan" or v.Name == whitelist) and plr:DistanceFromCharacter(v.HumanoidRootPart.Position) < closest then
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

function killTitans(titan, times)
    if titan and checkAlive(titan) then
        part.CFrame = titan.Head.CFrame * CFrame.new(0,10,0)
        
        for i,v in pairs(getTitan(true, titan.Name)) do
            killTitan(v, times)
        end
        task.wait(.05)
    else
        titan = getTitan()
    end
    return titan
end

function goToRockSafezone()
    local partToTp = nil
    local distance = 9999999999
    
    for i,v in pairs(workspace.RockSafezones:GetChildren()) do
        if plr:DistanceFromCharacter(v.CantHook.Position) < distance then
            distance = plr:DistanceFromCharacter(v.CantHook.Position)
            partToTp = v.CantHook
        end
    end
    
    part.CFrame = partToTp.CFrame
end

-- Script


--Main

if game.PlaceId ~= 6372960231 then

    titansFolder = workspace.Entities.Titans
        
    local autofarmToggle = Tabs.Main:CreateToggle("autofarmToggle", {Title = "Auto Farm", Default = false})
    autofarmToggle:OnChanged(function()
        _G.autofarm = Options.autofarmToggle.Value
        
        local titan
        if _G.autofarm then
            align.Attachment0 = char.HumanoidRootPart.RootAttachment
        else
            align.Attachment0 = nil
        end
        
        while _G.autofarm do task.wait()
            noClip()
            if titansFolder:FindFirstChild("Beast Titan") then
                if string.find(plr.PlayerGui.TitansLeftGui.TextLabel.Text, "Quick! ") or string.find(plr.PlayerGui.TitansLeftGui.TextLabel.Text, "Hide behind") or string.find(plr.PlayerGui.TitansLeftGui.TextLabel.Text, "Titans Left") then
                    if titansFolder["Beast Titan"]:FindFirstChild("Humanoid") and titansFolder["Beast Titan"].Humanoid:GetPlayingAnimationTracks()[1] and titansFolder["Beast Titan"].Humanoid:GetPlayingAnimationTracks()[1].Animation.AnimationId == "rbxassetid://13662705383" then
                        goToRockSafezone()
                        local started = tick()
                        repeat task.wait() noClip() until tick() - started >= 8.5
                    else
                        titan = killTitans(titan)
                    end
                else
                    killTitans(titansFolder["Beast Titan"], 600)
                end
            elseif titansFolder:FindFirstChild("ColossalTitan") then
                killTitan(titansFolder.ColossalTitan, 700)
                break
            elseif titansFolder:FindFirstChild("Female Titan") then
                killTitan(titansFolder["Female Titan"], 700)
                break
            else
                titan = killTitans(titan)
            end
        end
    end)
    
    Tabs.Main:CreateInput("InputSpeed", {Title = "Fly Speed", Default = tostring(align.MaxVelocity), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(value)
        align.MaxVelocity = tonumber(value)
    end})
end

-- MISC
