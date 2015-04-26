ITEM.name = "Antidepressants"
ITEM.model = "models/props_lab/jar01b.mdl"
ITEM.desc = "A small bottle filled with some pills."
ITEM.duration = 100
ITEM.price = 30
ITEM.attribBoosts = {
	["end"] = 5,
}

ITEM:hook("_use", function(item)
	item.player:EmitSound("physics/metal/soda_can_impact_hard1.wav")
	item.player:ScreenFade(1, Color(255, 255, 255, 255), 3, 0)
end)
