local Orakel = require(game.ReplicatedStorage.Orakel.Main)
local Entity = {}
Entity.Status = true


Entity.KeyValues = {
  ["EntityName"] = "";
  ["SceneScript"] = "";
  ["InterruptCurrent"] = true;
  ["Actor1"] = "";
  ["Actor2"] = "";
  ["Actor3"] = "";
  ["Actor4"] = "";
  ["Actor5"] = "";
  ["Actor6"] = "";
  ["Actor7"] = "";
  ["Actor8"] = "";
}


Entity.Inputs = {
  ["Start"] = function(ent)
    warn(Orakel.Configuration.WarnHeader.." Cannot use input 'Start' on logic_choreo_scene! Not yet implemented!")
  end;
}



Entity.Update = function(e)
--	local function collectActors(e)
--		local actors = {}
--		local num = 0
--		for _, v in pairs(e:GetChildren()) do
--			if v.ClassName == "StringValue" then
--				if string.find(v.Name, "Actor") then
--					local actorId = string.sub(v.Name, 6)
--					actors[actorId] = Orakel.FindNpc(v.Value)
--					print("collectActors -> actorId: "..tostring(actorId).."  actorValue: "..tostring(actors[actorId]))
--				end
--			end
--		end
--		return actors
--	end
--
--	while wait(1/10) do
--		if e.Enabled.Value then
--			local actors = collectActors(e)
--			local scene = e.SceneScript.Value
--			Orakel.RunScene(scene, actors, e.InterruptCurrent.Value)
--			e.Enabled.Value = false
--		end
--	end
end


Entity.Kill = function()
	Entity.Status = false
end




return Entity