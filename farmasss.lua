local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/InfinitiveUI",true))()
local win = lib:CreateWindow("Farmassss",1,nil,nil)

local data = game.ReplicatedStorage.AllPlayerData[game.Players.LocalPlayer.Name]["Char Data"]

local tab1,name1 = win:CreateTab("Auto-Farm",function() end)
_G.ques = "Hero2"
tab1:CreateToggle("Auto-Farm",false,function(bool)
    spawn(function()
        _G.e = bool

        if game.Players.LocalPlayer.Character.LowerTorso:FindFirstChild("Root") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-32, 569, 158)
            wait(1)
            game.Players.LocalPlayer.Character.LowerTorso.Root:Destroy()
            wait(1)
        end
        local tp
        while _G.e do wait()
            if game.Players.LocalPlayer:FindFirstChild("Quest") and game.Players.LocalPlayer.Quest.QuestName.Value ~= _G.ques then
                game:GetService("ReplicatedStorage").questremote:FireServer("", true)
            end
            if _G.ques == "Hero2" then
                tp = CFrame.new(972, 73, -93)
            elseif _G.ques == "Side1" then
                tp = CFrame.new(306, 29, 1179)
            elseif _G.ques == "Side3" then
                tp = CFrame.new(-786, 17, 1090)
            elseif _G.ques == "Hero13" then
                tp = CFrame.new(306, 29, 1179)
            elseif _G.ques == "Hero18" then
                tp = CFrame.new(972, 73, -93)
            elseif _G.ques == "Side4" then
                tp = CFrame.new(-32, 569, 158)
            elseif _G.ques == "Villain14" then
                tp = CFrame.new(306, 29, 1179)
            end
            game:GetService("ReplicatedStorage").questremote:FireServer(_G.ques)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = tp
            wait(.6)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.QuestGivers[_G.ques].HumanoidRootPart.CFrame * CFrame.new(0,-12,0)
            wait(.4)
            fireproximityprompt(workspace.QuestGivers[_G.ques].HumanoidRootPart.ProximityPrompt)
        end
    end)
end)

tab1:CreateDropdown("Quest", {"Hero2", "Hero13", "Hero18", "Side1", "Side3", "Side4", "Villain14"},false,function(quest)
    _G.ques = quest
end)

local function get()
    local returner
    for i,v in pairs(game:GetService("Workspace").Characters:GetChildren()) do
        if game.Players:FindFirstChild(v.Name) == nil and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            returner = v
            break
        end
    end
    return returner
end

tab1:CreateToggle("Auto-Raid", false, function(bool)
    _G.autraid = bool

    if game.Players.LocalPlayer.Character.LowerTorso:FindFirstChild("Root") then
        game.Players.LocalPlayer.Character.LowerTorso.Anchored = true
        wait(1)
        game.Players.LocalPlayer.Character.LowerTorso.Root:Destroy()
    end

    local v
    while _G.autraid do wait()
        v = get()
        if v and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,4)
            game:GetService("ReplicatedStorage").Power:FireServer(nil, false, 1, false)
            game:GetService("ReplicatedStorage").Power:FireServer(nil, false, 2, false)
        end
    end
end)

local tab2,name2 = win:CreateTab("Personagem",function() end)
_G.pontos = 1
tab2:CreateSlider("Points",1,350,1,function(valor)
    _G.pontos = valor
end)

tab2:CreateDropdown("Converter Para", {"QuirkSpins", "RaceSpins", "QuirkLevel", "StaminaLevel", "DefenseLevel", "StrengthLevel", "WeaponLevel", "CurrentQuestStoryline"},false,function(stat)
    _G.convpara = stat
end)

local textbox1 = tab2:CreateTextbox("Converter Para","Converter Para")

textbox1:GetPropertyChangedSignal("Text"):Connect(function()
    _G.convpara = textbox1.Text
end)

tab2:CreateButton("Converter Points",function()
    if _G.convpara == "CurrentQuestStoryline" then
        local calc = 19 - data.CurrentQuestStoryline.Value
        if calc > 0 then
            for i=1, calc do
                game:GetService("ReplicatedStorage").AddPoint:FireServer(_G.convpara)
            end
        end
    else
        for i=1, _G.pontos do
            game:GetService("ReplicatedStorage").AddPoint:FireServer(_G.convpara)
        end
    end
end)

local tab3,name3 = win:CreateTab("Outros",function() end)

local textbox = tab3:CreateTextbox("Nome NPC","Nome NPC")

textbox:GetPropertyChangedSignal("Text"):Connect(function()
    _G.npcnome = textbox.Text
end)

tab3:CreateDropdown("Nome NPC lista", {"Hero1", "Hero2", "Hero3", "Hero4", "Hero5", "Hero6", "Hero7", "Hero8", "Hero9", "Hero10", "Hero11", "Hero12", "Hero13", "Hero14", "Hero15", "Hero16", "Hero17", "Hero18", "Hero19", "Side1", "Side2", "Side3", "Side4", "Side5"},false,function(quest)
    _G.npcnome = quest
end)

tab3:CreateButton("Pegar Quest e dar TP",function()
    game:GetService("ReplicatedStorage").questremote:FireServer(_G.npcnome)
    wait(.5)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.QuestMarkers[_G.npcnome].CFrame
end)

tab3:CreateButton("TP NPC",function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.QuestGivers[_G.npcnome].HumanoidRootPart.CFrame
end)

local tab4,name4 = win:CreateTab("Customizacao",function() end)

tab4:CreateButton("Roletar Raca",function()
    game:GetService("ReplicatedStorage").rollevent:FireServer("race")
end)

local tab5,name5 = win:CreateTab("Auto-Spin",function() end)

_G.eetab = {}

tab5:CreateToggle("Auto-Spin",false,function(bool)
    _G.sp = bool
    local cu
    local old
    local quirk = game.ReplicatedStorage.AllPlayerData[game.Players.LocalPlayer.Name]["Char Data"].Quirk
    while _G.sp do wait()
        if table.find(_G.eetab, quirk.Value) then _G.sp = false return end
        if _G.autobuyy == true and quirk.Parent.QuirkSpins.Value == 0 then game:GetService("ReplicatedStorage").SpinQuirk:FireServer("buy") end
        if quirk.Parent.QuirkSpins.Value > 0 then
            cu = tick()
            old = quirk.Value
            game:GetService("ReplicatedStorage").SpinQuirk:FireServer("spin", false)
            repeat wait() until quirk.Value ~= old or tick() - cu >= 8
            wait(1)
        end
    end
end)

tab5:CreateToggle("Auto-Buy Spin",false,function(bool)
    _G.autobuyy = bool
end)

local function msg(tit, tex)
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = tit,
        Text = tex,
        Duration = 8
    })
end

local function addTable(nomeda)
    local textoo = ""
    local textoo2 = ""

    if table.find(_G.eetab, nomeda) then
        for i,v in pairs(_G.eetab) do
            if v == nomeda then
                table.remove(_G.eetab, i)
                break
            end
        end
        textoo2 = "Removido"
    else
        table.insert(_G.eetab, nomeda)
        textoo2 = "Adicionado"
    end

    for i,v in pairs(_G.eetab) do
        textoo = textoo .. v .. ", "
    end

    msg(nomeda .. " " .. textoo2, "Selecionados: " .. textoo)
end

local tabbb = {"Cremation", "Overhaul", "OFA", "HCHH", "Explosion", "Decay"}
for i,v in pairs(tabbb) do
    tab5:CreateButton(v,function()
        addTable(v)
    end)
end

local tab7,name7 = win:CreateTab("No CD",function() end)

for i,v in pairs({1,2,3}) do
    tab7:CreateButton("Skill " .. tostring(v),function()
        game:GetService("ReplicatedStorage").Power:FireServer(nil, false, v, false)
    end)
end

local tab8,name8 = win:CreateTab("Teleport",function() end)

local function tpp(cf)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf
end

tab8:CreateButton("TP Boss", function()
    local achou = false
    for i,v in pairs(game:GetService("Workspace").Characters:GetChildren()) do
        if v:FindFirstChild("NonSpawnable") and string.find(v.Name, "Boss") or v.Name == "Goto" then
            achou = true
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,100,0)
            break
        end
    end
    if not achou then
        msg("TP Boss", "Boss não spawnado")
    end
end)

tab8:CreateButton("Spawn", function()
    tpp(CFrame.new(-2.40392, 3.19242, -18.6507))
end)

tab8:CreateButton("Hospital", function()
    tpp(CFrame.new(242.283, 3.39242, 1088.21))
end)

tab8:CreateButton("UA", function()
    tpp(CFrame.new(765.222, 24.98, -24.976))
end)

tab8:CreateButton("Prestige", function()
    tpp(CFrame.new(638.628, 3.79342, 125.95))
end)

tab8:CreateButton("Prisao 1", function()
    tpp(CFrame.new(444.214, 2.33322, -1442.97))
end)

tab8:CreateButton("Prisao 2", function()
    tpp(CFrame.new(645.07, -114.795, -3357.75))
end)

tab8:CreateButton("Loja", function()
    tpp(CFrame.new(-722.125, 4.04802, 1084.91))
end)

tab8:CreateButton("Floresta", function()
    tpp(CFrame.new(-1399.33, -1.11415, -17.6662))
end)

local tab6,name6 = win:CreateTab("Debug",function() end)

local textbox4 = tab6:CreateTextbox("Nome","Nome")

textbox4:GetPropertyChangedSignal("Text"):Connect(function()
    _G.toprintxd = textbox4.Text
end)

tab6:CreateButton("Print",function()
    print(game.ReplicatedStorage.AllPlayerData[game.Players.LocalPlayer.Name]["Char Data"][_G.toprintxd].Value)
end)

tab6:CreateButton("Debug Print",function()
    for i,v in pairs(game.ReplicatedStorage.AllPlayerData[game.Players.LocalPlayer.Name]["Char Data"]:GetChildren()) do
        if not v:IsA("Folder") then
            print(v)
        end
    end
end)
