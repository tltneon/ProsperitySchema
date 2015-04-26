/*******************
 *
 *                              Unbreakable STool
 *
 *
 *   Date   : 28  janvier 2007			Date	: 04 December 2013
 *
 *   Auteur : Chaussette™			Author	: XxWestKillzXx
 *
 *******************************************************************************/

if( SERVER ) then
    // Comment this line if you don't want to send this stool to clients
    AddCSLuaFile( "weapons/gmod_tool/stools/unbreakable.lua" )
    
    
    local function PlayerInitialSpawn()
        
        FilterDamage = ents.Create( "filter_activator_name" )
        
        FilterDamage:SetKeyValue( "TargetName", "FilterDamage" )
        FilterDamage:SetKeyValue( "negated", "1" )
        FilterDamage:Spawn()
        
        hook.Remove( "PlayerInitialSpawn", "Unbreakable_PlayerInitialSpawn" )
    end
    hook.Add( "PlayerInitialSpawn", "Unbreakable_PlayerInitialSpawn", PlayerInitialSpawn )
    
    
    
    
    function TOOL:Unbreakable( Element, Value )
        
        local Filter = ""
        if( Value ) then Filter = "FilterDamage" end
        
        if( Element && Element:IsValid() ) then
            
            Element:SetVar( "Unbreakable", Value )
            Element:Fire  ( "SetDamageFilter", Filter, 0 )
        end
    end
    
    
    
    
    function TOOL:Run( Element, Value )
        
        if( Element && Element:IsValid() && ( Element:GetVar( "Unbreakable" ) != Value )) then
            
            self:Unbreakable( Element, Value )
            
            if( Element.Constraints ) then
                
                for x, Constraint in pairs( Element.Constraints ) do
                    for x = 1, 4, 1 do
                        
                        if( Constraint[ "Ent" .. x ] ) then self:Run( Constraint[ "Ent" .. x ], Value ) end
                    end
                end
            end
        end
    end
end


TOOL.Category		= "Constraints"
TOOL.Name		= "Unbreakable"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "toggle" ] = "1"


if ( CLIENT ) then
    
    language.Add( "tool.unbreakable.name", "Unbreakable" )
    language.Add( "tool.unbreakable.desc", "Make a prop unbreakable" )
    language.Add( "tool.unbreakable.0", "Left click to make a prop unbreakable. Right click to restore its previous settings" )
    language.Add( "tool.unbreakable.toggle", "I'm Broken YAY!" )
end




function TOOL:Action( Element, Value )
    
    if( Element && Element:IsValid() ) then
        
        if( CLIENT ) then return true end
        
        if( self:GetClientNumber( "help" ) == 0 ) then
            
            self:Unbreakable( Element, Value )
        else
            
            self:Run( Element, Value )
        end
        
        return true
    end
    
    return false
end




function TOOL:LeftClick( Target )
    
    return self:Action( Target.Entity, true )
end


function TOOL:RightClick( Target )
    
    return self:Action( Target.Entity, false )
end

function TOOL.BuildCPanel( Panel )
    
    Panel:AddControl( "Header", { Text = "#tool.unbreakable.name", Description = "#tool.unbreakable.desc" }  )
    Panel:AddControl( "Checkbox", { Label = "#tool.unbreakable.toggle", Command = "#unbreakable.toggle" } )
end
