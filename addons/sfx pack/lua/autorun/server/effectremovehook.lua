//Find effects and stop their sounds
local function OnEffectRemove(effect)

	//Stop sounds
	if effect.Sound then
	effect.Sound:Stop()
	end

end

//Add hook
hook.Add("EntityRemoved", "EffectRemoveHook", OnEffectRemove)