AddCSLuaFile("autorun/msi_init.lua");

local PLAYER = FindMetaTable("Player")

function PLAYER:SetStreaming(state)
    self.IsStreamingState = state
end

function PLAYER:IsStreaming()
    return self.IsStreamingState == true
end

function PLAYER:SetRecording(state)
    self.IsRecordingState = state
end

function PLAYER:IsRecording()
    return self.IsRecordingState == true
end
