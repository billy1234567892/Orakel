local Orakel = require(game.ReplicatedStorage.Orakel.Main)
local Entity = {}
Entity.Status = true
local camLib = Orakel.LoadModule("CameraLib")

Entity.Type = "Point"
Entity.EditorTexture = "http://www.roblox.com/asset/?id=220513941"

Entity.KeyValues = {
  ["EntityName"] = "";
  ["Duration"] = 1;
  ["Amplitude"] = 1;
  ["Frequency"] = 0.1; --0.1 = Jitter, 5 = Earthquake
  ["Radius"] = 20;
}

--TODO: Utilize Amplitude
Entity.Inputs = {
  ["StartShake"] = function(ent)
    if ent.Enabled.Value then
      local cam = workspace.CurrentCamera
      camLib.ShakeCamera(cam.CoordinateFrame, cam.Focus, ent.Frequency.Value, ent.Duration.Value, true)
    end
  end;
}

Entity.Update = function(ent)
end


Entity.Kill = function()
	Entity.Status = false
end



return Entity