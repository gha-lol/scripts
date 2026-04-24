local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "su", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1500, 900), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    File = Window:CreateTab{
        Title = "File",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options


--   Data

local t = {
    autoeaster = false
}
noSave = {noclip = false}


--   Variables

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local easterEggs = workspace.EasterEggs
local easterSpawns = workspace.EggSpawnPoints
local UIElements = {}
local eggBlacklist = {}
local http = game:GetService("HttpService")
local newChar = 0


--   Important

local platform = Instance.new("Part",workspace)
platform.Anchored = true
platform.Size = Vector3.new(10,2,10)
platform.CFrame = CFrame.new(char.HumanoidRootPart.Position + Vector3.new(0,20,0))
Instance.new("Attachment", platform)

local align = Instance.new("AlignPosition", platform)
align.MaxForce = 99e99
align.MaxVelocity = 1000
align.Responsiveness = 200
align.Attachment1 = platform.Attachment

plr.CharacterAdded:Connect(function(cha)
    newChar += 1
    char = cha

    if newChar > 1 then
        if t.autoeaster then
            align.Attachment0 = char:WaitForChild("HumanoidRootPart").RootAttachment
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if noSave.noclip then
        for i,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)


--   Functions

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

function saveData()
    writefile("standUprightData.json", http:JSONEncode(t))
end

function getAlreadyJoinedServers()
    if isfile("standUprightServers.json") then
        return http:JSONDecode(readfile("standUprightServers.json"))
    else
        return {}
    end
end

function serverHop()
    local alreadyJoined = getAlreadyJoinedServers()
    local servers = {}
	local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
	local body = http:JSONDecode(req)

	if body and body.data then
		for i, v in next, body.data do
			if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
				table.insert(servers, 1, v.id)
			end
		end
	end

	if #servers > 0 then
        queueonteleport('function loadScript(skip) if  _G.tickLoads and not skip then if tick() - _G.tickLoads < 10 then return end else _G.tickLoads = tick() end local s,e = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gha-lol/scripts/main/sur.lua",true))() end) if not s then task.wait(1) loadScript(true) end end loadScript()')
            
        local toTp

        for i,v in pairs(servers) do
            if not table.find(alreadyJoined, v) then
                toTp = v
                break
            end
        end

        if toTp then
            table.insert(alreadyJoined, game.JobId)
            table.insert(alreadyJoined, toTp)

            writefile("standUprightServers.json", http:JSONEncode(alreadyJoined))

            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, toTp, plr)
        else
            alreadyJoined = {}
            table.insert(alreadyJoined, game.JobId)

            writefile("standUprightServers.json", http:JSONEncode(alreadyJoined))

		    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
        end

        task.wait(10)
    end
end

function getEgg()
    local returner

    for i,v in pairs(easterEggs:GetChildren()) do
        if v.Name == "ActiveEgg" and not table.find(eggBlacklist, v) then
            returner = v
            break
        end
    end

    return returner
end

function autoEaster()
    local lastMsg = tick() - 11
    local lastEgg = tick() - 11
    local lastChanged = tick()

    local con; con = game:GetService("ReplicatedStorage").Events.ChatMessage.OnClientEvent:Connect(function(msg)
        if msg:match("You Recieved") then
            lastMsg = tick()
        end
    end)

    local con2; con2 = easterEggs.Eggs.Changed:Connect(function()
        lastChanged = tick()
    end)

    while t.autoeaster do task.wait()
        if easterEggs.Eggs.Value > 0 and easterEggs.Eggs.Value < 15 or #easterEggs:GetChildren() > 2 then
            if tick() - lastEgg > 10 then

                local egg  = getEgg()
                
                if egg then
                    fireclickdetector(egg.ClickDetector)
                    
                    local started = tick()
                    local finish = false
                    local other = false
                    local eend = false

                    task.spawn(function()
                        repeat task.wait()
                            pcall(function()
                                char.HumanoidRootPart.CFrame = CFrame.new(platform.Position + Vector3.new(0,3,0))
                                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                            end)
                        until eend or not t.autoeaster
                    end)

                    repeat task.wait()
                        if tick() - lastMsg <= .75 then
                            finish = true
                        elseif tick() - started >= 10 then
                            other = true
                        end
                    until finish or other

                    if finish then
                        lastEgg = tick()
                        table.insert(eggBlacklist, egg)
                        task.wait(1)
                    end
                    eend = true
                elseif tick() - lastChanged >= 90 then
                    serverHop()
                else
                    setAligns(true)
                    noSave.noclip = true

                    for i,v in pairs(easterSpawns:GetChildren()) do
                        if not t.autoeaster or easterEggs.Eggs.Value == 0 or easterEggs.Eggs.Value == 15 then break end
                        pcall(function()
                            platform.CFrame = CFrame.new(v.Position + Vector3.new(0,-37,0))
                            char.HumanoidRootPart.CFrame = CFrame.new(platform.Position + Vector3.new(0,3,0))

                            local started = tick()
                            task.spawn(function()
                                repeat task.wait()
                                    pcall(function()
                                        char.HumanoidRootPart.CFrame = CFrame.new(platform.Position + Vector3.new(0,3,0))
                                        char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                                    end)
                                until tick() - started >= 1.5 or not t.autoeaster
                            end)
                        end)

                        task.wait(1.5)

                        if getEgg() then
                            break
                        end
                    end
                end

            end
        else
            serverHop()
        end
    end

    con:Disconnect()
    con2:Disconnect()
end

function setAligns(a)
    pcall(function()
        if a then
            align.Attachment0 = char.HumanoidRootPart.RootAttachment
        else
            align.Attachment0 = nil
        end
    end)
end


--   Code

-- Main Tab

createElement(Tabs.Main, "Toggle", "easterToggle", {Title = "Auto Easter", Default = false}, function(self)
    t.autoeaster = self.Value

    if self.Value then
        autoEaster()
    else
        setAligns(false)
        noSave.noclip = false
    end
end)

createElement(Tabs.Main, "Button", nil, {Title = "Server Hop", Description = "", Callback = serverHop})


-- File Tab

createElement(Tabs.File, "Button", nil, {Title = "Save Data", Description = "", Callback = saveData})

createElement(Tabs.File, "Button", nil, {Title = "Print Data Table", Description = "", Callback = function()
    local function printTable(i,v, spc)
        local pp = v
        local isTab = false
        local spac = spc .. "  "

        if typeof(v) == "table" then pp = "" isTab = true end
        print(spac .. i .. ": " .. tostring(pp))

        if isTab then
            for k,l in pairs(v) do
                printTable(k,l,spac)
            end
        end
    end

    for i,v in pairs(t) do
        printTable(i,v, "")
    end
end})

--   Setting things up

if isfile("standUprightData.json") then
    for i,v in pairs(http:JSONDecode(readfile("standUprightData.json"))) do
        if typeof(v) == "table" then
            for k,l in pairs(v) do
                t[i][k] = l
            end
        else
            t[i] = v
        end
    end
end

game:GetService("ReplicatedStorage").Events.PressedPlay:FireServer()
task.wait(.5)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
char.Humanoid.Health = 0
task.wait(.75)

UIElements.easterToggle:SetValue(t.autoeaster)
Window:SelectTab(1)
