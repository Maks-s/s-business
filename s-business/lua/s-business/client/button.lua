local PANEL = {}

function PANEL:Init()
	self:SetText( '' )
	self:SetFont( 'S:Business:Roboto:18' )
	self:SetTextColor( color_white )
	self.Lerp = 0
	self.BgColor = Color( 27, 37, 47 )
end

function PANEL:BackgroundColor( color )
	self.BgColor = color
end

function PANEL:OnCursorEntered()
	self:SetTextColor( color_white )
end

function PANEL:OnCursorExited()
	self:SetTextColor( color_white )
end

function PANEL:Paint()
	if self:IsHovered() then
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), self.BgColor )
		
		self.Lerp = Lerp( 0.05, self.Lerp, self:GetWide() )
		draw.RoundedBox( 0, 0, 0, self.Lerp, self:GetTall(), Color( 255, 255, 255, 10 ) )
	else
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), self.BgColor )
		
		self.Lerp = Lerp( 0.05, self.Lerp, 0 )
		draw.RoundedBox( 0, 0, 0, self.Lerp, self:GetTall(), Color( 255, 255, 255, 10 ) )
	end
end
vgui.Register( 'S:Business:DButton', PANEL ,'DButton' )

