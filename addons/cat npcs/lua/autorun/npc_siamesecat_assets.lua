-----------------------------------------------------------------------------------
--------- Siamese Cat NPC Assets : By Jeezy
--------- *************************************************************************
--------- Description: Various things are done here that can't either can't be done 
--------- in the NextBot's script, or would fit better in here.
--------- *************************************************************************

-- Important ConVars that manipulate many features of the cat.
CreateConVar( "npc_siamesecat_movespeed", 50, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Movespeed of the cat, you'll get funny results if you put it too high." )
CreateConVar( "npc_siamesecat_soundvolume", 15, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The volume of the cat's sound, preferably from 0-100." )
CreateConVar( "npc_siamesecat_hungerrate", 1200000, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Around how many seconds inbetween each hunger tick." )
CreateConVar( "npc_siamesecat_enabledeath", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Whether or not cats can be killed or die from old age or starvation." )
CreateConVar( "npc_siamesecat_maxage", 15, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The maximum age of the cat, higher age means bigger max scale." )
CreateConVar( "npc_siamesecat_agerate", 1000000, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "How many seconds inbetween each age tick." )
CreateConVar( "npc_siamesecat_dehydraterate", 1200000, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "How many seconds inbetween each hydration tick." )
CreateConVar( "npc_siamesecat_fatiguerate", 400, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "How many seconds inbetween each fatigue tick." )

if ( SERVER ) then
	util.AddNetworkString( "CatNPCs_ReceiveData" )
else
	CreateClientConVar( "npc_siamesecat_enableparticles", "0", true, false ) -- Allows clients to disable particles.
	surface.CreateFont( "NPC_SiameseCat_StatFont", {
		font = "Trajan Pro 3",
		size = ScreenScale( 14 ),
		weight = 650
	} )

	local function ReceiveNETData( len )
		local messType = net.ReadString( ) -- The type of action that will be done.
		if ( messType == "Particles" and tobool( GetConVarNumber( "npc_siamesecat_enableparticles" ) ) ) then 
			-- If action type is Particles and particles are enabled.
			local selPos = net.ReadVector( )
			local selSprite = net.ReadString( )
			local particleEmitter = ParticleEmitter( selPos )
			local luaParticle = particleEmitter:Add( selSprite, selPos )
			if ( luaParticle ) then
				luaParticle:SetColor( 255, 255, 255, math.random( 100, 200 ) )
				luaParticle:SetVelocity( Vector( 0, 0, math.random( 5, 10 ) ) )
				luaParticle:SetDieTime( 2 )
				luaParticle:SetLifeTime( 0 )
				luaParticle:SetStartSize( 10 )
				luaParticle:SetEndSize( 5 )
			end
		elseif ( messType == "SetLife" ) then -- Sets the clientside life variable.
			local curLife = net.ReadInt( 32 )
			local tarCat = net.ReadEntity( )
			tarCat.curLife = curLife
		elseif ( messType == "SetAge" ) then -- Sets the clientside age variable.
			local curAge = net.ReadInt( 32 )
			local tarCat = net.ReadEntity( )
			tarCat.curAge = curAge
		elseif ( messType == "SetHunger" ) then -- Sets the clientside hunger variable.
			local curHunger = net.ReadInt( 32 )
			local tarCat = net.ReadEntity( )
			tarCat.curHunger = curHunger
		elseif ( messType == "SetHydration" ) then
			local curHydration = net.ReadInt( 32 )
			local tarCat = net.ReadEntity( )
			tarCat.curHydration = curHydration
		elseif ( messType == "SetFatigue" ) then
			local curFatigue = net.ReadInt( 32 )
			local tarCat = net.ReadEntity( )
			tarCat.curFatigue = curFatigue
		elseif ( messType == "SetFollowTarget" ) then -- Sets the clientside follow target variable.
			local curTarget = net.ReadEntity( ) or nil
			local tarCat = net.ReadEntity( )
			tarCat.followTarget = curTarget
		end
	end
	net.Receive( "CatNPCs_ReceiveData", ReceiveNETData )

	local function DrawInfoBG( ) -- The background for the HUD.
		draw.RoundedBoxEx( 8, ScrW( ) * 0.3, ScrH( ) * 0.9, ScrW( ) * 0.3, ScrH( ) * 0.09, Color( 37, 56, 120, 180 ), true, false, false, true ) -- Outer box
		draw.RoundedBoxEx( 8, ScrW( ) * 0.31, ScrH( ) * 0.91, ScrW( ) * 0.28, ScrH( ) * 0.07, Color( 37, 54, 143, 100 ), true, false, false, true ) -- Inner box
		draw.RoundedBoxEx( 8, ScrW( ) * 0.38, ScrH( ) * 0.95, ScrW( ) * 0.105, ScrH( ) * 0.03, Color( 34, 44, 133, 75 ), true, false, false, false ) -- Right lower box
		draw.RoundedBoxEx( 8, ScrW( ) * 0.485, ScrH( ) * 0.91, ScrW( ) * 0.1, ScrH( ) * 0.07, Color( 34, 44, 133, 75 ), true, false, false, true ) -- Right box
	end

	local function DrawCatInfo( )
		local entTrace = LocalPlayer( ):GetEyeTrace( ).Entity -- Check if there's an entity in our view.
		if ( entTrace and IsValid( entTrace ) and input.IsKeyDown( KEY_LSHIFT ) ) then -- Is the player holding down shift and there's an entity.
			if ( entTrace:GetClass( ) == "npc_siamesecat" ) then
				-- Life Bar
				draw.RoundedBoxEx( 2, ScrW( ) * 0.309, ScrH( ) * 0.845, ScrW( ) * 0.11, ScrH( ) * 0.025, Color( 192, 57, 43, 255 ), true, true, true, true )
				draw.RoundedBoxEx( 2, ScrW( ) * 0.309, ScrH( ) * 0.845, ( entTrace.curLife or 0 ) / 10 * ( ScrW( ) * 0.11 ), ScrH( ) * 0.025, Color( 46, 204, 113, 255 ), true, true, true, true )
				-- Hunger Bar
				draw.RoundedBoxEx( 2, ScrW( ) * 0.309, ScrH( ) * 0.908, ScrW( ) * 0.11, ScrH( ) * 0.025, Color( 230, 126, 34, 255 ), true, true, true, true )
				draw.RoundedBoxEx( 2, ScrW( ) * 0.309, ScrH( ) * 0.908, math.Clamp( ( entTrace.curHunger or 0 ), 1, 100 ) / 100 * ( ScrW( ) * 0.11 ), ScrH( ) * 0.025, Color( 241, 196, 15, 255 ), true, true, true, true )
				-- Hydration Bar
				draw.RoundedBoxEx( 2, ScrW( ) * 0.45, ScrH( ) * 0.845, ScrW( ) * 0.105, ScrH( ) * 0.025, Color( 45, 45, 180, 255 ), true, true, true, true )
				draw.RoundedBoxEx( 2, ScrW( ) * 0.45, ScrH( ) * 0.845, math.Clamp( ( entTrace.curHydration or 0 ), 1, 100 ) / 100 * ( ScrW( ) * 0.105 ), ScrH( ) * 0.025, Color( 125, 125, 255, 255 ), true, true, true, true )
				-- Fatigue Bar
				draw.RoundedBoxEx( 2, ScrW( ) * 0.45, ScrH( ) * 0.903, ScrW( ) * 0.105, ScrH( ) * 0.025, Color( 44, 62, 80, 255 ), true, true, true, true )
				draw.RoundedBoxEx( 2, ScrW( ) * 0.45, ScrH( ) * 0.903, math.Clamp( ( entTrace.curFatigue or 0 ), 1, 100 ) / 100 * ( ScrW( ) * 0.105 ), ScrH( ) * 0.025, Color( 142, 68, 173, 255 ), true, true, true, true )
				local texturedQuadStructure =
				{
					texture = surface.GetTextureID( 'hud/npc_siamesecat_statindicator' ),
					color   = Color( 255, 255, 255, 255 ),
					x 	= ScrW( ) / 3.5,
					y 	= ScrH( ) * 0.410,
					w 	= ScrW( ) / 3,
					h 	= ScrH( ) * 0.6
				}
				draw.TexturedQuad( texturedQuadStructure )
				draw.SimpleTextOutlined( entTrace.curAge, "NPC_SiameseCat_StatFont", ScrW( ) * 0.585, ScrH( ) * 0.9625, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 52, 152, 219, 255 ) )
				local followTarget = entTrace.followTarget
				if ( !IsValid( followTarget ) or followTarget:IsWorld( ) ) then -- For some reason, the follow target can get set to world.
					followTarget = "Nobody"
				else
					followTarget = followTarget:Name( )
				end
				-- Indicates if someone owns the cat or not.
				draw.SimpleTextOutlined( followTarget, "NPC_SiameseCat_StatFont", ScrW( ) * 0.435, ScrH( ) * 0.98, Color( 52, 152, 219, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 255, 255, 255, 255 ) )
			elseif ( entTrace:GetClass( ) == "ent_catfood" ) then
				draw.RoundedBoxEx( 2, ScrW( ) * 0.349, ScrH( ) * 0.935, ScrW( ) * 0.20, ScrH( ) * 0.027, Color( 230, 126, 34, 255 ), true, true, true, true )
				draw.RoundedBoxEx( 2, ScrW( ) * 0.349, ScrH( ) * 0.935, ( entTrace:GetFoodAmount( ) or 0 ) / 100 * ( ScrW( ) * 0.20 ), ScrH( ) * 0.027, Color( 241, 196, 15, 255 ), true, true, true, true )
				local texturedQuadStructure =
				{
					texture = surface.GetTextureID( 'hud/ent_catfood_remainingfood' ),
					color   = Color( 255, 255, 255, 255 ),
					x 	= ScrW( ) / 3.5,
					y 	= ScrH( ) * 0.410,
					w 	= ScrW( ) / 3,
					h 	= ScrH( ) * 0.6
				}
				draw.TexturedQuad( texturedQuadStructure )
				-- Display a status bar showing how much food remains.
			elseif ( entTrace:GetClass( ) == "ent_waterbowl" ) then
				draw.RoundedBoxEx( 2, ScrW( ) * 0.349, ScrH( ) * 0.935, ScrW( ) * 0.20, ScrH( ) * 0.025, Color( 41, 128, 185, 255 ), true, true, true, true )
				draw.RoundedBoxEx( 2, ScrW( ) * 0.349, ScrH( ) * 0.935, ( entTrace:GetRemainingWater( ) or 0 ) / 100 * ( ScrW( ) * 0.20 ), ScrH( ) * 0.025, Color( 52, 152, 219, 255 ), true, true, true, true )
				local texturedQuadStructure =
				{
					texture = surface.GetTextureID( 'hud/ent_waterbowl_remainingwater' ),
					color   = Color( 255, 255, 255, 255 ),
					x 	= ScrW( ) / 3.5,
					y 	= ScrH( ) * 0.410,
					w 	= ScrW( ) / 3,
					h 	= ScrH( ) * 0.6
				}
				draw.TexturedQuad( texturedQuadStructure )
			end
		end
	end
	hook.Add( "HUDPaint", "NPC_SiameseCat_HUDPaint", DrawCatInfo )
end