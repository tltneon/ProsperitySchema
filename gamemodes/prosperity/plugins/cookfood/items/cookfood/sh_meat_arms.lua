ITEM.name = "Human Arm"
ITEM.uniqueID = "food_human_arms"
ITEM.model = "models/dismemberment/gibs/arms.mdl"
ITEM.hungerAmount = 30
ITEM.foodDesc = "The upper arm of a human being."
ITEM.quantity = 4
ITEM.price = 100
ITEM.width = 4
ITEM.height = 2

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;