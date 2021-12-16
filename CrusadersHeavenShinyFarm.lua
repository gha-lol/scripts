_G.nonShiny = {"Golden Experience", "Killer Queen", "Silver Chariot", "Star Platinum", "The World", "Tusk Act 1", "The World Alternate Universe", "The Hand", "King Crimson: Doppio"}
_G.stand = "None"

local function pickUpArrows()
    local v
    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Nametag") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.Nametag:Destroy()
    end
    while wait() do
        v = workspace:FindFirstChild("Stand Arrow")
        if v and v:FindFirstChild("ClickDetector") and v:FindFirstChild("Handle") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if game.Players.LocalPlayer.Character:FindFirstChild("LowerTorso") then
                game.Players.LocalPlayer.Character.LowerTorso:Destroy()
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
            fireclickdetector(v.ClickDetector)
        else
            break
        end
    end
end

local function useArrow(arrow)
    game:GetService("ReplicatedStorage").ItemEvent[arrow]:FireServer()
    repeat wait() until game.Players.LocalPlayer.PlayerGui.Menu.Frame.StandInfo.vpf:FindFirstChildOfClass("Model")
end

local function useMush()
    game:GetService("ReplicatedStorage").ItemEvent.ShinyMushroom:FireServer()
    game.Players.LocalPlayer.CharacterAdded:Wait()
end

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua')))()
local w = library:CreateWindow("Crusaders' Heaven")
local b = w:CreateFolder("Auto Farm")
local credits = w:CreateFolder("Credits")

credits:Label("Script: Ghabrieel",{TextSize = 17; TextColor = Color3.fromRGB(255,255,255); BgColor = Color3.fromRGB(30,30,30);})
credits:Label("UI: Wally&Aika",{TextSize = 17; TextColor = Color3.fromRGB(255,255,255); BgColor = Color3.fromRGB(30,30,30);})
b:Toggle("Shiny Farm",function(bool)
    _G.shinyFarm = bool
    spawn(function()
        while _G.shinyFarm do wait()
            game.Players.LocalPlayer.PlayerGui:WaitForChild("Menu")
            e = game.Players.LocalPlayer.PlayerGui.Menu.Frame.StandInfo.vpf:FindFirstChildOfClass("Model")
            if e and not table.find(_G.nonShiny, e.Name) then
                game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Shiny Notification"; Text = "Got a Shiny!"})
                n = game:GetService("Debris")
                s = Instance.new("Sound",game.Workspace)
                s.Name = "ItemSound"
                s.SoundId = "http://www.roblox.com/asset?id=371274037"
                s.Volume = 5
                s.Looped = false
                s:Play()
                n:AddItem(s, 2.1)
                break
            elseif e and e.Name == _G.stand and _G.useMushroom and game.Players.LocalPlayer.Backpack:FindFirstChild("Shiny Mushroom") then
                useMush()
            elseif e and table.find(_G.nonShiny, e.Name) then
                game:GetService("Workspace").Pucci.Pucci:FireServer()
                game.Players.LocalPlayer.CharacterAdded:Wait()
            else
                if game.Players.LocalPlayer.Backpack:FindFirstChild("Stand Arrow") then
                    useArrow("StandArrow")
                elseif _G.useWeirdArrow and game.Players.LocalPlayer.Backpack:FindFirstChild("Weird Arrow") then
                    useArrow("WeirdArrow")
                elseif _G.useSpookyArrow and game.Players.LocalPlayer.Backpack:FindFirstChild("Spooky Arrow") then
                    useArrow("SpookyArrow")
                else
                    pickUpArrows()
                end
            end
        end
    end)
end)
b:Label("Arrows Config",{TextSize = 17; TextColor = Color3.fromRGB(255,255,255); BgColor = Color3.fromRGB(30,30,30);})
b:Toggle("Use WeirdArrow",function(bool)
    _G.useWeirdArrow = bool
end)
b:Toggle("Use SpookyArrow",function(bool)
    _G.useSpookyArrow = bool
end)
b:Label("Mushroom Config",{TextSize = 17; TextColor = Color3.fromRGB(255,255,255); BgColor = Color3.fromRGB(30,30,30);})
b:Toggle("Use Mushroom",function(bool)
    _G.useMushroom = bool
end)
b:Dropdown("Use Mushroom On",_G.nonShiny,true,function(stand)
    _G.stand = stand
end)
