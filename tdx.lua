local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "tdx", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1500, 900), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    Auto = Window:CreateTab{
        Title = "Auto",
        Icon = "phosphor-users-bold"
    },
    Misc = Window:CreateTab{
        Title = "Misc",
        Icon = "phosphor-users-bold"
    },
    File = Window:CreateTab{
        Title = "File",
        Icon = "phosphor-users-bold"
    }
}


-- Data

local t = {
    autoClaimEventMission = false,
    selectedClaimEvent = "",

    webhookDrops = false,
    whDropsItems = {
        Items = false,
        Rerolls = false,
        Relics = false
    },
    whDropsRarity = {
        Boundless = false,
        Exclusive = false,
        Secret = false,
        Mythic = false
    },

    antiAfk = false
}


-- Variables

local plr = game.Players.LocalPlayer
local Options = Library.Options
local UIElements = {}
local Service = game:GetService("HttpService")
local Remotes = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services


-- Important

if isfile("tdx.json") then
    for i,v in pairs(Service:JSONDecode(readfile("tdx.json"))) do
        if typeof(v) == "table" then
            for k,l in pairs(v) do
                t[i][k] = l
            end
        else
            t[i] = v
        end
    end
end


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

function checkMissions(tab)
    local count = 0

    for _,_ in pairs(tab) do
        count += 1
    end

    if count > 0 then
        return true
    else
        return false
    end
end

function getClaimEvents(var)
    local returner = {}

    local a = Remotes.CalendarEventService.RF.getEventState:InvokeServer()

    for i,v in pairs(a.events) do
        if v.missions and checkMissions(v.missions) then

            if var == "claimable" then

                table.insert(returner,i)

            elseif var == "completed" and (i == t.selectedClaimEvent or t.selectedClaimEvent == "All") then
                
                if not returner[i] then returner[i] = {} end
                for k,l in pairs(v.missions) do
                    if l.completed and not l.claimed then
                        table.insert(returner[i],k)
                    end
                end

            end
            
        end
    end

    return returner
end

function autoClaim()
    while t.autoClaimEventMission do
            
        local missions = getClaimEvents("completed")
        
        for evento,missoes in pairs(missions) do
            for _,nome in pairs(missoes) do
                Remotes.CalendarEventService.RF.claimMission:InvokeServer(evento,nome)
            end
        end

        task.wait(60)

    end
end

function saveSettings()
    writefile("tdx.json", Service:JSONEncode(t))
end

function antiAfk()
    for _, connection in pairs(getconnections(plr.Idled)) do
        if t.antiAfk then
            if connection["Disable"] then
                connection["Disable"](connection)
            end
        else
            if connection["Enable"] then
                connection["Enable"](connection)
            end
        end
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
		end
	end
	for _, v in pairs(Lighting:GetDescendants()) do
		if v:IsA("PostEffect") then
			v.Enabled = false
		end
	end
end

function getTableIs(tab,var)
    local returner = {}

    for i,v in pairs(tab) do
        if var and v or not var then
            table.insert(returner,i)
        end
    end

    return returner
end

function sendWebhook(embed)
    local body = Service:JSONEncode({
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

function dropWebhook(items)
    if not items then return end

    local itemsToSend = {}
    local desc = ""

    if items.Rerolls and items.Rerolls > 0 and t.whDropsItems.Rerolls then
        desc = desc .. "**Rerolls:** " .. tostring(items.Rerolls)
    end

    if items.Relics and checkMissions(items.Relics) and t.whDropsItems.Relics then
        local jumpLine = "\n"
        if desc == "" then jumpLine = "" end

        desc = desc .. jumpLine .. "**Relics:**"

        for relic,values in pairs(items.Relics) do
            if t.whDropsRarity[values.Rarity] then
                desc = desc .. "\n" .. "* " .. relic .. ": " .. tostring(values.Amount)
                --itemsToSend[relic] = values.Amount or 1
            end
        end
    end

    for i,v in pairs(items) do
        local jumpLine = "\n"

        if desc == "" then jumpLine = "" end

        if typeof(v) == "table" and i ~= "Relics" and t.whDropsItems.Items then
            if t.whDropsRarity[v.Rarity] then
                if not desc:find("**Items:**") then
                    desc = desc .. jumpLine .. "**Items:**"
                end
                
                desc = desc .. "\n" .. "* " .. i .. ": " .. tostring(v.Amount)
                --itemsToSend[i] = v.Amount or 1
            end

        end
    end

    sendWebhook({title = "UTDX", description = desc, footer = ""})
end


-- Connections

if Remotes:FindFirstChild("WaveService") then
    Remotes.WaveService.RE.SendFinished.OnClientEvent:Connect(function(_,items,match)
        if items and match and t.webhookDrops then
            dropWebhook(items)
        end
    end)
end


-- Code

--     Main Tab



--     Auto Tab

createElement(Tabs.Auto, "Toggle", "toggleClaimEventMission", {Title = "Auto Event Mission Claim", Default = t.autoClaimEventMission}, function(self)
    t.autoClaimEventMission = self.Value

    if t.autoClaimEventMission then
        autoClaim()
    end
end)

local allClaimables = getClaimEvents("claimable"); table.insert(allClaimables, "All")
createElement(Tabs.Auto, "Dropdown", "dropdownClaimEventMission", {Title = "Select Event", Values = allClaimables, Default = t.selectedClaimEvent}, function(self, Value)
    t.selectedClaimEvent = Value
end)



--     Misc Tab

-- Global Section

createElement(Tabs.Misc, "Paragraph", "Aligned Paragraph", {Title = "Global Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Misc, "Toggle", "toggleAntiAfk", {Title = "Anti Afk", Default = t.antiAfk}, function(self)
    t.antiAfk = self.Value
    antiAfk()
end)

createElement(Tabs.Misc, "Button", nil, {Title = "Boost Fps", Description = "", Callback = fpsBoost})

-- Webhook Section

createElement(Tabs.Misc, "Paragraph", "Aligned Paragraph", {Title = "Drops Webhook Section", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Misc, "Toggle", "toggleDropsWebhook", {Title = "Webhook Drops", Default = t.webhookDrops}, function(self)
    t.webhookDrops = self.Value
end)

createElement(Tabs.Misc, "Dropdown", "dropdownSelectDropWebhook", {Title = "Select Items", Values = getTableIs(t.whDropsItems), Default = getTableIs(t.whDropsItems, true), Multi = true}, function(self, Value)
    for i,_ in pairs(t.whDropsItems) do
        t.whDropsItems[i] = Value[i] or false
    end
end)

createElement(Tabs.Misc, "Dropdown", "dropdownSelectDropWebhookRarity", {Title = "Select Rarity", Values = getTableIs(t.whDropsRarity), Default = getTableIs(t.whDropsRarity, true), Multi = true}, function(self, Value)
    for i,_ in pairs(t.whDropsRarity) do
        t.whDropsRarity[i] = Value[i] or false
    end
end)



--     File Tab

createElement(Tabs.File, "Button", nil, {Title = "Save Config", Description = "", Callback = saveSettings})

createElement(Tabs.File, "Button", nil, {Title = "Print Save Table", Description = "", Callback = function()
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



--[[ Loading Config

if isfile("tdx.json") then
    for i,v in pairs(Service:JSONDecode(readfile("tdx.json"))) do
        if typeof(v) == "table" then
            for k,l in pairs(v) do
                t[i][k] = l
            end
        else
            t[i] = v
        end
    end
end

UIElements.toggleClaimEventMission:SetValue(t.autoClaimEventMission)
UIElements.dropdownClaimEventMission:SetValue(t.selectedClaimEvent)]]
