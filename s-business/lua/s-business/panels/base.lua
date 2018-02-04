SA.Business.List = SA.Business.List or {}
SA.Business.Perms = SA.Business.Perms or {}
SA.Business.NotifyList = {}

SA.Business.DefaultPerms = {
	['Treasury'] = 1,
	['Disable / Enable Funds'] = 0,
	['Manage Employees'] = 0,
	['Manage Sellers'] = 0,
}

net.Receive( "S:Business:OpenMenu", function()
	local SideBarBtns = {
		[ 1 ] = {
			Name = SA.Business:GetLanguage( "MyBusiness" ),
			Icon = Material( 's-addons/business/icons/house.png' ),
			Action = function()
				SA.Business:MyBusiness()
			end
		},

		[ 2 ] = {
			Name = SA.Business:GetLanguage( "Manage" ),
			Icon = Material( 's-addons/business/icons/settings.png' ),
			Action = function()
				SA.Business:ManageBusiness()
			end
		},

		[ 3 ] = {
			Name = SA.Business:GetLanguage( "Treasury" ),
			Icon = Material( 's-addons/business/icons/money.png' ),
			Action = function()
				SA.Business:TreasuryChoice()
			end
		},
	}

	local SDButtonsHoverd = {}

	SA.Business.Base = vgui.Create( "DFrame" )
	SA.Business.Base:SetSize( 900, 500 )
	SA.Business.Base:Center()
	SA.Business.Base:SetTitle( '' )
	SA.Business.Base:MakePopup()
	SA.Business.Base:ShowCloseButton( false )
	SA.Business.Base.Paint = function( self, w, h ) 
		SA.Business:DrawBlur( self, 6, 25 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 47, 59, 225 ) )
		draw.RoundedBox( 0, 0, 0, w, 40, Color( 27, 37, 47 ) )

		draw.RoundedBox( 0, 0, 40, 220, h - 40, Color( 27, 37, 47 ) )

		draw.SimpleText( LocalPlayer():Nick(), "S:Business:Roboto:24", 40, 40 / 2, color_white, 0, 1 )
	end
	SA.Business.Base.OnRemove = function()
		if ValidPanel( SA.Business.BaseEmployerPerms ) then
			SA.Business.BaseEmployerPerms:Remove()
		end			

		if ValidPanel( SA.Business.BaseEditEmployee ) then
			SA.Business.BaseEditEmployee:Remove()
		end			

		if ValidPanel( SA.Business.BaseEditSeller ) then
			SA.Business.BaseEditSeller:Remove()
		end			

		if ValidPanel( SA.Business.BaseAddContentToSeller ) then
			SA.Business.BaseAddContentToSeller:Remove()
		end	

		if ValidPanel( SA.Business.BaseWithdrawTreasury ) then
			SA.Business.BaseWithdrawTreasury:Remove()
		end

		if ValidPanel( SA.Business.BaseDepositTreasury ) then
			SA.Business.BaseDepositTreasury:Remove()
		end

		SA.Business.NotifyList = {}
	end

	local CloseBtn = vgui.Create( "DButton", SA.Business.Base )
	CloseBtn:SetSize( 32, 32 )
	CloseBtn:SetPos( 863, 4 )
	CloseBtn:SetText( '' )
	CloseBtn.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, SA.Business.Red )

		draw.SimpleText( "X", "Trebuchet18", 16, 16, color_white, 1, 1 )
	end
	CloseBtn.DoClick = function()
		SA.Business.Base:Remove()
	end

	local Avatar = vgui.Create( "AvatarImage", SA.Business.Base )
	Avatar:SetSize( 32, 32 )
	Avatar:SetPos( 5, 5 )
	Avatar:SetPlayer( LocalPlayer(), 64 )

	local SideBarList = vgui.Create( "DScrollPanel", SA.Business.Base )
	SideBarList:SetSize( 220, 460 )
	SideBarList:SetPos( 0, 40 )

	for i=1, #SideBarBtns do
		local SDButtion = vgui.Create( "DButton", SideBarList )
		SDButtion:SetSize( 220, 41 )
		SDButtion:Dock( TOP )
		SDButtion:SetText( "" )
		function SDButtion:Paint( w, h )
			if self:IsHovered() || SDButtonsHoverd[ i ] == "Yes" then
				draw.RoundedBox( 0, 0, 0, w, h, SA.Business.Red )
			end

			surface.SetDrawColor( color_white )
			surface.SetMaterial( SideBarBtns[ i ][ 'Icon' ] )
			surface.DrawTexturedRect( 5, 4.5, 32, 32 )

			draw.SimpleText( SideBarBtns[ i ][ 'Name' ], "S:Business:Roboto:18", 42, h / 2, color_white, 0, 1 )
		end
		SDButtion.DoClick = function()
			SA.Business.Bg:Clear()

			for j=1, #SDButtonsHoverd do
				SDButtonsHoverd[ j ] = "No"
			end

			SDButtonsHoverd[ i ] = "Yes"

			SideBarBtns[ i ][ 'Action' ]()
		end			

		SDButtonsHoverd[ i ] = "No"
	end	

	SA.Business.Bg = vgui.Create( "DPanel", SA.Business.Base )
	SA.Business.Bg:SetSize( 670, 450 )
	SA.Business.Bg:SetPos( 225, 45 )
	SA.Business.Bg.Paint = nil

	SDButtonsHoverd[ 1 ] = "Yes"
	SideBarBtns[ 1 ][ 'Action' ]()
end)