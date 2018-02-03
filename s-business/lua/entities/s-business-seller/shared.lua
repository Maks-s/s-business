ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "NPC Seller"
ENT.Category 		= "SlownLS | S-Business"
ENT.Author			= "SlownLS"
ENT.Instructions = "Appuyer sur E (Touche 'USE')" 
ENT.Spawnable = false 
ENT.AdminSpawnable = true 

function ENT:SetupDataTables() 
	self:NetworkVar( "String", 0, "SellerBusiness" )
	self:NetworkVar( "String", 1, "SellerName" )
end