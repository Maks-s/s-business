function SA.Business:SellerCart( ent )
	if ValidPanel( SA.Business.SellerSideBar ) then
		SA.Business.SellerSideBar:Clear()
	end

	if !SA.Business.List[ ent:GetSellerBusiness() ] then return end 
	if !SA.Business.List[ ent:GetSellerBusiness() ][ 'Sellers' ] then return end 
	if !SA.Business.List[ ent:GetSellerBusiness() ][ 'Sellers' ][ ent:GetSellerName() ] then return end 

	if !ent.Cart then ent.Cart = {} end

    local ContentsList = vgui.Create( "DScrollPanel", SA.Business.SellerSideBar )
	ContentsList:SetSize( SA.Business.SellerSideBar:GetTall(), SA.Business.SellerSideBar:GetTall() )
	ContentsList:SetPos( 5, 30 )

	for k,v in pairs( ent.Cart ) do
		local Bg = vgui.Create( "DPanel", ContentsList)
		Bg:Dock( TOP )
		Bg:DockMargin( 0, 5, 0, 0 )
		Bg:SetSize( 0, 19 )
		Bg.Paint = function() end
		
		local CName = vgui.Create( 'DLabel', Bg )
		CName:SetText( SA.Business.SellersContents[ k ][ 'Name' ] .. " ( x" .. ent.Cart[ k ] .. " )" )
		CName:SetFont( 'S:Business:Roboto:18' )
		CName:SizeToContents()

		local Undo = vgui.Create( "S:Business:DButton", Bg )
		Undo:SetSize( 25, 15 )
		Undo:SetPos( SA.Business.SellerSideBar:GetWide() - Undo:GetWide() - 10, 2 )
		Undo:SetText( "-" )
		Undo:BackgroundColor( SA.Business.Red )
		Undo.DoClick = function()
			if ent.Cart[ k ] - 1 <= 0 then
				ent.Cart[ k ] = nil
			else
				ent.Cart[ k ] = ent.Cart[ k ] - 1 
			end

			SA.Business:SellerCart( ent )
		end
	end	
end

net.Receive( "S:Business:OpenSellerMenu", function()
	local ent = net.ReadEntity()

	SA.Business.SellerBase = vgui.Create( "DFrame" )
	SA.Business.SellerBase:SetSize( 900, 500 )
	SA.Business.SellerBase:Center()
	SA.Business.SellerBase:SetTitle( '' )
	SA.Business.SellerBase:ShowCloseButton( false )
	SA.Business.SellerBase:MakePopup()
	SA.Business.SellerBase.Paint = function( self, w, h ) 
		SA.Business:DrawBlur( self, 6, 25 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 47, 59, 225 ) )
		draw.RoundedBox( 0, 0, 0, w, 40, Color( 27, 37, 47 ) )

		draw.RoundedBox( 0, 0, 40, 220, h - 40, Color( 27, 37, 47 ) )

		draw.SimpleText( LocalPlayer():Nick(), "S:Business:Roboto:24", 40, 40 / 2, color_white, 0, 1 )

		draw.SimpleText( SA.Business:GetLanguage( "Cart" ) .. " :", "S:Business:Roboto:18", 5, 50, color_white, 0, 0 )
	end
	SA.Business.SellerBase.OnRemove = function()
		SA.Business.NotifyList = {}
	end

	local CloseBtn = vgui.Create( "DButton", SA.Business.SellerBase )
	CloseBtn:SetSize( 32, 32 )
	CloseBtn:SetPos( SA.Business.SellerBase:GetWide() - CloseBtn:GetWide() - 5, 4 )
	CloseBtn:SetText( '' )
	CloseBtn.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, SA.Business.Red )

		draw.SimpleText( "X", "Trebuchet18", w / 2, h / 2, color_white, 1, 1 )
	end
	CloseBtn.DoClick = function()
		SA.Business.SellerBase:Remove()
	end

	local Avatar = vgui.Create( "AvatarImage", SA.Business.SellerBase )
	Avatar:SetSize( 32, 32 )
	Avatar:SetPos( 5, 5 )
	Avatar:SetPlayer( LocalPlayer(), 64 )

	SA.Business.SellerSideBar = vgui.Create( "DPanel", SA.Business.SellerBase )
	SA.Business.SellerSideBar:SetSize( 220, SA.Business.SellerBase:GetTall() - 40 )
	SA.Business.SellerSideBar:SetPos( 0, 40 )	
	SA.Business.SellerSideBar.Paint = function() end

	SA.Business:SellerCart( ent )

	surface.SetFont( "S:Business:Roboto:18" )
	local fontw, fonth = surface.GetTextSize( SA.Business:GetLanguage( "Cart" ) .. " :" )

	local Buy = vgui.Create( "S:Business:DButton", SA.Business.SellerBase )
	Buy:SetSize( 100, 15 )
	Buy:SetPos( fontw + 15, 52 )
	Buy:SetText( SA.Business:GetLanguage( "Buy" ) )
	Buy:BackgroundColor( SA.Business.Green )
	Buy.DoClick = function()
		net.Start( "S:Business:Events" )
		net.WriteString( "BuySeller" )
		net.WriteTable( {
			Ent = ent,
			Cart = ent.Cart
		} )
		net.SendToServer()
	end

	if !SA.Business.List[ ent:GetSellerBusiness() ] then return end 
	if !SA.Business.List[ ent:GetSellerBusiness() ][ 'Sellers' ] then return end 
	if !SA.Business.List[ ent:GetSellerBusiness() ][ 'Sellers' ][ ent:GetSellerName() ] then return end 

	if !SA.Business.List[ ent:GetSellerBusiness() ][ 'Sellers' ][ ent:GetSellerName() ][ 'Contents' ] then
		SA.Business.List[ ent:GetSellerBusiness() ][ 'Sellers' ][ ent:GetSellerName() ][ 'Contents' ] = {}
	end

	local ContentsList = vgui.Create( "DScrollPanel", SA.Business.SellerBase )
	ContentsList:SetSize( SA.Business.SellerBase:GetWide() - 230, SA.Business.SellerBase:GetTall() - 125 )
	ContentsList:SetPos( 225, 40 )
    local scrollbar = ContentsList:GetVBar()
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

	local MContents = 0

	if table.Count( SA.Business.List[ ent:GetSellerBusiness() ][ 'Sellers' ][ ent:GetSellerName() ][ 'Contents' ] ) >= 9 then
		MContents = 15
	end

	for k,v in pairs( SA.Business.List[ ent:GetSellerBusiness() ][ 'Sellers' ][ ent:GetSellerName() ][ 'Contents' ] ) do
		local Background = vgui.Create( "DPanel", ContentsList )
		Background:SetSize( ContentsList:GetWide(), 35 )
		Background:Dock( TOP )
		Background:DockMargin( 0, 5, 0, 0 )
		Background.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 ) )

			draw.SimpleText( SA.Business.SellersContents[ k ][ 'Name' ] .. " ( " .. DarkRP.formatMoney( tonumber( v[ 'Price' ] ) ) .. " )", "S:Business:Roboto:18", 10, h / 2, color_white, 0, 1 )
		end

		local AddToCart = vgui.Create( "S:Business:DButton", Background )
		AddToCart:SetSize( 150, 25 )
		AddToCart:SetPos( ContentsList:GetWide() - AddToCart:GetWide() - 5 - MContents, 5 )
		AddToCart:SetText( SA.Business:GetLanguage( "Add" ) )
		AddToCart:BackgroundColor( SA.Business.Red )
		AddToCart.DoClick = function()
			if !ent.Cart then ent.Cart = {} end

			local Amount = 0

			if ent.Cart[ k ] then
				Amount = Amount + ent.Cart[ k ]
			end

			ent.Cart[ k ] = Amount + 1

			SA.Business:SellerCart( ent )
		end
	end
end)