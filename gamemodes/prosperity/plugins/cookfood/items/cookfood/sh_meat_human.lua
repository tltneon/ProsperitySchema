ITEM.name = "Human Meat"
ITEM.uniqueID = "food_human_meat"
ITEM.model = "models/Gibs/Antlion_gib_small_2.mdl"
ITEM.hungerAmount = 15
ITEM.foodDesc = "Meat ripped from the body of a human, it smells disgusting."
ITEM.quantity = 2
ITEM.price = 100
ITEM.width = 2
ITEM.height = 2

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;