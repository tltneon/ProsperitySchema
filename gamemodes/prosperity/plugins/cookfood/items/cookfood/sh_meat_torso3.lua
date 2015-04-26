ITEM.name = "Human Torso Chunk"
ITEM.uniqueID = "food_human_torso3"
ITEM.model = "models/dismemberment/gibs/torso/torso_right_upper.mdl"
ITEM.hungerAmount = 50
ITEM.foodDesc = "The torso of a human being."
ITEM.quantity = 2
ITEM.price = 100
ITEM.width = 2
ITEM.height = 3

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;