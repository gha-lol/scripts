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
    autofarm = false,
    distance = 8
}


-- Variables

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local mainWorkspace = workspace.MainWorkspaceComponents
local Retrying = false
local Options = Library.Options
local http = game:GetService("HttpService")
local UIElements = {}
local Before


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
        task.wait(1)
        align.Attachment0 = char.HumanoidRootPart.RootAttachment
        orient.Attachment0 = char.HumanoidRootPart.RootAttachment
    end
end)


-- Functions

function getData()
    return game.ReplicatedStorage.Remotes.ReturnData:InvokeServer()
end
Before = getData()

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
            returner = v
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

        noClip()

        if enemy and checkAlive(enemy) then
            part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,posY,0)) * CFrame.Angles(math.rad(cfAng),0,0)

            for i,v in pairs(plr.PlayerGui.Skills.Hotbar:GetChildren()) do
                if not table.find({"UIAspectRatioConstraint", "UIListLayout"}, v.Name) and not v.CooldownFrame:FindFirstChild("Value") then
                    game.ReplicatedStorage.Remotes.Input:FireServer(v.Name)
                end
            end
            game.ReplicatedStorage.Remotes.Input:FireServer(nil,Enum.UserInputType.MouseButton1,nil,{holdingControl = false})
        else
            enemy = getEnemy()
        end
    end
end

function sendWebhook(embed)
    local body = http:JSONEncode({
        ["content"] = "@everyone",
        ["embeds"] = {
            {
                ["title"] = embed.title or "a",
                ["description"] = embed.description or "b",
                ["type"] = "rich",
                ["color"] = embed.color or tonumber(0xffffff),
                ["fields"] = embed.fields,
                ["footer"] = {
                    ["text"] = embed.footer or "c"
                }
            }
        }
    })
    request({
        Body = body,
        Url = "https://discord.com/api/webhooks/1457194910506684625/mXXODUWh7Hs4u4lDdy36wZbrJlM7rbwlFdX652vt5GNfAov9rridFSdJ4BK5pr2-vWsO",
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"}
    })
end

local allScreens = {}
function blackScreen(val)
    if val then
        for _,v in pairs(allScreens) do v:Destroy() end
        local a = Instance.new("ScreenGui", plr.PlayerGui)
    		a.IgnoreGuiInset = true
    		local b = Instance.new("Frame", a)
    		b.Size = UDim2.new(2,0,2,0)
    		b.Position = UDim2.new(0,0,0,0)
    		b.BackgroundColor3 = Color3.new(0,0,0)
    		b.ZIndex = -100
        
        table.insert(allScreens, a)
    else
        for _,v in pairs(allScreens) do v:Destroy() end
    end
end


-- Retry

game.ReplicatedStorage.Remotes.Interface.OnClientEvent:Connect(function(tipo, tab)
    if tipo == "arenaResults" then
        task.wait(2)
        if tab.remote and not Retrying then
            Retrying = true
            tab.remote:FireServer("replay")
            task.wait(3)
            Retrying = false

            local newData = getData()

            for i,v in pairs(newData.Items) do
                local bamount = Before.Items[i] or 0
                if game.ReplicatedStorage.Items["Maruto Shippuden"]:FindFirstChild(i) and v > bamount then
                    sendWebhook({title = "Anime Voxel", description = "Obtained " .. i, footer = "You have " .. tostring(v) .. " now"})
                end
            end

            Before = newData
        end
    end
end)


-- Code

createElement(Tabs.Main, "Toggle", "AutoFarmToggle", {Title = "Auto Farm", Default = false}, function(self)
    t.autofarm = self.Value

    autofarm()
end)

createElement(Tabs.Main, "Input", "InputDistance", {Title = "Distance", Default = tostring(t.distance), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(value)
    t.distance = tonumber(value)
end})

createElement(Tabs.Main, "Toggle", "BlackScreenToggle", {Title = "Black Screen", Default = false}, function(self)
    blackScreen(self.Value)
end)
