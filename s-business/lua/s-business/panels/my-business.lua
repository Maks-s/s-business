function SA.Business:MyBusiness()
	if !ValidPanel( SA.Business.Bg ) then return end

	SA.Business.MyBusinessList = vgui.Create( "DScrollPanel", SA.Business.Bg )
	SA.Business.MyBusinessList:SetSize( SA.Business.Bg:GetWide(), SA.Business.Bg:GetTall() - 60 )
	SA.Business.MyBusinessList:SetPos( 0, - 5 )
    local scrollbar = SA.Business.MyBusinessList:GetVBar()
    function scrollbar:Paint( w, h)
        draw.RoundedBox( 3, 5, 5, 10, h, Color( 41, 47, 59, 225 ) )
    end
    function scrollbar.btnUp:Paint( w, h )
        draw.RoundedBox( 3, 5, 5, 10, h, Color( 27, 37, 47 ) )
    end
    function scrollbar.btnDown:Paint( w, h )
        draw.RoundedBox( 3, 5, 5, 10, h, Color( 27, 37, 47 ) )
    end
    function scrollbar.btnGrip:Paint( w, h )
        draw.RoundedBox( 3, 5, 5, 10, h, Color( 27, 37, 47 ) )
    end

    local MyBusiness = {}

	for k,v in pairs( SA.Business.List ) do
		if v[ 'Owner' ] == LocalPlayer():SteamID() then
			MyBusiness[ k ] = v
		end
	end

	local MBusiness = 0

	if table.Count( MyBusiness ) >= 10 then
		MBusiness = 15
	end

	for k,v in pairs( MyBusiness ) do
		local Background = vgui.Create( "DPanel", SA.Business.MyBusinessList )
		Background:SetSize( SA.Business.MyBusinessList:GetWide(), 35 )
		Background:Dock( TOP )
		Background:DockMargin( 0, 5, 0, 0 )
		Background.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 ) )

			draw.SimpleText( k, "S:Business:Roboto:18", 10, h / 2, color_white, 0, 1 )
		end

		local Delete = vgui.Create( "S:Business:DButton", Background )
		Delete:SetSize( 150, 25 )
		Delete:SetPos( SA.Business.MyBusinessList:GetWide() - Delete:GetWide() - 5 - MBusiness, 5 )
		Delete:SetText( SA.Business:GetLanguage( "Delete" ) )
		Delete:BackgroundColor( SA.Business.Red )
		Delete.DoClick = function()
			net.Start( "S:Business:Events" )
			net.WriteString( "DeleteBusiness" )
			net.WriteTable( {
				Name = k
			} )
			net.SendToServer()
		end
	end
	
	local BName = vgui.Create( "DTextEntry", SA.Business.Bg )
	BName:SetSize( SA.Business.Bg:GetWide(), 25 )
	BName:SetPos( 0, SA.Business.Bg:GetTall() - 60 )
	BName:SetText( "Entrez un nom valide..." )
	BName.OnGetFocus = function( self ) if self:GetText() == "Entrez un nom valide..." then self:SetText( '' ) end end
	BName.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( "Entrez un nom valide..." ) end end

	local Create = vgui.Create( "S:Business:DButton", SA.Business.Bg )
	Create:SetSize( SA.Business.Bg:GetWide(), 30 )
	Create:SetPos( 0, SA.Business.Bg:GetTall() - 30 )
	Create:SetText( SA.Business:GetLanguage( "Create" ) )
	Create.DoClick = function()
		if BName:GetValue() == "" || BName:GetValue() == "Entrez un nom valide..." then return end
		
		net.Start( "S:Business:Events" )
		net.WriteString( "CreateBusiness" )
		net.WriteTable( {
			Name = BName:GetValue()
		} )
		net.SendToServer()
	end
end