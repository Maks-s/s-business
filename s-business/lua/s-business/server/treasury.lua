SA.Business:AddEvent( "WithdrawTreasury", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'Amount' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Treasury' ] then return end
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ] then return end

	if SA.Business.List[ tblInfos[ 'Business' ] ][ 'TreasuryIsEnable' ] == "false" then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "FundsDisable" ), SA.Business.Red, 5 )
	end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Treasury" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end

	if tonumber( tblInfos[ 'Amount' ] ) > SA.Business.List[ tblInfos[ 'Business' ] ][ 'Treasury' ] then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "AmountTooHigh" ), SA.Business.Red, 5 )
	end

	if tonumber( tblInfos[ 'Amount' ] ) < 0 then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidAmount" ), SA.Business.Red, 5 )
	end

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'Treasury' ] = SA.Business.List[ tblInfos[ 'Business' ] ][ 'Treasury' ] - tonumber( tblInfos[ 'Amount' ] )

	pPlayer:addMoney( tonumber( tblInfos[ 'Amount' ] ) )

	SA.Business:AddTreasuryLog( tblInfos[ 'Business' ], pPlayer:Nick() .. " à retirer " .. DarkRP.formatMoney( tonumber( tblInfos[ 'Amount' ] ) ) )
	
	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	SA.Business:AddNotify( pPlayer, "Vous avez pris " .. DarkRP.formatMoney( tonumber( tblInfos[ 'Amount' ] ) ), SA.Business.Green, 5 )

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateTreasury" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )		
end)

SA.Business:AddEvent( "DepositTreasury", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'Amount' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Treasury' ] then return end
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ] then return end
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'TreasuryIsEnable' ] then return end

	if SA.Business.List[ tblInfos[ 'Business' ] ][ 'TreasuryIsEnable' ] == "false" then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "FundsDisable" ), SA.Business.Red, 5 )
	end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Treasury" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end

	if tonumber( tblInfos[ 'Amount' ] ) <= 0 then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidAmount" ), SA.Business.Red, 5 )
	end

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'Treasury' ] = SA.Business.List[ tblInfos[ 'Business' ] ][ 'Treasury' ] + tonumber( tblInfos[ 'Amount' ] )

	pPlayer:addMoney( - tonumber( tblInfos[ 'Amount' ] ) )

	SA.Business:AddTreasuryLog( tblInfos[ 'Business' ], pPlayer:Nick() .. " à ajouté " .. DarkRP.formatMoney( tonumber( tblInfos[ 'Amount' ] ) ) )
	
	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	SA.Business:AddNotify( pPlayer, "Vous avez mis " .. DarkRP.formatMoney( tonumber( tblInfos[ 'Amount' ] ) ), SA.Business.Green, 5 )

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateTreasury" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )		
end)

SA.Business:AddEvent( "DisableEnableFunds", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'Disable' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'TreasuryIsEnable' ] then return end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Disable / Enable Funds" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'TreasuryIsEnable' ] = tblInfos[ 'Disable' ]

	if SA.Business.List[ tblInfos[ 'Business' ] ][ 'TreasuryIsEnable' ] == "true" then
		SA.Business:AddTreasuryLog( tblInfos[ 'Business' ], pPlayer:Nick() .. " à activer les fonds" )
	else
		SA.Business:AddTreasuryLog( tblInfos[ 'Business' ], pPlayer:Nick() .. " à désactiver les fonds" )
	end
	
	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	if SA.Business.List[ tblInfos[ 'Business' ] ][ 'TreasuryIsEnable' ] == "true" then
		SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "FundsHasActivated" ), SA.Business.Green, 5 )
	else
		SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "FundsHasDisable" ), SA.Business.Green, 5 )
	end

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )
	
	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateTreasury" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )		
end)
