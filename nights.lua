local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local Window = Library:CreateWindow{Title = "noitesss", SubTitle = "by gha", TabWidth = 160, Size = UDim2.fromOffset(1000, 750), Resize = true,MinSize = Vector2.new(470, 380),Acrylic = true,Theme = "Dark",MinimizeKey = Enum.KeyCode.Q}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    Items = Window:CreateTab{
        Title = "Items",
        Icon = "phosphor-users-bold"
    },
    Teleport = Window:CreateTab{
        Title = "Teleport",
        Icon = "phosphor-users-bold"
    }
}
local Options = Library.Options

local plr = game.Players.LocalPlayer
local char = plr.Character
local inv = plr.Inventory

local selectedWeapon = "Old Axe"
local selectedEnemy = "Bunny"
local selectedItem = ""
local selectedArmorTool = ""
local killDistance = 30
local itemsFolder = workspace.Items


-- FUNCTIONS

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
            table.insert(enemies, v.Name)
        end
    end
    Enemies:SetValues(enemies)
end

function removeTraps()
    for i,v in pairs(workspace.Map.Landmarks:GetChildren()) do
        if string.find(v.Name, "Trap") and v:FindFirstChild("TouchInterest",true) then
            v:FindFirstChild("TouchInterest",true):Destroy()
        end
    end
end

function bringItem(item, pos, tentativas)
    local lastPos = char.HumanoidRootPart.CFrame
    char:PivotTo(item:GetPivot())
    task.wait(.1)
    char.HumanoidRootPart.CFrame = lastPos
    
    local dragging = item:FindFirstChild("DraggingAttachment", true)
    if dragging then
        remote("RequestStartDraggingItem", {item})

        local align = Instance.new("AlignPosition")
        align.Parent = dragging.Parent
        align.Mode = Enum.PositionAlignmentMode.OneAttachment
        align.Attachment0 = dragging
        align.Responsiveness = 99e99
        align.MaxForce = 99e99
        align.MaxVelocity = 99e99
        align.MaxAxesForce = Vector3.new(999e999, 999e999, 999e999)
        align.Position = pos

        task.delay(.5, function()
            remote("RequestStartDraggingItem", {item})
            task.wait(3)
            align.Responsiveness = 0
            align.MaxForce = 0
            align.MaxVelocity = 0
            align.MaxAxesForce = Vector3.new(0,0,0)
            align:Destroy()
            task.wait(.5)
            remote("StopDraggingItem", {item})
        end)
    end
end

local spawnedArmorsTools
local spawnedItems
function updateSpawnedItems()
    local armorsTools = {}
    local itemsTable = {}
    
    for i,v in pairs(itemsFolder:GetChildren()) do
        if (v:GetAttribute("Interaction") == "Armour" or v:GetAttribute("Interaction") == "Tool") and not table.find(armorsTools, v.Name) then
            table.insert(armorsTools, v.Name)
        elseif table.find(armorsTools, v.Name) == nil and table.find(itemsTable, v.Name) == nil then
            table.insert(itemsTable, v.Name)
        end
    end

    spawnedArmorsTools:SetValues(armorsTools)
    spawnedItems:SetValues(itemsTable)
end


-- CODIGO

Tabs.Main:CreateParagraph("Aligned Paragraph", {Title = "Auto Kill", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

Weapons = Tabs.Main:CreateDropdown("WeaponsList", {Title = "Weapon List", Values = {}, Multi = false, Default = "Old Axe",})
Weapons:OnChanged(function(Value)
    selectedWeapon = Value
end)
updateWeapons()

Enemies = Tabs.Main:CreateDropdown("EnemyList", {Title = "Enemy List", Values = {}, Multi = false, Default = "Bunny",})
Enemies:OnChanged(function(Value)
    selectedEnemy = Value
end)
updateEnemies()

local Slider = Tabs.Main:CreateSlider("Distance", {Title = "Distance", Description = "Distance from enemy", Default = killDistance, Min = 10, Max = 50, Rounding = 1, Callback = function(Value)
    killDistance = Value
end})

local Input = Tabs.Main:CreateInput("InputDistance", {Title = "Type Distance", Default = tostring(killDistance), Placeholder = "Number", Numeric = true, Finished = false, Callback = function(Value)
    killDistance = Value
    Slider:SetValue(Value)
end})

local autoKillToggle = Tabs.Main:CreateToggle("autoKillToggle", {Title = "Auto Kill", Default = false})
autoKillToggle:OnChanged(function()
    _G.akt = Options.autoKillToggle.Value
    while _G.akt do task.wait()
        pcall(function()
            local mob = workspace.Characters:FindFirstChild(selectedEnemy)
            if mob then
                char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,killDistance,0)
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                remote("EquipItemHandle", {"FireAllClients", inv[selectedWeapon]})
                remote("ToolDamageObject", {mob, inv[selectedWeapon], "2_" .. tostring(plr.UserId), char.HumanoidRootPart.CFrame})
            end
        end)
    end
end)

Tabs.Main:CreateParagraph("Aligned Paragraph2", {Title = "Auto Campfire", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local autoUpCampfire = Tabs.Main:CreateToggle("autoUpCampfire", {Title = "Auto Upgrade Campfire", Default = false})
autoUpCampfire:OnChanged(function()
    _G.auc = Options.autoUpCampfire.Value
        
    while _G.auc do task.wait()
        local finished = false
        removeTraps()
            
        repeat task.wait()
            local foundItems = 0
            for i,v in pairs(itemsFolder:GetChildren()) do
                if (v.Name == "Coal" or v.Name == "Fuel Canister" or v.Name == "Oil Barrel") and v:FindFirstChildWhichIsA("BasePart") then
                    foundItems += 1
                    if getSack():GetAttribute("Capacity") > #plr.ItemBag:GetChildren() then
                        pcall(function()
                            char.HumanoidRootPart.CFrame = v:FindFirstChildWhichIsA("BasePart").CFrame
                            task.wait(0.2)
                            remote("RequestBagStoreItem", {getSack(), v})
                            task.wait(0.2)
                        end)
                    else
                        finished = true
                    end
                end
            end
            if foundItems == 0 then finished = true end
        until finished

        local droppedTable = {}
        char.HumanoidRootPart.CFrame = workspace.Map.Campground.MainFire.Center.CFrame
        task.wait(.5)
        for i,v in pairs(plr.ItemBag:GetChildren()) do
            if v.Name == "Coal" or v.Name == "Fuel Canister" then
                char.HumanoidRootPart.CFrame = workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0,4,0)
                task.wait(.2)
                table.insert(droppedTable, v)
                remote("RequestBagDropItem", {getSack(), v})
            end
        end
        for _,v in pairs(droppedTable) do
            remote("RequestBurnItem",{workspace.Map.Campground.MainFire, v})
        end
        task.wait(.1)
    end

    pcall(function()
        char.HumanoidRootPart.CFrame = workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0,10,0)
    end)
end)

Tabs.Main:CreateParagraph("Aligned Paragraph3", {Title = "Kill Aura", Content = "Uses weapon selected on Auto Kill", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

local killAuraToggle = Tabs.Main:CreateToggle("killAuraToggle", {Title = "Kill Aura", Default = false})
killAuraToggle:OnChanged(function()
    _G.katt = Options.killAuraToggle.Value
    while _G.katt do task.wait()
        for i,v in pairs(workspace.Characters:GetChildren()) do
            local part = v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
            if part and plr:DistanceFromCharacter(part.Position) <= 50 and not string.find(v.Name, "Lost Child") then
                remote("EquipItemHandle", {"FireAllClients", inv[selectedWeapon]})
                remote("ToolDamageObject", {v, inv[selectedWeapon], "2_" .. tostring(plr.UserId), part.CFrame})
            end
        end
    end
end)


-- ITEMS TAB

Tabs.Items:CreateButton{Title = "Get All Lost Children", Description = "", Callback = function()
    for i,v in pairs(workspace.Characters:GetChildren()) do
        if string.find(v.Name, "Lost Child") then
            char:PivotTo(v:GetPivot())
            task.wait(.2)
            remote("RequestBagStoreItem", {getSack(), v})
            task.wait(.2)
        end
    end
    char.HumanoidRootPart.CFrame = workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0,10,0)
end}

Tabs.Items:CreateButton{Title = "Open All Chests", Description = "", Callback = function()
    for i,v in pairs(itemsFolder:GetChildren()) do
        if string.find(v.Name, "Chest") and v:FindFirstChild("Main") then
            char:PivotTo(v:GetPivot())
            task.wait(.2)
            remote("RequestOpenItemChest",{v})
            task.wait(.2)
        end
    end
    char.HumanoidRootPart.CFrame = workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0,10,0)
end}

Tabs.Items:CreateButton{Title = "Get All Ammo", Description = "", Callback = function()
    for i,v in pairs(itemsFolder:GetChildren()) do
        if string.find(v.Name, " Ammo") then
            char:PivotTo(v:GetPivot())
            task.wait(.2)
            remote("RequestConsumeItem", {v})
            task.wait(.2)
        end
    end

    char.HumanoidRootPart.CFrame = workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0,10,0)
end}

Tabs.Items:CreateParagraph("Aligned Paragraph3", {Title = "Armors/Weapons Only", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

spawnedArmorsTools = Tabs.Items:CreateDropdown("ArmorsToolsList", {Title = "Armors/Weapons List", Values = {}, Multi = false, Default = "",})
spawnedArmorsTools:OnChanged(function(Value)
    selectedArmorTool = Value
end)

Tabs.Items:CreateButton{Title = "Teleport to Armor/Weapon", Description = "", Callback = function()
    char:PivotTo(itemsFolder[selectedArmorTool]:GetPivot())
end}
Tabs.Items:CreateButton{Title = "Equip Armor/Weapon", Description = "", Callback = function()
    local armorTool = itemsFolder:FindFirstChild(selectedArmorTool)

    if armorTool then
        char:PivotTo(armorTool:GetPivot())
        task.wait(.2)
        if armorTool:GetAttribute("Interaction") == "Armour" then
            remote("RequestEquipArmour", {armorTool})
        else
            remote("RequestHotbarItem", {armorTool})
        end
        task.wait(.2)
        char.HumanoidRootPart.CFrame = workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0,10,0)
    end
end}
Tabs.Items:CreateButton{Title = "Bring Armor/Weapon", Description = "", Callback = function()
    local item = itemsFolder:FindFirstChild(selectedArmorTool)
        
    if item then
        bringItem(item, char.HumanoidRootPart.Position)
    end
end}
Tabs.Items:CreateButton{Title = "Bring All Armors/Weapons", Description = "", Callback = function()
    for i,v in pairs(itemsFolder:GetChildren()) do
        if v.Name == selectedArmorTool then
            bringItem(v, char.HumanoidRootPart.Position)
            task.wait(.1)
        end
    end
end}

Tabs.Items:CreateParagraph("Aligned Paragraph4", {Title = "Items Only", Content = "", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})

spawnedItems = Tabs.Items:CreateDropdown("ItemsList", {Title = "Items List", Values = {}, Multi = false, Default = "",})
spawnedItems:OnChanged(function(Value)
    selectedItem = Value
end)
updateSpawnedItems()

Tabs.Items:CreateButton{Title = "Teleport to Item", Description = "", Callback = function()
    char:PivotTo(itemsFolder[selectedItem]:GetPivot())
end}
Tabs.Items:CreateButton{Title = "Store Item", Description = "", Callback = function()
    local item = itemsFolder:FindFirstChild(selectedItem)

    if item then
        char:PivotTo(item:GetPivot())
        task.wait(.2)
        remote("RequestBagStoreItem", {getSack(), item})
        task.wait(.2)
        char.HumanoidRootPart.CFrame = workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0,10,0)
    end
end}
Tabs.Items:CreateButton{Title = "Bring Item", Description = "", Callback = function()
    local item = itemsFolder:FindFirstChild(selectedItem)
        
    if item then
        bringItem(item, char.HumanoidRootPart.Position)
    end
end}
Tabs.Items:CreateButton{Title = "Bring All Items", Description = "", Callback = function()
    for i,v in pairs(itemsFolder:GetChildren()) do
        if v.Name == selectedItem then
            bringItem(v, char.HumanoidRootPart.Position)
            task.wait(.2)
        end
    end
end}


-- TELEPORT

local selectedTp = "Stronghold"
local teleDropdown
teleDropdown = Tabs.Teleport:CreateDropdown("tpBruh", {Title = "Places", Values = {}, Multi = false, Default = selectedTp,})
teleDropdown:OnChanged(function(Value)
    selectedTp = Value
end)

Tabs.Teleport:CreateButton{Title = "Teleport to Place", Description = "", Callback = function()
    char:PivotTo(workspace.Map.Landmarks[selectedTp]:GetPivot())
end}

Tabs.Teleport:CreateButton{Title = "Update Places", Description = "", Callback = function()
    local tabb = {}
    for i,v in pairs(workspace.Map.Landmarks:GetChildren()) do
        table.insert(tabb, v.Name)
    end
    teleDropdown:SetValue(tabb)
end}

spawn(function()
    while task.wait(1) do
        updateEnemies()
        updateSpawnedItems()
    end
end)
inv.ChildAdded:Connect(updateWeapons)
inv.ChildRemoved:Connect(updateWeapons)
Window:SelectTab(1)
