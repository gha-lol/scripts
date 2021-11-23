_G.nonShiny = {"Golden Experience", "Killer Queen", "Silver Chariot", "Star Platinum", "The World", "Tusk Act 1", "Tusk Act 2", "The World Alternate Universe", "The Hand", "Doppio King Crimson", "King Crimson: Doppio"}

local function pickUpArrows()
    local v
    while wait() do
        v = workspace:FindFirstChild("Stand Arrow")
        if v and v:FindFirstChild("ClickDetector") and v:FindFirstChild("Handle") then
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

game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Credits"; Text = "Made by: Ghabrieel On V3rmillion"})
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
