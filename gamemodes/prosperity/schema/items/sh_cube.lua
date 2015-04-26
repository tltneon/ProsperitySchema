ITEM.name = "Modified Experimental Nourishment Device"
ITEM.uniqueID = "cube_b"
ITEM.model = "models/hunter/blocks/cube05x05x05.mdl"
ITEM.desc = "A strange metal box labelled E.N.D. It would be seemingly vibrating lightly. The box appears to have only a single button, labelled 'FOOD', and a slot in the top for some sort of chip."
ITEM.width = 3
ITEM.height = 3
ITEM.flag = "v"
ITEM.price = 500

ITEM.category = "Experimental Nourishment Device"

ITEM.functions.Activate = {
	
	icon = "icon16/box.png",
	sound = "buttons/lightswitch2.wav",
	onRun = function(item)
			local client = item.player
			local position = item.player:getItemDropPos()
			local inventory = client:getChar():getInv()
			if (!inventory:hasItem("cube_chip")) then
				client:notifyLocalized("You can't insert a chip if you don't have one!") return false
			end
			local ranNum = math.random(1,5);
			if(ranNum == 1) then
				nut.item.spawn("food_potato", position)
				inventory:remove("cube_chip")
				client:ConCommand("say /it The door on the machine opens up, dropping out a potato.")	
				return false
			end
			
			if (ranNum == 2) then
				nut.item.spawn("food_banana")
				inventory:remove("cube_chip")
				client:ConCommand("say /it The door on the machine opens up, dropping out a banana.")	
				return false
			end
			
			if (ranNum == 3) then
				nut.item.spawn("food_orange")
				inventory:remove("cube_chip")
				client:ConCommand("say /it The door on the machine opens up, dropping out an orange.")	
				return false
			end
			
			if (ranNum == 4) then
				nut.item.spawn("food_carrot")
				nut.item.spawn("food_carrot")
				inventory:remove("cube_chip")
				client:ConCommand("say /it The door on the machine opens up, dropping out two carrots.")	
				return false
			end
			
			if (ranNum == 5) then
				nut.item.spawn("food_apple")
				inventory:remove( "cube_chip")
				client:ConCommand("say /it The door on the machine opens up, dropping out an apple.")	
				return false
			end
	end
}

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/props_pipes/destroyedpipes01a");
	end;