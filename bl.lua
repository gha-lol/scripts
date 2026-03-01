
_G.testt = true

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local part = Instance.new("Part", workspace)
part.Transparency = 1
part.Anchored = true
part.Massless = true
part.CanCollide = false
part.CFrame = char.HumanoidRootPart.CFrame
Instance.new("Attachment", part)

local align = Instance.new("AlignPosition", part)
align.MaxForce = 99e99
align.MaxVelocity = 400
align.Responsiveness = 200
align.Attachment0 = char.HumanoidRootPart.RootAttachment
align.Attachment1 = part.Attachment

local orient = Instance.new("AlignOrientation", part)
orient.MaxTorque = math.huge
orient.Responsiveness = 200
orient.Attachment0 = char.HumanoidRootPart.RootAttachment
orient.Attachment1 = part.Attachment

function noClip()
    for i,v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

while _G.testt do task.wait()
    noClip()
    for i,v in pairs(workspace.Live:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(v.HumanoidRootPart.Position + Vector3.new(0,-8,0))
            part.CFrame = CFrame.new(v.HumanoidRootPart.Position + Vector3.new(0,-8,0)) * CFrame.Angles(math.rad(90),0,0)
            break
        end
    end
    --plr.Character:WaitForChild("client_character_controller"):WaitForChild("M1"):FireServer(true,false)
end
part:Destroy()
