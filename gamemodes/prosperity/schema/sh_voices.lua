--[[
	Define your voice classes here. The function goes:

	nut.voice.defineClass(class, onCheck(client)[, onModify(client, sounds)])

	Class is the same class that starts the nut.voice.register
	It is case-insensitive. The onCheck passes the player trying
	to use the class. Return true to allow them to use the class.
--]]

-- What type of chat modes support voice commands:
--nut.voice.chatTypes["ic"] = true
--nut.voice.chatTypes["w"] = true
--nut.voice.chatTypes["y"] = true
--nut.voice.chatTypes["radio"] = true


--[[

-- Example of citizen class that requires the ciitzen to have 'y' flag.
nut.voice.defineClass("citizen", function(client)
	return client:getChar():hasFlags("y")

end)
--]]

