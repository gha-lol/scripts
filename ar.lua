local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "ar", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Lobby",
        Icon = "phosphor-users-bold"
    },
    Auto = Window:CreateTab{
        Title = "Auto",
        Icon = "phosphor-users-bold"
    },
    Misc = Window:CreateTab{
        Title = "Misc",
        Icon = "phosphor-users-bold"
    }
}

local t = {
    selectedMainFuse = "",
    selectedFodderFuse = "",
    selectedStat = "Damage"
}


-- Variables

local plr = game.Players.LocalPlayer
local Options = Library.Options
local UIElements = {}
local Remotes = game.ReplicatedStorage:FindFirstChild("Remotes")
local gameStatus = workspace:FindFirstChild("GameStatus")

local lastUnits = {}
local lagRemotes = {
    Remotes.ClientDisplay,
    Remotes.Parent.ReturnSkill,
    Remotes.HitEffect
}


-- Functions

function updateAllDropdowns()
    UIElements.fuseDropdown1:SetValues(lastUnits)
    UIElements.fuseDropdown2:SetValues(lastUnits)
end

function addList(unit)
    if not table.find(lastUnits, unit) then
        table.insert(lastUnits, tostring(unit))
        
        --[[if #lastUnits > 5 then
            for i=2, #lastUnits do
                lastUnits[i-1] = lastUnits[i]
            end
            lastUnits[6] = nil
        end]]
        
        updateAllDropdowns()
    end
end

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

function card(vezes, a)
    local con = getconnections(game:GetService("ReplicatedStorage").Remotes.Card.Main.OnClientEvent)
    for i,v in pairs(con) do v:Disable() end

    for i=1,vezes do
        game:GetService("ReplicatedStorage").Remotes.Card.Main:FireServer("Vote",a, 1)
    end

    delay(5,function()
        for i,v in pairs(con) do v:Enable() end 
    end)
end

local allScreens = {}
for _,v in pairs(plr.PlayerGui:GetChildren()) do if v.Name == "bbbl" then table.insert(allScreens, v) end end
function blackScreen(bool)
    if bool then
        for _,v in pairs(allScreens) do v:Destroy() end

        local a = Instance.new("ScreenGui", plr.PlayerGui)
    		a.IgnoreGuiInset = true
            a.Name = "bbbl"
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


-- Hook

if game.PlaceId == 85535589075948 then
    local namecall
    namecall = hookmetamethod(game,"__namecall",function(self,...)
        local args = {...}
        local method = getnamecallmethod():lower()
        pcall(function()
            if not checkcaller() and self == Remotes.Unit.Lock and method == "fireserver" then
                if not table.find(lastUnits, args[1]) then
                    table.insert(lastUnits, args[1])
                end
            end
        end)
        return namecall(self,...)
    end)
end



-- Main / Lobby

createElement(Tabs.Main, "Paragraph", "AlignedParagraph", {Title = "Fuse Unit", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

createElement(Tabs.Main, "Dropdown", "fuseDropdown1", {Title = "Main Unit", Values = {}, Multi = false, Default = ""}, function(self, Value)
    t.selectedMainFuse = Value
end)

createElement(Tabs.Main, "Dropdown", "fuseDropdown2", {Title = "Fodder Unit", Values = {}, Multi = false, Default = ""}, function(self, Value)
    t.selectedFodderFuse = Value
end)

createElement(Tabs.Main, "Dropdown", "statDropdown", {Title = "Stat", Values = {"Damage", "Cooldown", "Range"}, Multi = false, Default = "Damage"}, function(self, Value)
    t.selectedStat = Value
end)

createElement(Tabs.Main, "Button", nil, {Title = "Pass Stat", Description = "", Callback = function()
    spawn(function()
        for i=1,1000 do
            Remotes.StatTransfer.Transfer:FireServer(t.selectedFodderFuse, t.selectedMainFuse, {t.selectedStat})
        end
    end)
end})

createElement(Tabs.Main, "Button", nil, {Title = "Fuse Unit", Description = "", Callback = function()
    local tab = {}
    for i=1,999 do
        table.insert(tab, t.selectedFodderFuse)
    end

    spawn(function()
        for i=1,9999 do
            Remotes.Unit.Fuse:FireServer(t.selectedMainFuse, tab)
        end
    end)
end})

createElement(Tabs.Main, "Button", nil, {Title = "Update Recent Units Table", Description = "", Callback = function()
    updateAllDropdowns()
end})

createElement(Tabs.Main, "Button", nil, {Title = "Clear Recent Units Table", Description = "", Callback = function()
    lastUnits = {}
    updateAllDropdowns()
end})



-- Game / Playing

local consAutoWitch = {}
createElement(Tabs.Auto, "Toggle", "AutoWitchToggle", {Title = "Auto Witch Inf", Default = false}, function(self)
    for _,v in pairs(consAutoWitch) do v:Disconnect() end

    if self.Value then
        local alreadyGotCards = false

        local con1 = gameStatus.GospelPageEarn.Changed:Connect(function()
            if gameStatus.GospelPageEarn.Value ~= 0 then
                Remotes.Replay:FireServer("Setting")
            end
        end)

        local con2 = Remotes.ChangeRewardFrame.OnClientEvent:Connect(function()
            task.wait(.5)
            alreadyGotCards = false
            Remotes.Replay:FireServer()
        end)

        local con3 = gameStatus.Wave.Changed:Connect(function()
            if gameStatus.Wave.Value >= 3 and not alreadyGotCards then
                alreadyGotCards = true

                card(500, "Distorted Timing III")
                task.wait(6)
                card(1000, "Swift Notes III")
            end
        end)

        table.insert(consAutoWitch, con1)
        table.insert(consAutoWitch, con2)
        table.insert(consAutoWitch, con3)
    end
end)



-- Misc / Other

createElement(Tabs.Misc, "Toggle", "NoLagToggle", {Title = "Less Lag", Default = false}, function(self)
    for _,v in pairs(lagRemotes) do
        for _,con in pairs(getconnections(v.OnClientEvent)) do
            if self.Value then
                con:Disable()
            else
                con:Enable()
            end
        end
    end
end)

createElement(Tabs.Misc, "Toggle", "BlackscreenToggle", {Title = "Blackscreen", Default = false}, function(self)
    blackScreen(self.Value)
end)
