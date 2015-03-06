local Orakel = require(game.ReplicatedStorage.Orakel.Main)
local Entity = {}
Entity.Status = true
local sndLib = Orakel.LoadModule("SoundLib")



Entity.KeyValues = {
 ["EntityName"] = "";
 ["Goal"] = Vector3.new(0, 0, 0);
 ["Duration"] = 5;
 ["StartSound"] = "";
 ["MoveSound"] = "";
 ["StopSound"] = "";
}


Entity.Inputs = {
  ["Move"] = function(ent)
    local prim = ent:FindFirstChild("Primary") 
    if not prim then
      warn(Orakel.Configuration.ErrorHeader.." FUNC_MOVELINEAR DOES NOT HAVE A PRIMARY PART")
    end
    
    ent.PrimaryPart = prim
    local startSound = Orakel.FindSound(ent.StartSound.Value)
    local stopSound = Orakel.FindSound(ent.StopSound.Value)
    local moveSound = Orakel.FindSound(ent.MoveSound.Value)
    startSound = sndLib.PlaySoundClient("3d", "", startSound, 1, 1, false, 10, ent.Primary)
    moveSound = sndLib.PlaySoundClient("3d", "", moveSound, 1, 1, false, ent.Duration.Value + 2, ent.Primary)
    Orakel.TweenModel(
      ent, 
      ent.Primary.CFrame, 
      CFrame.new(ent.Goal.Value), 
      ent.Duration.Value
    )
    stopSound = sndLib.PlaySoundClient("3d", "", stopSound, 1, 1, false, 10, ent.Primary)
  end;
  
  ["Stop"] = function(ent)
    warn(Orakel.Configuration.WarnHeader.." Cannot use input 'Stop' on func_movelinear! Not yet implemented!")
  end;
}





Entity.Update = function(ent)
end


Entity.Kill = function()
	Entity.Status = false
end





return Entity