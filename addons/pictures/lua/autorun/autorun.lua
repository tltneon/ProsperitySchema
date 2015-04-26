if SERVER then
	include("main.lua")
	AddCSLuaFile("cl_main.lua")
	resource.AddFile("lua/bin/gmcl_example_win32.dll")
end

if CLIENT then
	include("cl_main.lua")
end