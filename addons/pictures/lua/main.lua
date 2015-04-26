util.AddNetworkString("requestpicture")
util.AddNetworkString("sendpicture")

net.Receive("sendpicture", function(len, ply)
	local pl = net.ReadEntity()
	local len = net.ReadFloat()
	local bit = net.ReadData(len)
	local int = net.ReadInt(8)
	
	if int == 1 then
		local w = net.ReadFloat()
		local h = net.ReadFloat()
		net.Start("sendpicture")
			net.WriteFloat(len)
			net.WriteData(bit, len)
			net.WriteInt(int, 8)
			net.WriteFloat(w)
			net.WriteFloat(h)
		net.Send(pl)
	else
		net.Start("sendpicture")
			net.WriteFloat(len)
			net.WriteData(bit, len)
			net.WriteInt(int, 8)
		net.Send(pl)
	end
end)