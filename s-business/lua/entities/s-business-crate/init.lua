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
	if not self.tblContents then self.tblContents = {} end

	if self.tblContents[ strItem ] then
		self.tblContents[ strItem ] = self.tblContents[ strItem ] + intAmount
	else
		self.tblContents[ strItem ] = intAmount
	end
end

function ENT:AcceptInput( Name, Activator, Caller )
	if Name == "Use" && IsValid( Caller ) && Caller:IsPlayer() then
		if self:GetCrateOwner() != Caller then return end
		
		if not self.tblContents then self.tblContents = {} end

		net.Start( "S:Business:OpenMenuCrate" )
		net.WriteEntity( self )
		net.WriteTable( self.tblContents )
		net.Send( Caller )
	end
end