
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.classiclight.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if ( CLIENT ) then
    language.Add( "Tool.classiclight.name", "Classic Lightbulb Stool" )
    language.Add( "Tool.classiclight.desc", "The Classic Light Tool from Garry's Mod 11" )
    language.Add( "Tool.classiclight.0", "Primary: Make a tethered lightbulb - Secondary: Make an untethered lightbulb to place where you want." )
    language.Add( "tool.classiclight.ropelength", "Tether Length:" )
    language.Add( "tool.classiclight.color", "Light Color:" )
    language.Add( "tool.classiclight.brightness", "Light Brightness:" )
    language.Add( "tool.classiclight.size", "Light Radius:" )
    language.Add( "tool.classiclight.toggle", "Light Key:" )
    language.Add( "Undone_classiclight", "Undone Classic Light" )
    language.Add( "Cleanup_classiclight", "Classic Lights" )
    language.Add( "Cleaned_classiclight", "Cleaned up all Classic Lights" )
    language.Add( "SBoxLimit_classiclight", "You've reached the Classic Lights Limit!" )

end

TOOL.ClientConVar[ "ropelength" ]		= "64"
TOOL.ClientConVar[ "ropematerial" ]		= "cable/rope"
TOOL.ClientConVar[ "r" ]				= "255"
TOOL.ClientConVar[ "g" ]				= "255"
TOOL.ClientConVar[ "b" ]				= "255"
TOOL.ClientConVar[ "brightness" ]		= "2"
TOOL.ClientConVar[ "size" ]				= "256"
TOOL.ClientConVar[ "key" ]				= "-1"

cleanup.Register( "classiclight" )
CreateConVar("sbox_maxclassiclight", 10, FCVAR_NOTIFY)

function TOOL:LeftClick( trace, attach )

	if trace.Entity && trace.Entity:IsPlayer() then return false end
	if (CLIENT) then return true end
	if (attach == nil) then attach = true end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && attach && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local ply = self:GetOwner()
	
	local pos, ang = trace.HitPos + trace.HitNormal * 10, trace.HitNormal:Angle() - Angle( 90, 0, 0 )

	local r 	= math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
	local g 	= math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
	local b 	= math.Clamp( self:GetClientNumber( "b" ), 0, 255 )
	local brght	= math.Clamp( self:GetClientNumber( "brightness" ), 0, 255 )
	local size 	= self:GetClientNumber( "size" )
	
	local key 	= self:GetClientNumber( "key" )
	
	-- Clamp for multiplayer
	if ( !game.SinglePlayer() ) then
		size = math.Clamp( size, 0, 512 )
		brght = math.Clamp( brght, 0, 1 )
	end
	
	if	( IsValid( trace.Entity ) && 
			trace.Entity:GetClass() == "classiclight" &&
			trace.Entity:GetPlayer() == ply ) then
		
		
		trace.Entity:SetColor( Color( r, g, b, 255 ) )
		trace.Entity.r = r
		trace.Entity.g = g
		trace.Entity.b = b
		trace.Entity.Brightness = brght
		trace.Entity.Size = size
		
		trace.Entity:SetBrightness( brght )
		trace.Entity:SetLightSize( size )
		
		return true
		
	end
	
	if ( !self:GetSWEP():CheckLimit( "classiclight" ) ) then return false end
	classiclightlamp = MakeClassicLight( ply, r, g, b, brght, size, true, key, { Pos = pos, Angle = ang } )
	
	if (!attach) then 
	
		undo.Create("classiclight")
			undo.AddEntity( classiclightlamp )
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		return true
		
	end

	local length 	= math.Clamp( self:GetClientNumber( "ropelength" ), 4, 1024 )
	local material 	= self:GetClientInfo( "ropematerial" )
	
	local LPos1 = Vector( 0, 0, 5 )
	local LPos2 = trace.Entity:WorldToLocal( trace.HitPos )
	
	if (trace.Entity:IsValid()) then
		
		local phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
		if (phys:IsValid()) then
			LPos2 = phys:WorldToLocal( trace.HitPos )
		end
	
	end
	
	local constraint, rope = constraint.Rope( classiclightlamp, trace.Entity, 
											  0, trace.PhysicsBone, 
											  LPos1, LPos2, 
											  0, length,
											  0, 
											  1, 
											  material, 
											  nil )
	
	undo.Create("classiclight")
		undo.AddEntity( classiclightlamp )
		undo.AddEntity( rope )
		undo.AddEntity( constraint )
		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

function TOOL:RightClick( trace )

	return self:LeftClick( trace, false )

end

function TOOL.BuildCPanel( CPanel )

	-- HEADER
	CPanel:AddControl( "Header", { Text = "#tool.classiclight.name", Description	= "#tool.classiclight.desc" }  )
	
	-- Presets
	local params = { Label = "#tool.presets", MenuButton = 1, Folder = "classiclight", Options = {}, CVars = {} }
		
		params.Options.default = {
			classiclight_ropelength	= 		64,
			classiclight_ropematerial	=		"cable/rope",
			classiclight_r				=		255,
			classiclight_g				=		255,
			classiclight_b				=		255,
			classiclight_brightness	=		2,
			classiclight_size		=		256
		}
			
		table.insert( params.CVars, "classiclight_ropelength" )
		table.insert( params.CVars, "classiclight_ropematerial" )
		table.insert( params.CVars, "classiclight_r" )
		table.insert( params.CVars, "classiclight_g" )
		table.insert( params.CVars, "classiclight_b" )
		table.insert( params.CVars, "classiclight_brightness" )
		table.insert( params.CVars, "classiclight_size" )
		
	CPanel:AddControl( "ComboBox", params )
	
	CPanel:AddControl( "Slider",  { Label	= "#tool.classiclight.ropelength",
									Type	= "Float",
									Min		= 0,
									Max		= 256,
									Command = "classiclight_ropelength" }	 )
	
	
	CPanel:AddControl( "Color",  { Label	= "#tool.classiclight.color",
									Red			= "classiclight_r",
									Green		= "classiclight_g",
									Blue		= "classiclight_b",
									ShowAlpha	= 0,
									ShowHSV		= 1,
									ShowRGB 	= 1,
									Multiplier	= 255 } )	
									
	CPanel:AddControl( "Slider",  { Label	= "#tool.classiclight.brightness",
									Type	= "Float",
									Min		= 0,
									Max		= 10,
									Command = "classiclight_brightness" }	 )
									
	CPanel:AddControl( "Slider",  { Label	= "#tool.classiclight.size",
									Type	= "Float",
									Min		= 0,
									Max		= 1024,
									Command = "classiclight_size" }	 )

	CPanel:AddControl( "Numpad", { Label = "#tool.classiclight.toggle", Command = "classiclight_key", ButtonSize = 22 } )

									
end

if ( SERVER ) then

	function MakeClassicLight( pl, r, g, b, brght, size, on, KeyDown, Data )
	
		if ( IsValid( pl ) && !pl:CheckLimit( "classiclight" ) ) then return false end
	
		local classiclightlamp = ents.Create( "classiclight" )
		
			if (!classiclightlamp:IsValid()) then return end
		
			duplicator.DoGeneric( classiclightlamp, Data )
			classiclightlamp:SetColor( Color( r, g, b, 255 ) )
			classiclightlamp:SetBrightness( brght )
			classiclightlamp:SetLightSize( size )
			classiclightlamp:SetOn( on )
			
		classiclightlamp:Spawn()
		
		duplicator.DoGenericPhysics( classiclightlamp, pl, Data )
		
		classiclightlamp:SetPlayer( pl )
	
		if ( IsValid( pl ) ) then
			pl:AddCount( "classiclight", classiclightlamp )
			pl:AddCleanup( "classiclight", classiclightlamp )
		end
		
		classiclightlamp.lightr = r
		classiclightlamp.lightg = g
		classiclightlamp.lightb = b
		classiclightlamp.Brightness  = brght
		classiclightlamp.Size = size
		classiclightlamp.KeyDown = KeyDown
		classiclightlamp.on = on
		
		numpad.OnDown( pl, KeyDown, "classiclightToggle", classiclightlamp, 1 )
		numpad.OnUp( pl, KeyDown, "classiclightToggle", classiclightlamp, 0 )

		return classiclightlamp
		
	end
	
	duplicator.RegisterEntityClass( "classiclight", MakeClassicLight, "classiclightlightr", "classiclightlightg", "classiclightlightb", "Brightness", "Size", "on", "KeyDown", "Data" )
	
	
	local function Toggle( pl, ent, onoff )
	
		if ( !IsValid( ent ) ) then return false end

		if ( numpad.FromButton() ) then

			ent:SetOn( onoff == 1 )
			return;

		end

		if ( onoff == 0 ) then return end
		
		return ent:Toggle()
		
	end
	
	numpad.Register( "classiclightToggle", Toggle )

end
