local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "sp", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1500, 900), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    AutoFarm = Window:CreateTab{
        Title = "AutoFarm",
        Icon = "phosphor-users-bold"
    }
}

local noSave = {}
local t = {
    autofarm = false,
    autoboss = false,
    autoloopswords = false,
    autoloopmelees = false,
    autolooppowers = false,
    distance = 8,
    selectedEnemy = "asdasdas",
    selectedSwords = {},
    selectedMelees = {},
    selectedPowers = {},
    selectedBosses = {}
}


-- Variables

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local allBosses = {}
local Options = Library.Options
local UIElements = {}


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
align.MaxVelocity = 125
align.Responsiveness = 200
align.Attachment1 = part.Attachment

local orient = Instance.new("AlignOrientation", part)
orient.MaxTorque = math.huge
orient.Responsiveness = 200
orient.Attachment1 = part.Attachment

plr.CharacterAdded:Connect(function(cha)
    char = cha
    align.Attachment0 = nil
    orient.Attachment0 = nil
end)


-- Functions

function createElement(tab, elementType, id, data, callback)
    local element

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

    if id and elementType ~= "Paragraph" then
        UIElements[id] = element
    end

    if callback and element.OnChanged then
        element:OnChanged(function(...)
            callback(Options[id], ...)
        end)
    end

    return element
end

function setAligns(a)
    pcall(function()
        if a then
            align.Attachment0 = char.HumanoidRootPart.RootAttachment
            orient.Attachment0 = char.HumanoidRootPart.RootAttachment
        else
            align.Attachment0 = nil
            orient.Attachment0 = nil
        end
    end)
end

function getClosestIsland(enemy)
    local distance = math.huge
    local toTp
    local spawnCrystal

    for i,v in pairs(workspace:GetChildren()) do
        if v.Name:match("Island") and v:IsA("Folder") then
            local dis
            local nspc
            for _,spawnp in pairs(v:GetChildren()) do if spawnp.Name:match("SpawnPointCrystal") then nspc = spawnp dis = (spawnp:GetPivot().Position - enemy:GetPivot().Position).Magnitude end end

            if dis < distance then
                toTp = v
                distance = dis
                spawnCrystal = nspc
            end
        end
    end

    local e,_ = string.gsub(spawnCrystal.Name, "SpawnPointCrystal_", "")
    --[[for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.TeleportUI.MainFrame.Frame.Content.Holder:GetChildren()) do
        if v.Name:match(e) then
            e,_ = v.Name:gsub("Teleport_","")
            break
        end
    end]]

    return e, distance, spawnCrystal
end

function checkAlive(enemy)
    if enemy and typeof(enemy) == "Instance" and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
        return true
    end
    return false
end

function noClip()
    for i,v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

function getEnemy(bool, getAll)
    local returner, a, b, c = nil, nil, nil, nil

    if bool == "autoboss" then
        returner = allBosses

        for i,v in pairs(workspace.NPCs:GetChildren()) do
            if checkAlive(v) and v:FindFirstChild("Boss") and table.find(t.selectedBosses, v.Name) and not getAll then
                returner = v
                a, b, c = getClosestIsland(v)
                break
            elseif checkAlive(v) and v:FindFirstChild("Boss") and getAll then
                if not table.find(returner, v.Name) then
                    table.insert(returner, v.Name)
                end
            end
        end

        allBosses = returner
    elseif bool == "autofarm" then
        returner = {}

        for i,v in pairs(workspace.NPCs:GetChildren()) do
            if checkAlive(v) and v.Name:match(t.selectedEnemy) and not getAll then
                returner = v
                a, b, c = getClosestIsland(v)
                break
            elseif checkAlive(v) and getAll then
                if not table.find(returner, v.Name) then
                    table.insert(returner, v.Name)
                end
            end
        end

    end

    return returner, a, b, c
end

function getDistance(enemy)

end

local isAutoFarming = false
function autofarm(bool)
    if isAutoFarming then return end
    isAutoFarming = true

    local enemy, islandName, distance, spawnCrystal = nil, nil, nil, nil
    local posY, cfAng = t.distance, -90
    local alreadySetSpawn = false

    while t[bool] do task.wait()
        if enemy and checkAlive(enemy) and (plr:DistanceFromCharacter(enemy:GetPivot().Position) <= (distance + 25) or plr:DistanceFromCharacter(spawnCrystal:GetPivot().Position) < 10) then
            local hasHuman = false
            
            setAligns(true)
            noClip()

            if not enemy:FindFirstChild("HumanoidRootPart") then
                part.CFrame = CFrame.new(enemy:GetPivot().Position + Vector3.new(0,posY,0)) * CFrame.Angles(math.rad(cfAng),0,0)
            else
                hasHuman = true
                part.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0,posY,0)) * CFrame.Angles(math.rad(cfAng),0,0)
            end

            if hasHuman and plr:DistanceFromCharacter(enemy.HumanoidRootPart.Position) < 15 then
                for i=1,4 do
                    game.ReplicatedStorage.AbilitySystem.Remotes.RequestAbility:FireServer(i, {ChargeTier = 3, HoldDuration = math.huge})
                end
                game.ReplicatedStorage.CombatSystem.Remotes.RequestHit:FireServer()
            end
        elseif enemy and checkAlive(enemy) then
            setAligns(false)

            repeat task.wait(.1)
                game:GetService("ReplicatedStorage").Remotes.TeleportToPortal:FireServer(islandName)
            until spawnCrystal.Parent:FindFirstChild("PortalPrompt", true)

            local prox = spawnCrystal:FindFirstChild("CheckpointPrompt", true)
                
            for i=1,3 do
                char:PivotTo(spawnCrystal:GetPivot())
                if prox then
                    fireproximityprompt(prox)
                end
                task.wait(.1)
            end

            print(enemy, islandName, distance, spawnCrystal)
            print(alreadySetSpawn, distance)
            print(plr:DistanceFromCharacter(enemy:GetPivot().Position))
            print(plr:DistanceFromCharacter(spawnCrystal:GetPivot().Position))
        else
            enemy, islandName, distance, spawnCrystal = getEnemy(bool)
        end
    end

    isAutoFarming = false
    setAligns(false)
end


-- Ui

-- AUTO BOSSES SECTION

createElement(Tabs.AutoFarm, "Paragraph", "Alignss", {Title = "Auto Bosses Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.AutoFarm, "Toggle", "autobossesToggle", {Title = "Auto Bosses", Default = t.autoboss}, function(self)
    t.autoboss = self.Value
    autofarm("autoboss")
end)

createElement(Tabs.AutoFarm, "Dropdown", "selectBossesDropdown", {Title = "Bosses To Kill", Multi = true, Searchable = true, FocusSearch = false, Values = getEnemy("autoboss", true), Default = t.selectedBosses}, function(self, val)
    local tab = {}

    for i,v in pairs(val) do
        table.insert(tab, i)
    end

    t.selectedBosses = tab
end)

createElement(Tabs.AutoFarm, "Button", nil, {Title = "Update Bosses List", Callback = function()
    UIElements.selectBossesDropdown:SetValues(getEnemy("autoboss", true))
end})


-- AUTOFARM SECTION

createElement(Tabs.AutoFarm, "Paragraph", "Alignss", {Title = "Auto Farm Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.AutoFarm, "Toggle", "autofarmToggle", {Title = "Auto Farm", Default = t.autofarm}, function(self)
    t.autofarm = self.Value
    autofarm("autofarm")
end)

createElement(Tabs.AutoFarm, "Dropdown", "selectEnemyDropdown", {Title = "Enemy To Hold", Searchable = true, FocusSearch = false, Values = getEnemy("autofarm", true), Default = t.selectedEnemy}, function(self, val)
    t.selectedEnemy = val
end)

createElement(Tabs.AutoFarm, "Button", nil, {Title = "Update Enemy List", Callback = function()
    UIElements.selectEnemyDropdown:SetValues(getEnemy("autofarm", true))
end})
