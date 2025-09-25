local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "wl2", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    Teleport = Window:CreateTab{
        Title = "Teleport",
        Icon = "phosphor-users-bold"
    },
    Misc = Window:CreateTab{
        Title = "Misc",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local plr = game.Players.LocalPlayer
local rs = game.ReplicatedStorage

_G.autofarm = false
_G.autoquest = false
local moneyToGet = 0
local distance = 8
local selectedMob = "Demon"
local selectedQuest = "Quest Dummy 1"


-- MAIN

function getMob()
    local returner
    
    for i,v in pairs(workspace.CharactersAndNPCs:GetChildren()) do
        if v.Name == selectedMob and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            returner = v
            break
        end
    end
    
    return returner
end

function noClip()
    local stepped
    stepped = game:GetService('RunService').Stepped:Connect(function()
        if plr.Character.Humanoid.Health <= 0 then
            plr.Character.Humanoid:ChangeState(2)
        elseif _G.autofarm then
            plr.Character.Humanoid:ChangeState(11)
        else
            plr.Character.Humanoid:ChangeState(2)
            stepped:Disconnect()
        end
    end)
end

Tabs.Main:CreateInput("InputDistance", {Title = "Type Distance", Default = tostring(distance), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(Value)
    distance = value
end})

local mobsDropdown = Tabs.Main:CreateDropdown("mobsDropdown", {Title = "Mob List", Values = {}, Multi = false, Default = "",})
mobsDropdown:OnChanged(function(Value)
    selectedMob = Value
end)

Tabs.Main:CreateButton{Title = "Update Mob List", Description = "", Callback = function()
    local tabb = {}
    for i,v in pairs(workspace.CharactersAndNPCs:GetChildren()) do
        if not table.find(tabb, v.Name) then
            table.insert(tabb, v.Name)
        end
    end
    mobsDropdown:SetValues(tabb)
end}

local autofarmToggle = Tabs.Main:CreateToggle("autofarmToggle", {Title = "Auto Farm", Default = false})
autofarmToggle:OnChanged(function()
    _G.autofarm = Options.autofarmToggle.Value
    local mob
    
    if _G.autofarm then noClip() end
    
    while _G.autofarm do task.wait()
        if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            pcall(function()
                if plr.Character.EquippedItem.Value == "None" then
                    rs.Remotes.Sheath:FireServer(plr.Character, "Equip")
                end
                
                plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,-distance,0)
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                rs.Remotes.Attack:FireServer("M1", plr.Movesets.Sword.Value, false)
            end)
        else
            mob = getMob()
        end
    end
end)

local questsDropdown = Tabs.Main:CreateDropdown("questsDropdown", {Title = "Quest List", Values = {}, Multi = false, Default = "",})
questsDropdown:OnChanged(function(Value)
    selectedQuest = Value
end)

local questTab = {}
for i,v in pairs(workspace.TalkNPC:GetChildren()) do
    if v.Info.Type.Value == "QuestGiver" then
        table.insert(questTab, v.Name)
    end
end
questsDropdown:SetValues(questTab)

local autoQuestToggle = Tabs.Main:CreateToggle("autoQuestToggle", {Title = "Auto Quest", Default = false})
autoQuestToggle:OnChanged(function()
    _G.autoquest = Options.autoQuestToggle.Value
    
    while _G.autoquest do task.wait(.2)
        if plr.Quest.QuestName.Value == "None" then
            rs.Events.QuestTake:FireServer(selectedQuest)
        end
    end
end)

-- MISC

Tabs.Misc:CreateButton{Title = "Get All Items", Description = "", Callback = function()
    for i,v in pairs(plr.Inventory:GetChildren()) do
        rs.Remotes.Inventory:FireServer("buy", v, -1000000)
    end
end}

Tabs.Misc:CreateInput("InputMoney", {Title = "Money Amount", Default = "0", Placeholder = "Number", Numeric = true, Finished = false, Callback = function(Value)
    moneyToGet = value
end})

Tabs.Misc:CreateButton{Title = "Get Money", Description = "", Callback = function()
    rs.Events.GourdRemote.SuperLargeGourdBuy:FireServer({Price = {Value = -moneyToGet}})
end}
