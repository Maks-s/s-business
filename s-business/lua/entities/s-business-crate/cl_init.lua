include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():Distance( self:GetPos() ) > 300 then return end
	if not self:GetCrateOwner() then return end
	if not IsValid( self:GetCrateOwner() ) then return end

	local Pos = self:GetPos() + self:GetForward() * 20.5 + self:GetUp() * 3
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis( Ang:Up(), 90 )
	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), 0 )

	cam.Start3D2D( Pos, Ang, 0.1 )
		draw.SimpleText( self:GetCrateOwner():Nick(), "S:Business:Roboto:32", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( self:GetBusinessName(), "S:Business:Roboto:18", 0, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end