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

function getClaimEvents(var)
    local returner = {}

    local a = Remotes.CalendarEventService.RF.getEventState:InvokeServer()

    for i,v in pairs(a.events) do
        if v.missions then

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

createElement(Tabs.Misc, "Toggle", "toggleAntiAfk", {Title = "Anti Afk", Default = t.antiAfk}, function(self)
    t.antiAfk = self.Value
    antiAfk()
end)

createElement(Tabs.Misc, "Button", nil, {Title = "Boost Fps", Description = "", Callback = fpsBoost})


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
