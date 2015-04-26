ITEM.name = "Human Pelvis"
ITEM.uniqueID = "food_human_pelvis"
ITEM.model = "models/dismemberment/gibs/torso/torso_pelvis.mdl"
ITEM.hungerAmount = 45
ITEM.foodDesc = "The pelvis of a human being."
ITEM.quantity = 3
ITEM.price = 100
ITEM.width = 3
ITEM.height = 3

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;