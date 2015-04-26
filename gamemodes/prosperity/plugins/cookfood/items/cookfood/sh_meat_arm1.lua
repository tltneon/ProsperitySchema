ITEM.name = "Human Arm"
ITEM.uniqueID = "food_human_arm1"
ITEM.model = "models/dismemberment/gibs/arms/lower_arm.mdl"
ITEM.hungerAmount = 30
ITEM.foodDesc = "The lower arm of a human being."
ITEM.quantity = 2
ITEM.price = 50
ITEM.width = 2
ITEM.height = 1

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;