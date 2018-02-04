SA.Business:AddEvent( "CreateBusiness", function( pPlayer, tblInfos )
	if !tblInfos[ 'Name' ] || tblInfos[ 'Name' ] == "Entrez un nom valide..." then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidName" ), SA.Business.Red, 5 )
	end
	
	if !SA.Business.List then SA.Business.List = {} end

	if SA.Business.List[ tblInfos[ 'Name' ] ] then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NameAlreadyTaken" ), SA.Business.Red, 5 )
	end 

	if !pPlayer:canAfford( SA.Business.BPrice ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoMoney" ), SA.Business.Red, 5 )
	end

	pPlayer:addMoney( - SA.Business.BPrice )

	SA.Business.List[ tblInfos[ 'Name' ] ] = {
		Owner = pPlayer:SteamID(),
		Treasury = 0,
		TreasuryIsEnable = "true",
		LogsTreasury = {},
		Employees = {},
		Sellers = {}
	}

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "BusinessCreated" ), SA.Business.Green, 5 )

	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Name' ] )

	SA.Business:SaveBusiness( tblInfos[ 'Name' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateBusiness" )
	net.Send( pPlayer )
end)

SA.Business:AddEvent( "DeleteBusiness", function( pPlayer, tblInfos )
	if !tblInfos[ 'Name' ] then return end

	if !SA.Business.List[ tblInfos[ 'Name' ] ] then return end

	if SA.Business.List[ tblInfos[ 'Name' ] ][ 'Owner' ] ~= pPlayer:SteamID() then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "BusinessNotOwner" ), SA.Business.Red, 5 )
	end 

	if SA.Business.SellersList && SA.Business.SellersList[ tblInfos[ 'Name' ] ] then
		for k,v in pairs( SA.Business.SellersList[ tblInfos[ 'Name' ] ] ) do
			if IsValid( v ) then
				v:Remove()
			end
		end
	end

	SA.Business:DeleteBusiness( tblInfos[ 'Name' ] )
	
	SA.Business.List[ tblInfos[ 'Name' ] ] = nil

	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Name' ] )

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "BusinessDeleted" ), SA.Business.Green, 5 )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateBusiness" )
	net.Send( pPlayer )
end)