local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "ar", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options
local Remotes = game.ReplicatedStorage.Remotes

local lastUnits = {}

local fuseDropdown1
local fuseDropdown2
local selectedMainFuse
local selectedFodderFuse

-- Functions

function updateAllDropdowns()
    fuseDropdown1:SetValues(lastUnits)
    fuseDropdown2:SetValues(lastUnits)
end

function addList(unit)
    if not table.find(lastUnits, unit) then
        table.insert(lastUnits, unit)
        
        if #lastUnits > 5 then
            for i=2, #lastUnits do
                lastUnits[i-1] = lastUnits[i]
            end
            lastUnits[6] = nil
        end
        
        updateAllDropdowns()
    end
end


-- Hook

local namecall
namecall = hookmetamethod(game,"__namecall",function(self,...)
    local args = {...}
     local method = getnamecallmethod():lower()
        
    if self == Remotes.Unit.Lock and method == "fireserver" and not checkcaller() then
        --pcall(function()
            addList(args[1])
            print(args[1])
            print(lastUnits)
        --end)
        return namecall(self,...)
    end
    return namecall(self,...)
end)


-- Main

Tabs.Main:CreateButton{Title = "Clear Recent Units Table", Description = "", Callback = function()
    lastUnits = {}
    updateAllDropdowns()
end}

local parag
parag = Tabs.Main:CreateParagraph("Aligned Paragraph", {Title = "Fuse Unit", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

fuseDropdown1 = Tabs.Main:CreateDropdown("fuseDropdown1", {Title = "Main Unit", Values = {}, Multi = false, Default = "",})
fuseDropdown1:OnChanged(function(Value)
    selectedMainFuse = Value
end)

fuseDropdown2 = Tabs.Main:CreateDropdown("fuseDropdown2", {Title = "Fodder Unit", Values = {}, Multi = false, Default = "",})
fuseDropdown2:OnChanged(function(Value)
    selectedFodderFuse = Value
end)

Tabs.Main:CreateButton{Title = "Fuse Unit", Description = "", Callback = function()
    local tab = {}
    for i=1,999 do
        table.insert(tab, selectedFodderFuse)
    end
    
    for i=1,9999 do
        Remotes.Unit.Fuse:FireServer(selectedMainFuse, tab)
    end
end}
