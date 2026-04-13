local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "av", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    }
}


-- Data

local t = {
    autofarm = true,
    distance = 8
}


-- Variables

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local mainWorkspace = workspace.MainWorkspaceComponents
local Options = Library.Options


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
align.MaxVelocity = 500
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
    if t.autofarm then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    end
end)


-- Functions

function createElement(tab, elementType, id, data, callback)
    local element

    -- Criador dinâmico
    if elementType == "Toggle" then
		element = tab:CreateToggle(id, data)
	elseif elementType == "Paragraph" then
		element = tab:CreateParagraph(id, data)
	elseif elementType == "Button" then
		element = tab:CreateButton(data)
	elseif elementType == "Dropdown" then
		element = tab:CreateDropdown(id, data)
    elseif elementType == "Input" then
        element = tab:CreateInput(id, data)
	end

    if not element then
        warn("Failed to create element:", elementType, id)
        return nil
    end

    -- Salva global
    if id and elementType ~= "Paragraph" then
        UIElements[id] = element
    end

    -- Auto OnChanged
    if callback and element.OnChanged then
        element:OnChanged(function(...)
            callback(Options[id], ...)
        end)
    end

    return element
end

function noClip()
    for i,v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

function setAligns(a)
    if a then
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    else
        align.Attachment0 = nil
        orient.Attachment0 = nil
    end
end

function checkAlive(enemy)
    local returner = false

    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
        returner = true
    end

    return returner
end

function getEnemy()
    local returner

    for i,v in pairs(mainWorkspace.Living:GetChildren()) do
        if v.Name ~= plr.Name and checkAlive(v) then
            returner = V
            break
        end
    end

    return returner
end

function autofarm()
    setAligns(t.autofarm)

    local enemy
    local posY = -t.distance
    local cfAng = 90

    while t.autofarm do task.wait()
        if mainWorkspace.FX:FindFirstChild("WaveSilo") and mainWorkspace.FX:FindFirstChild("Marker") then
            part.CFrame = mainWorkspace.FX:FindFirstChild("Marker").CFrame
        end

        if enemy and checkAlive(enemy) then
            noClip()

            part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,posY,0)) * CFrame.Angles(math.rad(cfAng),0,0)

            for i=1,4 do
                game:GetService("VirtualInputManager"):SendKeyEvent(true, tostring(i), false, game)
            end
            game.ReplicatedStorage.Remotes.Input:FireServer(nil,Enum.UserInputType.MouseButton1,nil,{holdingControl = false})
        else
            enemy = getEnemy()
        end
    end
end


-- Code

createElement(Tabs.Main, "Toggle", "AutoFarmToggle", {Title = "Auto Farm", Default = false}, function(self)
    t.autofarm = self.Value

    autofarm()
end)

createElement(Tabs.Main, "Input", "InputDistance", {Title = "Distance", Default = tostring(t.distance), Placeholder = "Number", Numeric = true, Finished = true, Callback = function(value)
    t.distance = tonumber(value)
end})
