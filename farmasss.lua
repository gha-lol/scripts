local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/InfinitiveUI",true))()
local win = lib:CreateWindow("Farmassss",1,nil,nil)

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
                tp = CFrame.new(932, 73, -23)
            elseif _G.ques == "Side1" then
                tp = CFrame.new(276, 3, 1102)
            elseif _G.ques == "Side3" then
                tp = CFrame.new(-733, 4, 1066)
            elseif _G.ques == "Hero13" then
                tp = CFrame.new(276, 3, 1102)
            elseif _G.ques == "Hero18" then
                tp = CFrame.new(932, 73, -23)
            elseif _G.ques == "Side4" then
                tp = CFrame.new(-32, 569, 158)
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

tab1:CreateDropdown("Quest", {"Hero2", "Hero13", "Hero18", "Side1", "Side3", "Side4"},false,function(quest)
    _G.ques = quest
end)

local tab2,name2 = win:CreateTab("Personagem",function() end)

tab2:CreateSlider("Points",1,350,1,function(valor)
    _G.pontos = valor
end)

tab2:CreateDropdown("Converter Para", {"QuirkSpins", "RaceSpins", "QuirkLevel", "StaminaLevel", "DefenseLevel", "StrengthLevel", "WeaponLevel"},false,function(stat)
    _G.convpara = stat
end)

local textbox1 = tab2:CreateTextbox("Converter Para","Converter Para")

textbox1:GetPropertyChangedSignal("Text"):Connect(function()
    _G.convpara = textbox1.Text
end)

tab2:CreateButton("Converter Points",function()
    for i=1, _G.pontos do
        game:GetService("ReplicatedStorage").AddPoint:FireServer(_G.convpara)
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
        if table.find(_G.eetab, quirk.Value) then _G.sp = false error("e") return end
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

local tabbb = {"Cremation", "OFA", "HCHH", "Explosion", "Decay"}
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
