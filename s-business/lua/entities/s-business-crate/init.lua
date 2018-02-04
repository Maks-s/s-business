AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_junk/wood_crate001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then phys:Wake() end

	self.tblContents = {}
end

function ENT:AddContent( strItem, intAmount )
	if !self.tblContents then self.tblContents = {} end

	self.tblContents[ strItem ] = ( self.tblContents[ strItem ] or 0 ) + intAmount
end

function ENT:Use( _, ply )
	if !( IsValid( ply ) && ply:IsPlayer() ) then return end

	if self:GetCrateOwner() ~= ply then return end
		
	net.Start( "S:Business:OpenMenuCrate" )
	net.WriteEntity( self )
	net.WriteTable( self.tblContents or {} )
	net.Send( ply )
end