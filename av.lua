local numOrder = {}
local plr = game.Players.LocalPlayer

plr.PlayerGui.ChildAdded:Connect(function(es)
    if e.Name == "DialoguePopup" then
        if e.Holder.Main.DialogueText.ContentText == "I..." or e.Holder.Main.DialogueText.ContentText == "I" or e.Holder.Main.DialogueText.ContentText == "I.." or e.Holder.Main.DialogueText.ContentText == "I." then
            warn("No bruh")
            for i,v in pairs(numOrder) do
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.Towers["Tower" .. v].Root.Position + Vector3.new(3,0,0))
                task.wait(.8)
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                task.wait(.5)
            end
            table.clear(numOrder)
        else
            local cleaned = e.Holder.Main.DialogueText.ContentText:gsub("...", "")
            local cleaned = e.Holder.Main.DialogueText.ContentText:gsub("..", "")
            local cleaned = e.Holder.Main.DialogueText.ContentText:gsub(".", "")
            local num = tonumber(cleaned)
            
            if num then
                table.insert(numOrder, tostring(num))
                warn(tostring(num))
            end
        end
    end
end)
