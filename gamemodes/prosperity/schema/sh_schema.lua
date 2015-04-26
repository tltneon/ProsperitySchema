SCHEMA.name = "Prosperity"
SCHEMA.introName = "Prosperity Roleplay"
SCHEMA.author = "Chancer"
SCHEMA.desc = "We're Only Human"

nut.util.include("sh_config.lua")
nut.util.include("sh_commands.lua")
nut.util.include("sh_voices.lua")
nut.util.includeDir("hooks")

--for k, v in pairs(SCHEMA.deathSounds) do
--	for k2, v2 in ipairs(v) do
--		util.PrecacheSound(v2)
--	end
--end

--for k, v in pairs(SCHEMA.painSounds) do
--	for k2, v2 in ipairs(v) do
--		util.PrecacheSound(v2)
--	end
--end

if (SERVER) then
	function SCHEMA:saveVendingMachines()
		local data = {}

		for k, v in ipairs(ents.FindByClass("nut_vendingm")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles(), v:getNetVar("stocks"), v:getNetVar("active")}
		end

		nut.data.set("vendingm", data)
	end

	function SCHEMA:saveDispensers()
		local data = {}

		for k, v in ipairs(ents.FindByClass("nut_dispenser")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetDisabled() == true and true or nil}
		end

		nut.data.set("dispensers", data)
	end

	function SCHEMA:loadVendingMachines()
		local data = nut.data.get("vendingm") or {}

		for k, v in ipairs(data) do
			local entity = ents.Create("nut_vendingm")
			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()
			entity:setNetVar("stocks", v[3] or {})
			entity:setNetVar("active", v[4])
		end
	end

	function SCHEMA:loadDispensers()
		for k, v in ipairs(nut.data.get("dispensers") or {}) do
			local entity = ents.Create("nut_dispenser")
			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()

			if (v[3]) then
				entity:SetDisabled(true)
			end
		end
	end
end

nut.flag.add("v", "Access to the general items.")
nut.flag.add("V", "Access to the more rare items.")

nut.currency.set("", "Metallic Shard", "Metallic Shards")