function SA.Business:ManageChoice( strBusiness )
	local ManageChoice = {
		[ 1 ] = {
			Name = SA.Business:GetLanguage( "Employee" ),
			Perm = "Manage Employees",
			Action = function( strBusiness )
				SA.Business:ManageEmployees( strBusiness )
			end
		},

		[ 2 ] = {
			Name = SA.Business:GetLanguage( "Seller" ),
			Perm = "Manage Sellers",
			Action = function( strBusiness )
				SA.Business:ManageSellers( strBusiness )
			end
		}
	}

	if !ManageChoice then return end

	local MList = vgui.Create( "DScrollPanel", SA.Business.Bg )
	MList:SetSize( SA.Business.Bg:GetWide(), SA.Business.Bg:GetTall() + 5 )
	MList:SetPos( 0, - 5 )
    local scrollbar = MList:GetVBar()
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

	local MarginManageChoice = 0

	if table.Count( ManageChoice ) >= 12 then
		MarginManageChoice = 15
	end

	for k,v in SortedPairs( ManageChoice , false ) do
		if SA.Business.List[ strBusiness ][ 'Owner' ] ~= LocalPlayer():SteamID() && SA.Business.List[ strBusiness ]['Employees'][ LocalPlayer():SteamID() ][ 'Perms' ][ v['Perm' ] ] ~= 1 then continue end
		local Background = vgui.Create( "DPanel", MList )
		Background:SetSize( MList:GetWide(), 35 )
		Background:Dock( TOP )
		Background:DockMargin( 0, 5, 0, 0 )
		Background.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 ) )

			draw.SimpleText( v[ 'Name' ], "S:Business:Roboto:18", 10, h / 2, color_white, 0, 1 )
		end

		local Manage = vgui.Create( "S:Business:DButton", Background )
		Manage:SetSize( 150, 25 )
		Manage:SetPos( MList:GetWide() - Manage:GetWide() - 5 - MarginManageChoice, 5 )
		Manage:SetText( SA.Business:GetLanguage( "Manage" ) )
		Manage:BackgroundColor( SA.Business.Red )
		Manage.DoClick = function()
			SA.Business.Bg:Clear()
			v[ 'Action' ]( strBusiness )
		end
	end	
end

function SA.Business:ManageBusiness()
	if !ValidPanel( SA.Business.Bg ) then return end

	local MyBusiness = {}

	for k,v in pairs( SA.Business.List ) do
		MyBusiness[ k ] = v
	end

	if table.Count( MyBusiness ) > 0 then
		local BusinessList = vgui.Create( "DScrollPanel", SA.Business.Bg )
		BusinessList:SetSize( SA.Business.Bg:GetWide(), SA.Business.Bg:GetTall() + 5 )
		BusinessList:SetPos( 0, - 5 )
	    local scrollbar = BusinessList:GetVBar()
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

		local MBusiness = 0

		if table.Count( MyBusiness ) >= 12 then
			MBusiness = 15
		end

		for k,v in pairs( MyBusiness ) do
			local Background = vgui.Create( "DPanel", BusinessList )
			Background:SetSize( BusinessList:GetWide(), 35 )
			Background:Dock( TOP )
			Background:DockMargin( 0, 5, 0, 0 )
			Background.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 ) )

				draw.SimpleText( k, "S:Business:Roboto:18", 10, h / 2, color_white, 0, 1 )
			end

			local Manage = vgui.Create( "S:Business:DButton", Background )
			Manage:SetSize( 150, 25 )
			Manage:SetPos( BusinessList:GetWide() - Manage:GetWide() - 5 - MBusiness, 5 )
			Manage:SetText( SA.Business:GetLanguage( "Choose" ) )
			Manage:BackgroundColor( SA.Business.Red )
			Manage.DoClick = function()
				SA.Business.Bg:Clear()
				SA.Business:ManageChoice( k )
			end
		end
	else
		surface.SetFont( "S:Business:Roboto:18" )

		local width, height = surface.GetTextSize( SA.Business:GetLanguage( "NoBusiness" ) )

		local pMsg = vgui.Create( "DLabel", SA.Business.Bg )
		pMsg:SetPos( SA.Business.Bg:GetWide() / 2 - width / 2, SA.Business.Bg:GetTall() / 2 - height )
		pMsg:SetText( SA.Business:GetLanguage( "NoBusiness" ) )
		pMsg:SetFont( "S:Business:Roboto:18" )
		pMsg:SizeToContents()
	end
end