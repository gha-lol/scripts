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

--sack:GetAttribute("Capacity")

local autoKillToggle = Tabs.Main:CreateToggle("autoKillToggle", {Title = "Auto Kill", Default = false})
autoKillToggle:OnChanged(function()
    _G.akt = Options.autoKillToggle.Value
    while _G.akt do task.wait()
        
    end
end)
