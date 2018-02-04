ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'Crate'
ENT.Category = 'GServ | S-Business'
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( 'Entity', 0, 'CrateOwner' )
	self:NetworkVar( 'String', 1, 'BusinessName' )
end
