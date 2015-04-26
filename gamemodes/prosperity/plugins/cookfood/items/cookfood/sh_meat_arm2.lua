ITEM.name = "Human Arm"
ITEM.uniqueID = "food_human_arm2"
ITEM.model = "models/dismemberment/gibs/arms/upper_arm.mdl"
ITEM.hungerAmount = 30
ITEM.foodDesc = "The upper arm of a human being."
ITEM.quantity = 2
ITEM.price = 50
ITEM.width = 2
ITEM.height = 1

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;