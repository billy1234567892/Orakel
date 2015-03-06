local root = script.Parent
local Module = {}
local run = game:GetService("RunService")



Module.Configuration = {
	Version = "version 1.0.2.4";
	SoloTestMode = game:FindService("NetworkServer") == nil and game:FindService("NetworkClient") == nil;
	PrintHeader = "Orakel |  ";
	WarnHeader = "Orakel Warning |  ";
	ErrorHeader = "Orakel Error |  ";
	Logo = {
		Full = "http://www.roblox.com/asset/?id=220270074";
		Symbol = "http://www.roblox.com/asset/?id=220270067";
		Text = "http://www.roblox.com/asset/?id=220270070";
	};
	Entities = root.Entities;
}



Module.GameInfo = {
	Name = "ORAKEL";
	Icon = "http://www.roblox.com/asset/?id=220270070";
	IntroSong = "http://www.roblox.com/asset/?id=157520543";
	StartLevel = "c1m1";
	--MapsDir = game.ServerStorage.Maps;
	ScriptsDir = game.ReplicatedStorage.Scripts;
	CutsceneDir = game.ReplicatedStorage.Cutscenes;
	AnimsDir = game.ReplicatedStorage.Animations;
	EventsDir = game.ReplicatedStorage.Events;
	CustomPlayer = true;
	CameraOffset = CFrame.new(0, 2, 0); --3rd person: CFrame.new(1, 2, 10)
	CorpseFadeTime = 10;
}



--Essentially this list defines what is compiled
--The bool isBrush defines which entities are set invisible during compile
Module.EntityList = {
	--string Entity, bool isBrush
	["point_camera"] = false;
	["info_player_start"] = false;
	["weapon_spawn"] = false;
	["phys_rope"] = false;
	["light_env"] = false;
	["func_monitor"] = false; --yes
	["env_spark"] = false;
	["env_soundscape"] = false;
	["env_fire"] = false;
	["func_button"] = false; --yes
	["func_water"] = true;
	["func_trigger"] = true;
	["trigger_hurt"] = true;
	["func_breakable"] = false; --yes
	["env_explosion"] = false;
	["env_shake"] = false;
	["npc_maker"] = false;
	["ai_goal"] = false;
	["logic_choreographed_scene"] = false;
	["nav_clip"] = true;
	["ai_recollect"] = false;
	["func_precipitation"] = true;
	["point_myentity"] = false;
}



Module.TweenModel = function(model, c0, c1, t0, func_OnGoal)
	print(Module.Configuration.PrintHeader.."Tweening "..tostring(model).."...")
	local CFrameInterp = Module.LoadModule("CFrameInterp")
	local children = model:children()
	local now = tick()
	local angle, interpFunc = CFrameInterp(c0, c1)
	local steps = t0 * 60
	local lastPos = model.PrimaryPart.Position
	local lastTick = tick()

	for f = 0, steps, 1 / steps do
		if f >= 1 then
			break
		end
		local cf = interpFunc(f)
		model:SetPrimaryPartCFrame(cf)
		for i = 1, #children do
			if children[i]:IsA("BasePart") then
				local v = (model.PrimaryPart.Position - lastPos) / (lastTick - tick())
				children[i].Velocity = Vector3.new(-v.x, -v.y, -v.z)
			end
		end
		
		lastPos = model.PrimaryPart.Position
		lastTick = tick()
		Module.WaitRender()
	end
	
	for _, p in pairs(model:children()) do
		if p:IsA("BasePart") then
			p.Velocity = Vector3.new(0, 0, 0)
		end
	end
	
	model:SetPrimaryPartCFrame(c1)
	print(Module.Configuration.PrintHeader..tick() - now.." time taken to tween "..tostring(model)..", Set Duration was "..t0)
	
	if func_OnGoal ~= nil then
		if type(func_OnGoal) == "function" then
			func_OnGoal()
		end
	end
end



Module.PrintVersion = function()
	warn("Orakel "..Module.Configuration.Version.." up and running!")
end



Module.PrintStatus = function(origin)
	warn(Module.Configuration.PrintHeader..origin.." initialized")
end



Module.WaitRender = function()
	run.RenderStepped:wait()
end


Module.FindSound = function(name)
	local assetlib = Module.LoadModule("AssetLib")
	for _, stype in pairs(assetlib.Sounds) do
		for sname, snd in pairs(stype) do
			if sname == name then
				return snd
			end
		end
	end
	return nil
end



Module.PlayCutscene = function(sc, arg)
	local strLib = Module.LoadModule("StringLib")
	local filename = sc
	local folder, file
	if string.find(sc, "_") then
		filename = strLib.Split(sc, "_")
	end
	if type(filename) == "table" then
		folder = Module.GameInfo.CutsceneDir:FindFirstChild(filename[1])
		file = folder:FindFirstChild(filename[2])
	else
		file = Module.GameInfo.CutsceneDir:FindFirstChild(filename)
	end
	if file then
		warn(Module.Configuration.PrintHeader.."Running scene '"..sc.."'")
		spawn(function()
			local stat,err = pcall(function()
				local sc = require(file)
				sc.Main(arg)
				Module.GameInfo.EventsDir.MapChange.OnClientEvent:connect(sc.Kill)
			end)
			if not stat then
				warn(Module.Configuration.ErrorHeader..err)
			end
		end)
	else
		warn(Module.Configuration.WarnHeader.."Tried to run cutscene '"..sc.."' which does not exist!")
	end
end


Module.RunScript = function(sc, arg)
	local strLib = Module.LoadModule("StringLib")
	local filename = sc
	local folder, file
	if string.find(sc, "_") then
		filename = strLib.Split(sc, "_")
	end
	if type(filename) == "table" then
		folder = Module.GameInfo.ScriptsDir:FindFirstChild(filename[1])
		file = folder:FindFirstChild(filename[2])
	else
		file = Module.GameInfo.ScriptsDir:FindFirstChild(filename)
	end
	if file then
		warn(Module.Configuration.PrintHeader.."Running script '"..sc.."'")
		spawn(function()
			local stat,err = pcall(function()
				local sc = require(file)
				sc.Main(arg)
				Module.GameInfo.EventsDir.MapChange.OnClientEvent:connect(sc.Kill)
			end)
			if not stat then
				warn(Module.Configuration.ErrorHeader..err)
			end
		end)
	else
		warn(Module.Configuration.WarnHeader.."Tried to run script '"..sc.."' which does not exist!")
	end
end

Module.RunScene = function(sc, arg, arg2)
	local strLib = Module.LoadModule("StringLib")
	local filename = sc
	local folder, file
	if string.find(sc, "_") then
		filename = strLib.Split(sc, "_")
	end
	if type(filename) == "table" then
		folder = Module.GameInfo.ScriptsDir:FindFirstChild(filename[1])
		file = folder:FindFirstChild(filename[2])
	else
		file = Module.GameInfo.ScriptsDir:FindFirstChild(filename)
	end
	if file then
		warn(Module.Configuration.PrintHeader.."Running scene '"..sc.."'")
		spawn(function()
			local stat,err = pcall(function()
				local sc = require(file)
				sc.Main(arg, arg2)
				Module.GameInfo.EventsDir.MapChange.OnClientEvent:connect(sc.Kill)
			end)
			if not stat then
				warn(Module.Configuration.ErrorHeader..err)
			end
		end)
	else
		warn(Module.Configuration.WarnHeader.."Tried to run choreo_scene '"..sc.."' which does not exist!")
	end
end


Module.GetMap = function()
	local map
	if game.Players.LocalPlayer == nil then
		map = workspace.Game.CurrentMap.Value
	else
		local mapname = game.ReplicatedStorage.Events.GetGameValue:InvokeServer("CurrentMap")
		if mapname ~= nil then
			map = workspace:findFirstChild(mapname)
		end
	end
	return map
end


Module.RecursiveFindEntity = function(dir, entityName)
	local c = dir:GetChildren()
	for i = 1, #c do
		local entName = c[i]:FindFirstChild("EntityName")
		if entName then
			if entName.Value == entityName then
				return c[i]
			end
		else
			Module.RecursiveFindEntity(c[i], entityName)
		end
	end
	return nil
end




Module.FindEntity = function(entityName)
	if entityName == "" then 
		return nil 
	end
	local map = Module.GetMap()
	local ent
	if map ~= nil then
		ent = Module.RecursiveFindEntity(map.Entities, entityName)
	end
	return ent
end


Module.FindNpc = function(entityName)
	if entityName == "" then 
		return nil 
	end
	local map = Module.GetMap()
	local ent
	if map ~= nil then
		ent = Module.RecursiveFindEntity(workspace.npcCache, entityName)
	end
	return ent
end


Module.LoadModule = function(module)
	local root = script.Parent
	local found = root:FindFirstChild(module, true)
	if found then
		return require(found)
	else
		error(Module.Configuration.ErrorHeader.."Module '"..tostring(module).."' wasn't found!")
	end
end






return Module