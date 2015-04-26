PLUGIN.name = "Persistent Props"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Allows administrators to set props to be persistent through restarts."

if (SERVER) then
	file.CreateDir("persist")
	file.CreateDir("persist/nutscript")

	function PLUGIN:LoadData()
		local contents = file.Read("persist/nutscript/"..SCHEMA.uniqueID.."/"..game.GetMap()..".txt", "DATA")

		if (!contents) then
			return
		end

		local data = util.JSONToTable(contents)

		if (data) then
			local entities, constraints = duplicator.Paste(nil, data.Entities or {}, data.Contraints or {})

			for k, v in pairs(entities) do
				v:setNetVar("persist", true)
			end
		end
	end

	function PLUGIN:SaveData()
		local data = {}

		for k, v in pairs(ents.GetAll()) do
			if (v:getNetVar("persist")) then
				data[#data + 1] = v
			end
		end

		if (#data > 0) then
			local persistData = duplicator.CopyEnts(data)

			if (!persistData) then
				return
			end

			file.CreateDir("persist/nutscript/"..SCHEMA.uniqueID)
			file.Write("persist/nutscript/"..SCHEMA.uniqueID.."/"..game.GetMap()..".txt", util.TableToJSON(persistData))
		end
	end
end

local PLUGIN = PLUGIN

nut.command.add("persist", {
	adminOnly = true,
	syntax = "<bool hidden>",
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity

		if (IsValid(entity)) then
			local class = entity:GetClass()

			if (string.find(class, "prop_") and !string.find(class, "door")) then
				entity:setNetVar("persist", !util.tobool(arguments[1]))

				if (entity:getNetVar("persist")) then
					client:notifyLocalized("This entity is now persisted.")
				else
					client:notifyLocalized("This entity is no longer persisted.")
				end

				PLUGIN:SaveData()
			else
				client:notifyLocalized("That entity can not be persisted.")
			end
		else
			client:notifyLocalized("You provided an invalid entity.")
		end
	end
})

