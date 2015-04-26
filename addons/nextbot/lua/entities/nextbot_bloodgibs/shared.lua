ENT.Type = "anim"

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() 
end

util.PrecacheModel("models/Gibs/HGIBS.mdl")
util.PrecacheModel("models/Gibs/HGIBS_scapula.mdl")