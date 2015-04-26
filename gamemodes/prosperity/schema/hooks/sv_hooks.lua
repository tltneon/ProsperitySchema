
local workshopIDs = { 104648051, 296202013, 318360456, 296574075, 296589999, 296580642, 296585313, 296593344, 318359796, 317792429, 317793445, 104548572, 171525755, 106867422, 121438260, 309281508, 132470017, 143547520, 128093075, 110138917, 215338015, 207739713, 152111330, 409556564}

for k, v in pairs(workshopIDs) do

	resource.AddWorkshop(v)

end


function SCHEMA:OnCharCreated(client, character)
	local inventory = character:getInv()

	if (inventory) then		
		if (character:getFaction() == FACTION_SLEEPER) then
			inventory:Add("book_newchar", 1)
			inventory:Add("book_sleeper", 1)
		elseif (character:getFaction() == FACTION_SURVIVOR) then
			inventory:Add("book_newchar", 1)
			inventory:Add("book_survivor", 1)
		end
	end
end

function SCHEMA:LoadData()
	self:loadVendingMachines()
	self:loadDispensers()
end

function SCHEMA:SaveData()
	self:saveVendingMachines()
	self:saveDispensers()
end

--function SCHEMA:PlayerSwitchFlashlight(client, enabled)
--	if (client:isCombine()) then
--		return true
--	end
--end

--function SCHEMA:GetPlayerPainSound(client)
--	if (client:isCombine()) then
--		local sounds = self.painSounds[client:Team()] or self.painSounds[FACTION_CP]

--		return table.Random(sounds)
--	end
--end
