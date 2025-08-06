local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "noitesss", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(530, 325), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local plr = game.Players.LocalPlayer
local char = plr.Character
local inv = plr.Inventory

local selectedWeapon = "Old Axe"
local selectedEnemy = "Bunny"

function remote(name, args)
    local rem = game.ReplicatedStorage.RemoteEvents:FindFirstChild(name)
    if rem then
        if rem:IsA("RemoteEvent") then
            rem:FireServer(unpack(args))
        else
            rem:InvokeServer(unpack(args))
        end
    end
end

function getSack()
    for _,v in pairs(inv:GetChildren()) do
        if string.find(v.Name, "Sack") then
            return v
        end
    end
end

local Weapons
function updateWeapons()
    local weapons = {}
    for i,v in pairs(inv:GetChildren()) do
        if v:GetAttribute("WeaponDamage") then
            table.insert(weapons, v.Name)
        end
    end
    Weapons:SetValues(weapons)
end

local Enemies
function updateEnemies()
    local enemies = {}
    for _,v in pairs(workspace.Characters:GetChildren()) do
        if not table.find(enemies, v.Name) then
            table.insert(v.Name)
        end
    end
    Enemies:SetValues(enemies)
end

--sack:GetAttribute("Capacity")

Weapons = Tabs.Main:CreateDropdown("ItemsList", {Title = "Items List", Values = {}, Multi = false, Default = "Old Axe",})
Weapons:OnChanged(function(Value)
    selectedWeapon = Value
end)
updateWeapons()

Enemies = Tabs.Main:CreateDropdown("EnemyList", {Title = "Enemy List", Values = {}, Multi = false, Default = "Bunny",})
Enemies:OnChanged(function(Value)
    selectedEnemy = Value
end)
updateEnemies()

local autoKillToggle = Tabs.Main:CreateToggle("autoKillToggle", {Title = "Auto Kill", Default = false})
autoKillToggle:OnChanged(function()
    _G.akt = Options.autoKillToggle.Value
    while _G.akt do task.wait()
        pcall(function()
            local mob = workspace.Characters:FindFirstChild(selectedEnemy)
            if mob then
                char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,12,0)
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                remote("EquipItemHandle", {"FireAllClients", inv[selectedWeapon]})
                remote("ToolDamageObject", {mob, inv[selectedWeapon], "30" .. tostring(plr.PlayerId), char.HumanoidRootPart.CFrame})
            end
        end)
    end
end)

workspace.Characters.ChildAdded:Connect(updateEnemies)
workspace.Characters.ChildRemoved:Connect(updateEnemies)
inv.ChildAdded:Connect(updateWeapons)
inv.ChildRemoved:Connect(updateWeapons)
