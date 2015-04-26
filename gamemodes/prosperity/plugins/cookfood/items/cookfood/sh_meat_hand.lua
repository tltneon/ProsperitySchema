ITEM.name = "Human Hand"
ITEM.uniqueID = "food_human_hand"
ITEM.model = "models/dismemberment/gibs/arms/hand.mdl"
ITEM.hungerAmount = 20
ITEM.foodDesc = "A hand that was once connected to a human being."
ITEM.quantity = 1
ITEM.price = 100
ITEM.width = 1
ITEM.height = 2

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;