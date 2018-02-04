function SA.Business:AddContentToSeller( strBusiness, strSeller )
	if ValidPanel( SA.Business.BaseAddContentToSeller ) then SA.Business.BaseAddContentToSeller:Remove() end
	if !SA.Business.List[ strBusiness ] then return end
	if !SA.Business.List[ strBusiness ][ 'Sellers' ] then return end
	if !SA.Business.List[ strBusiness ][ 'Sellers' ][ strSeller ] then return end
	
	local Index = ""

	SA.Business.BaseAddContentToSeller = vgui.Create( "DFrame" )
	SA.Business.BaseAddContentToSeller:SetSize( 500, 155 )
	SA.Business.BaseAddContentToSeller:Center()
	SA.Business.BaseAddContentToSeller:SetTitle( '' )
	SA.Business.BaseAddContentToSeller:MakePopup()
	SA.Business.BaseAddContentToSeller.Paint = function( self, w, h ) 
		SA.Business:DrawBlur( self, 6, 25 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 47, 59, 225 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 27, 37, 47 ) )
	end

	local Content = vgui.Create( "DComboBox", SA.Business.BaseAddContentToSeller )
	Content:SetSize( SA.Business.BaseAddContentToSeller:GetWide() - 10, 25 )
	Content:SetPos( 5, 30 )
	Content:SetValue( "Choissisez un contenu..." )
	for k,v in pairs( SA.Business.SellersContents ) do
		Content:AddChoice( v[ 'Name' ] .. " ( " .. DarkRP.formatMoney( v[ 'Price' ] ) .. " )", k )
	end
	Content.OnSelect = function( index, value, data )
		Index = Content:GetOptionData( value )
	end

	local ContentAmount = vgui.Create( "DTextEntry", SA.Business.BaseAddContentToSeller )
	ContentAmount:SetSize( SA.Business.BaseAddContentToSeller:GetWide() - 10, 25 )
	ContentAmount:SetPos( 5, 60 )
	ContentAmount:SetValue( "Montant..." )
	ContentAmount:SetNumeric( true )
	ContentAmount.OnGetFocus = function( self ) if self:GetText() == "Montant..." then self:SetText( '' ) end end
	ContentAmount.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( "Montant..." ) end end

	local ContentPrice = vgui.Create( "DTextEntry", SA.Business.BaseAddContentToSeller )
	ContentPrice:SetSize( SA.Business.BaseAddContentToSeller:GetWide() - 10, 25 )
	ContentPrice:SetPos( 5, 90 )
	ContentPrice:SetValue( "Prix de vente..." )
	ContentPrice:SetNumeric( true )
	ContentPrice.OnGetFocus = function( self ) if self:GetText() == "Prix de vente..." then self:SetText( '' ) end end
	ContentPrice.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( "Prix de vente..." ) end end

	local AddContent = vgui.Create( "S:Business:DButton", SA.Business.BaseAddContentToSeller )
	AddContent:SetSize( SA.Business.BaseAddContentToSeller:GetWide() - 10, 30 )
	AddContent:SetPos( 5, 120 )
	AddContent:SetText( "" )
	AddContent.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, self.BgColor )
			
			self.Lerp = Lerp( 0.05, self.Lerp, w )
			draw.RoundedBox( 0, 0, 0, self.Lerp, h, Color( 255, 255, 255, 10 ) )
		else
			draw.RoundedBox( 0, 0, 0, self:GetWide(), h, self.BgColor )
			
			self.Lerp = Lerp( 0.05, self.Lerp, 0 )
			draw.RoundedBox( 0, 0, 0, self.Lerp, h, Color( 255, 255, 255, 10 ) )
		end

		if SA.Business.SellersContents[ Index ] && ContentAmount:GetValue() ~= nil && ContentAmount:GetValue() ~= "" && tonumber( ContentAmount:GetValue() ) && ContentAmount:GetValue() ~= "Montant..." && tonumber( ContentAmount:GetValue() ) > 0 then
			draw.SimpleText( SA.Business:GetLanguage( "Add" ) .. " ( " .. DarkRP.formatMoney( SA.Business.SellersContents[ Index ][ 'Price' ] * tonumber( ContentAmount:GetValue() ) ) .. " )", "S:Business:Roboto:18", w / 2, h / 2, color_white, 1, 1 )
		else
			draw.SimpleText( SA.Business:GetLanguage( "Add" ) .. " ( " .. DarkRP.formatMoney( 0 ) .. " )", "S:Business:Roboto:18", w / 2, h / 2, color_white, 1, 1 )
		end
	end
	AddContent.DoClick = function()
		if Content:GetValue() == "" || Content:GetValue() == "Choissisez un contenu..." then return end
		if ContentAmount:GetValue() == "" || ContentAmount:GetValue() == "Montant..." then return end
		if ContentPrice:GetValue() == "" || ContentPrice:GetValue() == "Prix de vente..." then return end

		net.Start( "S:Business:Events" )
		net.WriteString( "AddContentToSeller" )
		net.WriteTable( {
			Business = strBusiness,
			SellerName = strSeller,
			Content = Index,
			Amount = ContentAmount:GetValue(),
			Price = ContentPrice:GetValue()
		} )
		net.SendToServer()

		SA.Business.BaseAddContentToSeller:Remove()
	end	
end

function SA.Business:EditSeller( strBusiness, strSeller )
	if ValidPanel( SA.Business.BaseEditSeller ) then SA.Business.BaseEditSeller:Remove() end
	if !SA.Business.List[ strBusiness ] then return end
	if !SA.Business.List[ strBusiness ][ 'Sellers' ] then return end
	if !SA.Business.List[ strBusiness ][ 'Sellers' ][ strSeller ] then return end
	
	SA.Business.BaseEditSeller = vgui.Create( "DFrame" )
	SA.Business.BaseEditSeller:SetSize( 500, 95 )
	SA.Business.BaseEditSeller:Center()
	SA.Business.BaseEditSeller:SetTitle( '' )
	SA.Business.BaseEditSeller:MakePopup()
	SA.Business.BaseEditSeller.Paint = function( self, w, h ) 
		SA.Business:DrawBlur( self, 6, 25 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 47, 59, 225 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 27, 37, 47 ) )
	end

	local SellerModel = vgui.Create( "DTextEntry", SA.Business.BaseEditSeller )
	SellerModel:SetSize( SA.Business.BaseEditSeller:GetWide() - 10, 25 )
	SellerModel:SetPos( 5, 30 )
	SellerModel:SetText( SA.Business.List[ strBusiness ][ 'Sellers' ][ strSeller ][ 'Model' ] )

	local Edit = vgui.Create( "S:Business:DButton", SA.Business.BaseEditSeller )
	Edit:SetSize( SA.Business.BaseEditSeller:GetWide() - 10, 30 )
	Edit:SetPos( 5, 60 )
	Edit:SetText( SA.Business:GetLanguage( "Edit" ) )
	Edit.DoClick = function()
		if !util.IsValidModel( SellerModel:GetValue() ) then
			SA.Business:AddNotify( SA.Business:GetLanguage( "InvalidModel" ), SA.Business.Red, 3 )
			return
		end

		net.Start( "S:Business:Events" )
		net.WriteString( "EditSeller" )
		net.WriteTable( {
			Business = strBusiness,
			SellerName = strSeller,
			SellerModel = SellerModel:GetValue(),
		} )
		net.SendToServer()

		SA.Business.BaseEditSeller:Remove()
	end
end

function SA.Business:ManageSellers( strBusiness )
	if !ValidPanel( SA.Business.Bg ) then return end
	if !SA.Business.List[ strBusiness ] then return end
	if !SA.Business.List[ strBusiness ][ 'Sellers' ] then SA.Business.List[ strBusiness ][ 'Sellers' ] = {} end


	SA.Business.SellersList = vgui.Create( "DScrollPanel", SA.Business.Bg )
	SA.Business.SellersList:SetSize( SA.Business.Bg:GetWide(), SA.Business.Bg:GetTall() - 90 )
	SA.Business.SellersList:SetPos( 0, - 5 )
    local scrollbar = SA.Business.SellersList:GetVBar()
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

	local MSellers = 0

	if table.Count( SA.Business.List[ strBusiness ][ 'Sellers' ] ) >= 10 then
		MSellers = 15
	end

	for k,v in pairs( SA.Business.List[ strBusiness ][ 'Sellers' ] ) do
		local Background = vgui.Create( "DPanel", SA.Business.SellersList )
		Background:SetSize( SA.Business.SellersList:GetWide(), 35 )
		Background:Dock( TOP )
		Background:DockMargin( 0, 5, 0, 0 )
		Background.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 ) )

			draw.SimpleText( k, "S:Business:Roboto:18", 10, h / 2, color_white, 0, 1 )
		end

		local AddContents = vgui.Create( "S:Business:DButton", Background )
		AddContents:SetSize( 150, 25 )
		AddContents:SetPos( SA.Business.SellersList:GetWide() - AddContents:GetWide() - ( 150 * 2 )  - 15 - MSellers, 5 )
		AddContents:SetText( SA.Business:GetLanguage( "Add" ) )
		AddContents:BackgroundColor( SA.Business.Green )
		AddContents.DoClick = function()
			SA.Business:AddContentToSeller( strBusiness, k )
		end				

		local Edit = vgui.Create( "S:Business:DButton", Background )
		Edit:SetSize( 150, 25 )
		Edit:SetPos( SA.Business.SellersList:GetWide() - Edit:GetWide() - 150  - 10 - MSellers, 5 )
		Edit:SetText( SA.Business:GetLanguage( "Edit" ) )
		Edit:BackgroundColor( SA.Business.Orange )
		Edit.DoClick = function()
			SA.Business:EditSeller( strBusiness, k )
		end		

		local Delete = vgui.Create( "S:Business:DButton", Background )
		Delete:SetSize( 150, 25 )
		Delete:SetPos( SA.Business.SellersList:GetWide() - Delete:GetWide() - 5 - MSellers, 5 )
		Delete:SetText( SA.Business:GetLanguage( "Delete" ) )
		Delete:BackgroundColor( SA.Business.Red )
		Delete.DoClick = function()
			net.Start( "S:Business:Events" )
			net.WriteString( "DeleteSeller" )
			net.WriteTable( {
				Business = strBusiness,
				SellerName = k,
			} )
			net.SendToServer()
		end
	end

	local SellerName = vgui.Create( "DTextEntry", SA.Business.Bg )
	SellerName:SetSize( SA.Business.Bg:GetWide(), 25 )
	SellerName:SetPos( 0, SA.Business.Bg:GetTall() - 90 )
	SellerName:SetText( 'Entrez le nom du vendeur...' )
	SellerName.OnGetFocus = function( self ) if self:GetText() == "Entrez le nom du vendeur..." then self:SetText( '' ) end end
	SellerName.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( "Entrez le nom du vendeur..." ) end end

	local SellerModel = vgui.Create( "DTextEntry", SA.Business.Bg )
	SellerModel:SetSize( SA.Business.Bg:GetWide(), 25 )
	SellerModel:SetPos( 0, SA.Business.Bg:GetTall() - 60 )
	SellerModel:SetText( "Entrez le model du vendeur..." )
	SellerModel.OnGetFocus = function( self ) if self:GetText() == "Entrez le model du vendeur..." then self:SetText( '' ) end end
	SellerModel.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( "Entrez le model du vendeur..." ) end end

	local SellerCreate = vgui.Create( "S:Business:DButton", SA.Business.Bg )
	SellerCreate:SetSize( SA.Business.Bg:GetWide(), 30 )
	SellerCreate:SetPos( 0, SA.Business.Bg:GetTall() - 30 )
	SellerCreate:SetText( SA.Business:GetLanguage( "Add" ) )
	SellerCreate.DoClick = function()
		if SellerName:GetValue() == "" || SellerName:GetValue() == "Entrez le nom du vendeur..." then return end
		if SellerModel:GetValue() == "" || SellerModel:GetValue() == "Entrez le model du vendeur..." then return end

		net.Start( "S:Business:Events" )
		net.WriteString( "AddSeller" )
		net.WriteTable( {
			Business = strBusiness,
			SellerName = SellerName:GetValue(),
			SellerModel = SellerModel:GetValue()
		} )
		net.SendToServer()
	end
end