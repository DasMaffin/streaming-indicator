AddCSLuaFile("autorun/msi_init.lua");

if SERVER then
    util.AddNetworkString("MSI_ChatMessage")
    local commands = {
        toggleStreaming = "!toggleStreaming",
        toggleRecording = "!toggleRecording"
    }
    local function SendChatMessage(ply, message)
        net.Start("MSI_ChatMessage")
        net.WriteString(ply:Nick())
        net.WriteString(message)
        net.Broadcast()
    end

    hook.Add("PlayerSay", "HandleStreamingStatus", function(ply, text)
        if text ~= commands.toggleRecording and text ~= commands.toggleStreaming then return text end

        if text == commands.toggleStreaming then
            ply:SetStreaming(not ply:IsStreaming())
            if ply:IsStreaming() then                
                SendChatMessage(ply, " is now streaming!")
            else
                SendChatMessage(ply, " has stopped streaming!")
            end
            return ""
        elseif text == commands.toggleRecording then
            ply:SetRecording(not ply:IsRecording())
            if ply:IsRecording() then
                SendChatMessage(ply, " is now recording!")
            else
                SendChatMessage(ply, " has stopped recording!")
            end
            return ""
        end
    end)
    
    hook.Add("PlayerInitialSpawn", "SendLiveInformation", function(ply)
        ply:SetStreaming(false)
        ply:SetRecording(false)
    end)

    hook.Add("PlayerSpawn", "SendLiveInformation", function(ply)
        local newMessage = "" 
        if ply:IsStreaming() then
            newMessage =  " is streaming!"
        elseif ply:IsRecording() then
            newMessage = " is recording!"
        end

        if newMessage == "" then return end

        SendChatMessage(ply, newMessage)
    end)
end

if CLIENT then
    net.Receive("MSI_ChatMessage", function()
        local playerName = net.ReadString()
        local msg = net.ReadString()

        chat.AddText(Color(0, 255, 0), playerName,
            Color(255,255,255), msg)
    end)
end