SA.Business:AddEvent( "AddSeller", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'SellerName' ] then return end
	if !tblInfos[ 'SellerModel' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Manage Sellers" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end
	
	if SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ] then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NameAlreadyTaken" ), SA.Business.Red, 5 )
	end

	local vecPos = string.Explode( " ", tostring( pPlayer:GetPos() ) )
	local angPos = string.Explode( " ", tostring( pPlayer:GetAngles() ) )

	local Seller = ents.Create( "s-business-seller" )
	Seller:SetModel( tblInfos[ 'SellerModel' ] )
	Seller:SetPos( Vector( vecPos[ 1 ], vecPos[ 2 ], vecPos[ 3 ] ) + pPlayer:GetForward() * 35 )
	Seller:SetAngles( Angle( angPos[ 1 ], angPos[ 2 ], angPos[ 3 ] ) )
	Seller:Spawn()
	Seller:Activate()
	Seller:SetSellerName( tblInfos[ 'SellerName' ] )
	Seller:SetSellerBusiness( tblInfos[ 'Business' ] )

	if !SA.Business.SellersList then
		SA.Business.SellersList = {}
	end	

	if !SA.Business.SellersList[ tblInfos[ 'Business' ] ] then
		SA.Business.SellersList[ tblInfos[ 'Business' ] ] = {}
	end

	SA.Business.SellersList[ tblInfos[ 'Business' ] ][ tblInfos[ 'SellerName' ] ] = Seller

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ] = {
		Model = tblInfos[ 'SellerModel' ],
		Pos = vecPos[ 1 ] .. " " .. vecPos[ 2 ] .. " " .. vecPos[ 3 ],
		Ang = angPos[ 1 ] .. " " .. angPos[ 2 ] .. " " .. angPos[ 3 ],
		Contents = {},
	}

	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "SellerAdded" ), SA.Business.Green, 5 )

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateSellers" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )
end)

SA.Business:AddEvent( "DeleteSeller", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'SellerName' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Manage Sellers" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end
	
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ] then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidSeller" ), SA.Business.Red, 5 )
	end

	local Seller = SA.Business:GetSeller( tblInfos[ 'Business' ], tblInfos[ 'SellerName' ] )

	if Seller then
		Seller:Remove()
	end

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ] = nil

	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "SellerDeleted" ), SA.Business.Green, 5 )

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateSellers" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )
end)

SA.Business:AddEvent( "EditSeller", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'SellerName' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Manage Sellers" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end
	
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ] then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidSeller" ), SA.Business.Red, 5 )
	end

	local Seller = SA.Business:GetSeller( tblInfos[ 'Business' ], tblInfos[ 'SellerName' ] )

	if !util.IsValidModel(tblInfos[ 'SellerModel' ]) then
		SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidModel" ), SA.Business.Red, 5 )
		return
	end

	if Seller then
		Seller:SetModel( tblInfos[ 'SellerModel' ] )
	end

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ] = {
		Model = tblInfos[ 'SellerModel' ],
		Pos = SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ][ 'Pos' ],
		Ang = SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ][ 'Ang' ],
	}

	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "SellerChanged" ), SA.Business.Green, 5 )

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateSellers" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )
end)

SA.Business:AddEvent( "AddContentToSeller", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'SellerName' ] then return end
	if !tblInfos[ 'Content' ] then return end
	if !tblInfos[ 'Amount' ] then return end
	if !tblInfos[ 'Price' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Manage Sellers" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end
		
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ] then return end
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ] then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidSeller" ), SA.Business.Red, 5 )
	end

	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ][ 'Contents' ] then SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ][ 'Contents' ] = {} end

	if tonumber( tblInfos[ 'Amount' ] ) < 0 then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidAmount" ), SA.Business.Red, 5 )
	end

	if !SA.Business.SellersContents[ tblInfos[ 'Content' ] ] then return end

	local Price = SA.Business.SellersContents[ tblInfos[ 'Content' ] ][ 'Price' ]  * tonumber( tblInfos[ 'Amount' ] )

	if !pPlayer:canAfford( Price ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoMoney" ), SA.Business.Red, 5 ) 
	end

	pPlayer:addMoney( - Price )

	local Amount = tblInfos[ 'Amount' ]

	if SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ][ 'Contents' ][ tblInfos[ 'Content' ] ] then
		Amount = Amount + SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ][ 'Contents' ][ tblInfos[ 'Content' ] ][ 'Amount' ]
	end

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'Sellers' ][ tblInfos[ 'SellerName' ] ][ 'Contents' ][ tblInfos[ 'Content' ] ] = {
		Price = tblInfos[ 'Price' ],
		Amount = tonumber( Amount )
	}

	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "PurchaseMade" ), SA.Business.Green, 5 )

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateSellers" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )
end)

SA.Business:AddEvent( "BuySeller", function( pPlayer, tblInfos )
	if !tblInfos[ 'Ent' ] then return end
	if !tblInfos[ 'Cart' ] then return end

	local Ent = tblInfos[ 'Ent' ]

	if !IsValid( Ent ) then return end
	if Ent:GetClass() ~= "s-business-seller" then return end
	if pPlayer:GetPos():Distance( Ent:GetPos() ) > 300 then return end 
	

	if !SA.Business.List[ Ent:GetSellerBusiness() ] then return end
	if !SA.Business.List[ Ent:GetSellerBusiness() ][ 'Sellers' ] then return end

	if !SA.Business.List[ Ent:GetSellerBusiness() ][ 'Sellers' ][ Ent:GetSellerName() ] then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidSeller" ), SA.Business.Red, 5, true )
	end

	local tblSeller = SA.Business.List[ Ent:GetSellerBusiness() ][ 'Sellers' ][ Ent:GetSellerName() ]

	local Price = 0
	local NotExist = false
	local NoAmount = false

	for k,v in pairs( tblInfos[ 'Cart' ] ) do
		if !SA.Business.SellersContents[ k ] then NotExist = k break end 
		if !tblSeller[ "Contents" ][ k ] then NotExist = k break end

		if tblSeller[ "Contents" ][ k ][ 'Amount' ] < v then
			NoAmount = k
			break 
		end

		Price = Price + ( tblSeller[ "Contents" ][ k ][ 'Price' ] * v )
	end

	if NotExist then
		return SA.Business:AddNotify( pPlayer, "Certain éléments n'existe plus", SA.Business.Red, 5, true )
	end	

	if NoAmount then
		return SA.Business:AddNotify( pPlayer, "Il n'y a pas assez d'éléments en stock ( " .. SA.Business.SellersContents[ NoAmount ][ 'Name' ] .. " )", SA.Business.Red, 5, true )
	end

	if Price <= 0 then return end
	
	if !pPlayer:canAfford( Price ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoMoney" ), SA.Business.Red, 5, true )
	end

	pPlayer:addMoney( - Price )

	SA.Business.List[ Ent:GetSellerBusiness() ][ 'Treasury' ] = SA.Business.List[ Ent:GetSellerBusiness() ][ 'Treasury' ] + Price

	SA.Business:AddTreasuryLog( Ent:GetSellerBusiness(), Ent:GetSellerName() .. " a fait une vente à " .. DarkRP.formatMoney( Price ) )

	local crate = ents.Create( "s-business-crate" )
	crate:SetPos( Ent:GetPos() + Ent:GetForward() * 30 )
	crate:SetAngles( Ent:GetAngles() )
	crate:Spawn()
	crate:Activate()
	crate:SetCrateOwner( pPlayer )
	crate:SetBusinessName( Ent:GetSellerBusiness() )

	for k,v in pairs( tblInfos[ 'Cart' ] ) do
		crate:AddContent( k, v )
	end

	for k,v in pairs( tblInfos[ 'Cart' ] ) do
		if !tblSeller[ "Contents" ][ k ] then continue end

		if tblSeller[ "Contents" ][ k ][ 'Amount' ] - v <= 0 then
			tblSeller[ "Contents" ][ k ] = nil
		else
			tblSeller[ "Contents" ][ k ][ 'Amount' ] = tblSeller[ "Contents" ][ k ][ 'Amount' ] - v
		end
	end

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "PurchaseMade" ), SA.Business.Green, 5, true )

	SA.Business:SaveBusiness( Ent:GetSellerBusiness() )
end)
