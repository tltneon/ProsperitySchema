ITEM.name = "Steroid"
ITEM.model = "models/props_lab/jar01b.mdl"
ITEM.desc = "A small bottle filled with medical steroids."
ITEM.duration = 100
ITEM.price = 200
ITEM.attribBoosts = {
	["str"] = 5,
}

ITEM:hook("_use", function(item)
	item.player:EmitSound("items/battery_pickup.wav")
	item.player:ScreenFade(1, Color(255, 255, 255, 255), 3, 0)
end)
