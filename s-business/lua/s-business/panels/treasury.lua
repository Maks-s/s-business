function SA.Business:DepositTreasury( strBusiness ) 
	if ValidPanel( SA.Business.BaseDepositTreasury ) then SA.Business.BaseDepositTreasury:Remove() end

	SA.Business.BaseDepositTreasury = vgui.Create( "DFrame" )
	SA.Business.BaseDepositTreasury:SetSize( 500, 95 )
	SA.Business.BaseDepositTreasury:Center()
	SA.Business.BaseDepositTreasury:SetTitle( '' )
	SA.Business.BaseDepositTreasury:MakePopup()
	SA.Business.BaseDepositTreasury.Paint = function( self, w, h ) 
		SA.Business:DrawBlur( self, 6, 25 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 47, 59, 225 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 27, 37, 47 ) )
	end

	local DTAmount = vgui.Create( "DTextEntry", SA.Business.BaseDepositTreasury )
	DTAmount:SetSize( SA.Business.BaseDepositTreasury:GetWide() - 10, 25 )
	DTAmount:SetPos( 5, 30 )
	DTAmount:SetNumeric( true )
	DTAmount:SetText( "Entrez un montant valide..." )
	DTAmount.OnGetFocus = function( self ) if self:GetText() == "Entrez un montant valide..." then self:SetText( "" ) end end
	DTAmount.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( "Entrez un montant valide..." ) end end

	local Deposit = vgui.Create( "S:Business:DButton", SA.Business.BaseDepositTreasury )
	Deposit:SetSize( SA.Business.BaseDepositTreasury:GetWide() - 10, 30 )
	Deposit:SetPos( 5, 60 )
	Deposit:SetText( SA.Business:GetLanguage( "Deposit" ) )
	Deposit.DoClick = function()
		if DTAmount:GetValue() == "" || DTAmount:GetValue() == "Entrez un montant valide..." then return end
		
		net.Start( "S:Business:Events" )
		net.WriteString( "DepositTreasury" )
		net.WriteTable( {
			Business = strBusiness,
			Amount = DTAmount:GetValue() 
		} )
		net.SendToServer()

		SA.Business.BaseDepositTreasury:Remove()
	end
end

function SA.Business:WithdrawTreasury( strBusiness ) 
	if ValidPanel( SA.Business.BaseWithdrawTreasury ) then SA.Business.BaseWithdrawTreasury:Remove() end
	
	SA.Business.BaseWithdrawTreasury = vgui.Create( "DFrame" )
	SA.Business.BaseWithdrawTreasury:SetSize( 500, 95 )
	SA.Business.BaseWithdrawTreasury:Center()
	SA.Business.BaseWithdrawTreasury:SetTitle( '' )
	SA.Business.BaseWithdrawTreasury:MakePopup()
	SA.Business.BaseWithdrawTreasury.Paint = function( self, w, h ) 
		SA.Business:DrawBlur( self, 6, 25 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 47, 59, 225 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 27, 37, 47 ) )
	end

	local WTAmount = vgui.Create( "DTextEntry", SA.Business.BaseWithdrawTreasury )
	WTAmount:SetSize( SA.Business.BaseWithdrawTreasury:GetWide() - 10, 25 )
	WTAmount:SetPos( 5, 30 )
	WTAmount:SetNumeric( true )
	WTAmount:SetText( "Entrez un montant valide..." )
	WTAmount.OnGetFocus = function( self ) if self:GetText() == "Entrez un montant valide..." then self:SetText( "" ) end end
	WTAmount.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( "Entrez un montant valide..." ) end end

	local Withdraw = vgui.Create( "S:Business:DButton", SA.Business.BaseWithdrawTreasury )
	Withdraw:SetSize( SA.Business.BaseWithdrawTreasury:GetWide() - 10, 30 )
	Withdraw:SetPos( 5, 60 )
	Withdraw:SetText( SA.Business:GetLanguage( "Withdraw" ) )
	Withdraw.DoClick = function()
		if WTAmount:GetValue() == "" || WTAmount:GetValue() == "Entrez un montant valide..." then return end
		
		net.Start( "S:Business:Events" )
		net.WriteString( "WithdrawTreasury" )
		net.WriteTable( {
			Business = strBusiness,
			Amount = WTAmount:GetValue() 
		} )
		net.SendToServer()

		SA.Business.BaseWithdrawTreasury:Remove()
	end
end

function SA.Business:Treasury( strBusiness )
	if !ValidPanel( SA.Business.Bg ) then return end

	SA.Business.BaseTreasury = vgui.Create( "DPanel", SA.Business.Bg )
	SA.Business.BaseTreasury:SetSize( 350, 100 )
	SA.Business.BaseTreasury:SetPos( SA.Business.Bg:GetWide() / 2 - ( SA.Business.BaseTreasury:GetWide() / 2 ), 5 )
	SA.Business.BaseTreasury.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 )  )

		draw.SimpleText( "Fonds ( " .. strBusiness .. " )", "S:Business:Roboto:24", w / 2, h / 2 - 15, color_white, 1, 1 )
		draw.SimpleText( DarkRP.formatMoney( tonumber( SA.Business.List[ strBusiness ][ 'Treasury' ] ) ), "S:Business:Roboto:24", w / 2, h / 2 + 15, color_white, 1, 1 )
	end

	local WithdrawMoney = vgui.Create( "S:Business:DButton", SA.Business.Bg )
	WithdrawMoney:SetSize( 350, 30 )
	WithdrawMoney:SetPos( SA.Business.Bg:GetWide() / 2 - ( WithdrawMoney:GetWide() / 2 ), 110 )
	WithdrawMoney:SetText( SA.Business:GetLanguage( "WithdrawFunds" ) )
	WithdrawMoney.DoClick = function()
		SA.Business:WithdrawTreasury( strBusiness ) 
	end

	local DepositMoney = vgui.Create( "S:Business:DButton", SA.Business.Bg )
	DepositMoney:SetSize( 350, 30 )
	DepositMoney:SetPos( SA.Business.Bg:GetWide() / 2 - ( DepositMoney:GetWide() / 2 ), 145 )
	DepositMoney:SetText( SA.Business:GetLanguage( "DepositFunds" ) )
	DepositMoney.DoClick = function()
		SA.Business:DepositTreasury( strBusiness ) 
	end	

	local DisableEnableFunds = vgui.Create( "S:Business:DButton", SA.Business.Bg )
	DisableEnableFunds:SetSize( 350, 30 )
	DisableEnableFunds:SetPos( SA.Business.Bg:GetWide() / 2 - ( DisableEnableFunds:GetWide() / 2 ), 180 )
	DisableEnableFunds:SetText( SA.Business:GetLanguage( "EnableDisableFunds" ) )
	DisableEnableFunds.DoClick = function()
		net.Start( "S:Business:Events" )
		net.WriteString( "DisableEnableFunds" )
		if SA.Business.List[ strBusiness ][ 'TreasuryIsEnable' ] == "false" then
			net.WriteTable( {
				Business = strBusiness,
				Disable = "true"
			} )		
		else
			net.WriteTable( {
				Business = strBusiness,
				Disable = "false"
			} )
		end
		net.SendToServer()		
	end

	local LogsBackground = vgui.Create( "DPanel", SA.Business.Bg )
	LogsBackground:SetSize( SA.Business.Bg:GetWide(), SA.Business.Bg:GetTall() - 215 )
	LogsBackground:SetPos( 0, 215 )
	LogsBackground.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 )  )
	end

	if !SA.Business.List[ strBusiness ][ 'LogsTreasury' ] then return end

	local LogsList = vgui.Create( "DScrollPanel", SA.Business.Bg )
	LogsList:SetSize( SA.Business.Bg:GetWide() - 15, SA.Business.Bg:GetTall() - 215 )
	LogsList:SetPos( 10, 215 )
    local scrollbar = LogsList:GetVBar()
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

	for k,v in SortedPairs( SA.Business.List[ strBusiness ][ 'LogsTreasury' ], true ) do
		local Log = vgui.Create( "DLabel", LogsList )
		Log:Dock( TOP )
		Log:DockMargin( 0, 5, 0, 0 )
		Log:SetPos( 0, 0 )
		Log:SetText( v )
		Log:SetFont( 'S:Business:Roboto:18' )
		Log:SetTextColor( color_white )
	end
end

function SA.Business:TreasuryChoice()
	if !ValidPanel( SA.Business.Bg ) then return end

	if table.Count( SA.Business.List ) > 0 then
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

		if table.Count( SA.Business.List ) >= 12 then
			MBusiness = 15
		end

		for k,v in pairs( SA.Business.List ) do
			local Background = vgui.Create( "DPanel", BusinessList )
			Background:SetSize( BusinessList:GetWide(), 35 )
			Background:Dock( TOP )
			Background:DockMargin( 0, 5, 0, 0 )
			Background.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 ) )

				draw.SimpleText( k, "S:Business:Roboto:18", 10, h / 2, color_white, 0, 1 )
			end

			local Treasury = vgui.Create( "S:Business:DButton", Background )
			Treasury:SetSize( 150, 25 )
			Treasury:SetPos( BusinessList:GetWide() - Treasury:GetWide() - 5 - MBusiness, 5 )
			Treasury:SetText( SA.Business:GetLanguage( "Choose" ) )
			Treasury:BackgroundColor( SA.Business.Red )
			Treasury.DoClick = function()
				SA.Business.Bg:Clear()
				SA.Business:Treasury( k )
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



