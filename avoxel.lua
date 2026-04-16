local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "av", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1500, 900), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

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


-- Data

local t = {
    autofarm = false,
    distance = 8,
    waveToReset = 10,
    position = "Down",
    noVfx = false,
    resetWave = false,
    selectedSkills = {"1", "2", "3", "4"}
}


-- Variables

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local whitelisted = {"arenaWaypoint", "deathFX", "notification", "itemFX", "expGained"}
local mainWorkspace = workspace.MainWorkspaceComponents
local globalEnemy
local Retrying = false
local Options = Library.Options
local http = game:GetService("HttpService")
local UIElements = {}
local deadNpcs = {}
local skillsRemoteDmg = {}
local Before
local noVfxCon
local wave = 1


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

function returnMouseFunction()
    local hitPos
    local hit
    local cameraCf

    if globalEnemy and globalEnemy:FindFirstChild("HumanoidRootPart") then
        hitPos = globalEnemy.HumanoidRootPart.Position
        hit = globalEnemy.HumanoidRootPart.CFrame
        cameraCf = CFrame.new(globalEnemy.HumanoidRootPart.Position + Vector3.new(0,7,0), globalEnemy.HumanoidRootPart.Position)
    else
        local pos = char.HumanoidRootPart.CFrame * CFrame.new(0,0,-t.distance)
        local cf = CFrame.new(pos.Position, pos.Position + char.HumanoidRootPart.CFrame.LookVector * (t.distance + 1))
        hitPos = cf.Position
        hit = cf
        cameraCf = CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + char.HumanoidRootPart.CFrame.LookVector * (t.distance + 1))
    end

    return hitPos, hit, cameraCf
end

plr.CharacterAdded:Connect(function(cha)
    char = cha
    if t.autofarm then
        task.spawn(function()
            task.wait(2)
            part.CFrame = char.HumanoidRootPart.CFrame
            align.Attachment0 = char.HumanoidRootPart.RootAttachment
            orient.Attachment0 = char.HumanoidRootPart.RootAttachment
        end)
    end
    task.wait(1)
    game.ReplicatedStorage.Remotes.ReturnMouse.OnClientInvoke = returnMouseFunction
end)
game.ReplicatedStorage.Remotes.ReturnMouse.OnClientInvoke = returnMouseFunction

for _, connection in pairs(getconnections(plr.Idled)) do
    if connection["Disable"] then
        connection["Disable"](connection)
    elseif connection["Disconnect"] then
        connection["Disconnect"](connection)
    end
end


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
    for i,v in pairs(char:GetDescendants()) do
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

    if not table.find(deadNpcs, enemy) and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
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
    local resettingWave
    local posY = -t.distance
    local cfAng = 90
    local noEnemyTick = tick()

    while t.autofarm do task.wait()
        if t.position == "Top" then
            posY = t.distance
            cfAng = -90
        else
            posY = -t.distance
            cfAng = 90
        end

        task.spawn(noClip)

        if plr.PlayerGui:FindFirstChild("ResultsScreenNew") and plr.PlayerGui:FindFirstChild("ResultsScreenNew").Enabled then
            noEnemyTick = tick()
            local p = mainWorkspace.FX:FindFirstChild("RemoteEvent")
            if p then task.wait(4) p:FireServer("replay") task.wait(2) end
        end

        if t.resetWave and not resettingWave and wave >= t.waveToReset then
            resettingWave = true
            task.spawn(function()
                if char and char:FindFirstChild("Torso") then
                    char.Torso:Destroy()
                    plr.CharacterAdded:Wait()
                    repeat task.wait() until wave == 1
                end
                resettingWave = false
            end)
        elseif not t.resetWave then
            resettingWave = false
        end

        if not resettingWave and enemy and checkAlive(enemy) then
            noEnemyTick = tick()
            part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,posY,0)) * CFrame.Angles(math.rad(cfAng),0,0)

            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end

            for _,v in pairs(skillsRemoteDmg) do
                v:FireServer(enemy.HumanoidRootPart.CFrame)
            end

            for i,v in pairs(plr.PlayerGui.Skills.Hotbar:GetChildren()) do
                if not table.find({"UIAspectRatioConstraint", "UIListLayout"}, v.Name) and not v.CooldownFrame:FindFirstChild("Value") and table.find(t.selectedSkills, v.KeyText.Text:match("%[(%d+)%]")) then
                    game.ReplicatedStorage.Remotes.Input:FireServer(v.Name)
                end
            end
            game.ReplicatedStorage.Remotes.Input:FireServer(nil,Enum.UserInputType.MouseButton1,nil,{holdingControl = false})
        else
            if tick() - noEnemyTick >= 25 then
                if char and char:FindFirstChild("Torso") then
                    char.Torso:Destroy()
                    task.wait(1)
                end
            elseif tick() - noEnemyTick >= 15 then
                local map
                for i,v in pairs(mainWorkspace.Map:GetChildren()) do if v:FindFirstChild("spawnLocations") then map = v break end end
                
                setAligns(false)
                for i,v in pairs(map.spawnLocations:GetChildren()) do
                    char.HumanoidRootPart.CFrame = v.CFrame
                    task.wait(.3)
                end
                setAligns(true)
            end

            enemy = getEnemy()
            globalEnemy = enemy
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
for i,v in pairs(plr.PlayerGui:GetChildren()) do if v.Name == "blackScreeis" then table.insert(allScreens, v) end end
function blackScreen(val)
    if val then
        for _,v in pairs(allScreens) do v:Destroy() end
        local a = Instance.new("ScreenGui", plr.PlayerGui)
            a.Name = "blackScreeis"
            a.ResetOnSpawn = false
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

function fpsBoost()
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildWhichIsA("Terrain")
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	Lighting.FogStart = 9e9
	settings().Rendering.QualityLevel = 1
	for _, v in pairs(game:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CastShadow = false
			v.Material = "Plastic"
			v.Reflectance = 0
			v.BackSurface = "SmoothNoOutlines"
			v.BottomSurface = "SmoothNoOutlines"
			v.FrontSurface = "SmoothNoOutlines"
			v.LeftSurface = "SmoothNoOutlines"
			v.RightSurface = "SmoothNoOutlines"
			v.TopSurface = "SmoothNoOutlines"
		elseif v:IsA("Decal") then
			v.Transparency = 1
			v.Texture = ""
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		end
	end
	for _, v in pairs(Lighting:GetDescendants()) do
		if v:IsA("PostEffect") then
			v.Enabled = false
		end
	end
end


-- Connections

-- Retry
game.ReplicatedStorage.Remotes.Interface.OnClientEvent:Connect(function(tipo, tab)
    if tipo == "arenaResults" then
        --task.wait(4)
        if tab.remote and not Retrying then
            Retrying = true
            --tab.remote:FireServer("replay")
            task.wait(2)
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
    elseif tipo == "displayWave" then
        wave = tab[1] or 1
    end
end)

-- FXs
game.ReplicatedStorage.Remotes.FX.OnClientEvent:Connect(function(tipo, tabbb)
    if tipo == "arenaWaypoint" and tabbb.waypoint then
        setAligns(false)
        local tt = tick()

        repeat task.wait()
            char.HumanoidRootPart.CFrame = tabbb.waypoint.CFrame
        until tick() - tt > 2 or clearedTick and tick() - clearedTick <= .5

        if t.autofarm then
            setAligns(true)
        end
        clearedTick = nil
    elseif tipo == "arenaWaypoint" and tabbb.clearWaypoints then
        clearedTick = tick()
    elseif tipo == "deathFX" then
        table.insert(deadNpcs, tabbb.model)
    end
end)

-- Hookfunction
local reg = getreg()
for _,v in pairs(reg) do
    if type(v) == "function" then
        local info = getinfo(v)
        if info.name == "requireEffectModule" then
            local hooook
            hooook = hookfunction(info.func, newcclosure(function(tipo, tabb)
                if tipo == "expOrbs" then

                    for i=1,tabb.amount do
                        if tabb.remote then
                            tabb.remote:FireServer()
                            task.wait(.2)
                        end
                    end
                    return nil

                elseif not table.find(whitelisted, tipo) and t.noVfx then

                    if tabb.model == char and tabb.remote then
                        table.insert(skillsRemoteDmg, tabb.remote)
                    end
                    return nil

                end
                return hooook(tipo,tabb)
            end))
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

createElement(Tabs.Main, "Dropdown", "selectTopDown", {Title = "Farm Position", Values = {"Top", "Down"}, Multi = false, Default = t.position}, function(_, val)
    t.position = val
end)

createElement(Tabs.Main, "Dropdown", "selectedSkills", {Title = "Skills To Use", Values = {"1", "2", "3", "4"}, Multi = true, Default = t.selectedSkills}, function(_, val)
    local newSkills = {}

    for i,_ in pairs(val) do
        table.insert(newSkills, tostring(i))
    end
    
    t.selectedSkills = newSkills
end)

createElement(Tabs.Main, "Toggle", "ResetWaveToggle", {Title = "Reset Wave 10", Default = false}, function(self)
    t.resetWave = self.Value
end)

-- Misc Tab

createElement(Tabs.Misc, "Toggle", "BlackScreenToggle", {Title = "Black Screen", Default = false}, function(self)
    blackScreen(self.Value)
end)

createElement(Tabs.Misc, "Toggle", "noVfxToggle", {Title = "No Vfx", Default = false}, function(self)
    t.noVfx = self.Value
end)

createElement(Tabs.Misc, "Button", nil, {Title = "Boost Fps", Description = "", Callback = fpsBoost})
