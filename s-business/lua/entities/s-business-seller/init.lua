AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "" )	
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
end

function ENT:AcceptInput( Name, Activator, Caller )
	if Name == "Use" && IsValid( Caller ) && Caller:IsPlayer() then
		SA.Business:OpenSellerMenu( Caller, self )
	end
end