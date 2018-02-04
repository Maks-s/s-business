net.Receive( "S:Business:OpenMenuCrate", function()
	local Ent = net.ReadEntity()
	local tblContents = net.ReadTable()

	local Base = vgui.Create( "DFrame" )
	Base:SetSize( 900, 500 )
	Base:Center()
	Base:SetTitle( '' )
	Base:MakePopup()
	Base:ShowCloseButton( false )
	Base.Paint = function( self, w, h ) 
		SA.Business:DrawBlur( self, 6, 25 )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 47, 59, 225 ) )
		draw.RoundedBox( 0, 0, 0, w, 40, Color( 27, 37, 47 ) )
	end

	local CloseBtn = vgui.Create( "DButton", Base )
	CloseBtn:SetSize( 32, 32 )
	CloseBtn:SetPos( Base:GetWide() - CloseBtn:GetWide() - 5, 4 )
	CloseBtn:SetText( '' )
	CloseBtn.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, SA.Business.Red )

		draw.SimpleText( "X", "Trebuchet18", w / 2, h / 2, color_white, 1, 1 )
	end
	CloseBtn.DoClick = function()
		Base:Remove()
	end	

	local ContentsList = vgui.Create( "DScrollPanel", Base )
	ContentsList:SetSize( Base:GetWide() - 10, Base:GetTall() - 50 )
	ContentsList:SetPos( 5, 50 )
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

    local MContent = 0

    if table.Count( tblContents ) > 10 then
    	MContent = 15
    end

	for k,v in pairs( tblContents ) do
		if !SA.Business.SellersContents[ k ] then continue end

	 	local Bg = vgui.Create( "DPanel", ContentsList )
	 	Bg:SetSize( 0, 64 )
 		Bg:Dock( TOP )
 		Bg:DockMargin( 0, 5, 0, 0 )
 		Bg.Paint = function( self, w, h ) 
 			draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 ) )

 			draw.SimpleText( SA.Business.SellersContents[ k ][ 'Name' ] .. "  ( x" .. v .. " )", "S:Business:Roboto:18", 84, h / 2, color_white, 0, 1 )
 		end

 		local Mdl = vgui.Create( "SpawnIcon", Bg )
 		Mdl:SetSize( 64, 64 )
 		Mdl:SetPos( 5, 0 )
 		Mdl:SetModel( SA.Business.SellersContents[ k ][ 'Model' ] )
 		Mdl:SetTooltip()
 		Mdl.OnMousePressed = function() end
 		Mdl.IsHovered = function() end

 		local TakeContent = vgui.Create( "S:Business:DButton", Bg )
		TakeContent:SetSize( 150, 35 )
		TakeContent:SetPos( ContentsList:GetWide() - TakeContent:GetWide() - 13 - MContent, Bg:GetTall() / 2 - ( TakeContent:GetTall() / 2 ) )
		TakeContent:SetText( SA.Business:GetLanguage( "Take" ) )
		TakeContent:BackgroundColor( SA.Business.Green )
		TakeContent.DoClick = function()
			net.Start( "S:Business:Events" )
			net.WriteString( "SpawnContent" )
			net.WriteTable( {
				Ent = Ent,
				Content = k,
			} )
			net.SendToServer()

			Base:Remove()
		end	
	end
end)