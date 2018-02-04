SA.Business.List = SA.Business.List or {}
SA.Business.SellersList = SA.Business.SellersList or {}

--[[-------------------------------------------------------------------------
	FastDL
---------------------------------------------------------------------------]]

resource.AddWorkshop( "1290479449" )

--[[-------------------------------------------------------------------------
	Initialize
---------------------------------------------------------------------------]]

hook.Add( "Initialize", "S:Business:Initialize", function()
	if !file.IsDir( "s-addons", "DATA" ) then
		file.CreateDir( "s-addons" )
	end	

	if !file.IsDir( "s-addons/business", "DATA" ) then
		file.CreateDir( "s-addons/business" )
	end	

	if !file.IsDir( "s-addons/business/list", "DATA" ) then
		file.CreateDir( "s-addons/business/list" )
	end

	SA.Business.List = {} 

	for _,v in pairs( file.Find( "s-addons/business/list/*.txt", "DATA" ) ) do
		local tblBusiness = util.JSONToTable( file.Read( "s-addons/business/list/" .. v ) )
		if !tblBusiness then return end

		local strName = string.sub( v, 0, #v - 4 ) -- remove extension

		SA.Business.List[ strName ] = tblBusiness
	end		
end)

--[[-------------------------------------------------------------------------
	Initialize Network
---------------------------------------------------------------------------]]

util.AddNetworkString( "S:Business:OpenMenu" )
util.AddNetworkString( "S:Business:OpenMenuCrate" )
util.AddNetworkString( "S:Business:OpenSellerMenu" )
util.AddNetworkString( "S:Business:Events" )
util.AddNetworkString( "S:Business:Notify" )

--[[-------------------------------------------------------------------------
	Functions
---------------------------------------------------------------------------]]	

function SA.Business:OpenMenu( pPlayer )
	SA.Business:SendAllBusiness( pPlayer )

	net.Start( "S:Business:OpenMenu" )
	net.Send( pPlayer )
end

function SA.Business:OpenSellerMenu( pPlayer, ent )
	SA.Business:SendAllBusiness( pPlayer )

	net.Start( "S:Business:OpenSellerMenu" )
	net.WriteEntity( ent )
	net.Send( pPlayer )
end

function SA.Business:AddEvent( typeID, func )
	if !SA.Business.Events then SA.Business.Events = {} end
	
	SA.Business.Events[ typeID ] = func
end

function SA.Business:AddNotify( pPlayer, strMsg, color, inTime, seller )
	if !seller then
		seller = false
	end

	net.Start( "S:Business:Notify" )
	net.WriteString( strMsg )
	net.WriteColor( color )
	net.WriteUInt( inTime, 16 )
	net.WriteBool( seller )
	net.Send( pPlayer )
end

function SA.Business:AddTreasuryLog( strBusiness, strMsg )
	if !SA.Business.List[ strBusiness ] then return end
	if !SA.Business.List[ strBusiness ][ 'LogsTreasury' ] then SA.Business.List[ strBusiness ][ 'LogsTreasury' ] = {} end
	
	table.insert( SA.Business.List[ strBusiness ][ 'LogsTreasury' ], strMsg )
end

function SA.Business:SendBusiness( pPlayer, strBusiness )
	if !IsValid( pPlayer ) then return end
	if !strBusiness then return end

	net.Start( "S:Business:Events" )
	net.WriteString( 'SendBusiness' )
	net.WriteTable( {
		MyBusiness = SA.Business.List[ strBusiness ],
		All = strBusiness
	})

	net.Send( pPlayer )
end

function SA.Business:HasPermission( strBusiness, pPlayer, strPerm )
	if !SA.Business.List[ strBusiness ] then return false end
	
	if SA.Business.List[ strBusiness ][ 'Owner' ] == pPlayer:SteamID() then
		return true
	else
		if !SA.Business.List[ strBusiness ][ 'Employees' ] then return false end
		if !SA.Business.List[ strBusiness ][ 'Employees' ][ pPlayer:SteamID() ] then return false end
		if !SA.Business.List[ strBusiness ][ 'Employees' ][ pPlayer:SteamID() ][ "Perms" ] then return false end
		if !SA.Business.List[ strBusiness ][ 'Employees' ][ pPlayer:SteamID() ][ "Perms" ][ strPerm ] then return false end

		if SA.Business.List[ strBusiness ][ 'Employees' ][ pPlayer:SteamID() ][ "Perms" ][ strPerm ] == 1 then
			return true
		else
			return false
		end
	end
end

function SA.Business:GetSeller( strBusiness, strSellerName )
	if !SA.Business.SellersList[ strBusiness ] then return false end
	if !SA.Business.SellersList[ strBusiness ][ strSellerName ] then return false end
	if !IsValid( SA.Business.SellersList[ strBusiness ][ strSellerName ] ) then return false end

	return SA.Business.SellersList[ strBusiness ][ strSellerName ]
end

function SA.Business:SendAllBusiness( pPlayer )
	local MyBusiness = {}
	for k,v in pairs( SA.Business.List ) do
		if v[ 'Owner' ] == pPlayer:SteamID() then
			MyBusiness[ k ] = v
		end

		for employee,_ in pairs( v[ 'Employees' ]  ) do
			if employee == pPlayer:SteamID() then
				MyBusiness[ k ] = v
			end
		end
	end

	net.Start( "S:Business:Events" )
	net.WriteString( 'SendBusiness' )
	net.WriteTable( {
		MyBusiness = MyBusiness,
		All = true
	})
	net.Send( pPlayer )
end

function SA.Business:DeleteBusiness( strName )
	if !SA.Business.List[ strName ] then return end
	
	file.Delete( "s-addons/business/list/" .. strName .. ".txt" )
end

function SA.Business:SaveBusiness( strName )
	if !SA.Business.Save then return end
	if !SA.Business.List[ strName ] then return end
	
	file.Write( "s-addons/business/list/" .. strName .. ".txt" , util.TableToJSON( SA.Business.List[ strName ] ) )
end

--[[-------------------------------------------------------------------------
	Events
---------------------------------------------------------------------------]]

net.Receive( "S:Business:Events", function( len, pPlayer )
	local strEventName = net.ReadString()
	local tblInfos = net.ReadTable() or {}

	if !SA.Business.Events then SA.Business.Events = {} end

	if strEventName == nil then return end
	if SA.Business.Events[ strEventName ] == nil then return end

	SA.Business.Events[ strEventName ]( pPlayer, tblInfos )
end)

--[[-------------------------------------------------------------------------
	Player Say
---------------------------------------------------------------------------]]

hook.Add( "PlayerSay", "S:Business:Player:Say", function( pPlayer, text )
	if text == SA.Business.Command then
		
		SA.Business:OpenMenu( pPlayer )

		return ""
	end
end)

--[[-------------------------------------------------------------------------
	Player Initial Spawn
---------------------------------------------------------------------------]]

hook.Add( "PlayerInitialSpawn", "S:Business:Player:InitialSpawn", function( pPlayer )
	timer.Simple( 1, function()
		SA.Business:SendAllBusiness( pPlayer )
	end)
end)

--[[-------------------------------------------------------------------------
	Spawn sellers
---------------------------------------------------------------------------]]

local function spawnSellers()
	for k,v in pairs( SA.Business.List ) do
		for SellerName, seller in pairs( v[ 'Sellers' ] ) do
			local vecPos = string.Explode( " ", tostring( seller[ 'Pos' ] ) )
			local angPos = string.Explode( " ", tostring( seller[ 'Ang' ] ) )
 
			local Seller = ents.Create( "s-business-seller" )
			Seller:SetModel( seller[ 'Model' ] )
			Seller:SetPos( Vector( vecPos[ 1 ], vecPos[ 2 ], vecPos[ 3 ] ) )
			Seller:SetAngles( Angle( angPos[ 1 ], angPos[ 2 ], angPos[ 3 ] ) )
			Seller:Spawn()
			Seller:Activate()
			Seller:SetSellerName( SellerName )
			Seller:SetSellerBusiness( k )

			if !SA.Business.SellersList then SA.Business.SellersList = {} end
			if !SA.Business.SellersList[ k ] then SA.Business.SellersList[ k ] = {} end
			if !SA.Business.SellersList[ k ] then SA.Business.SellersList[ k ] = {} end
			
			SA.Business.SellersList[ k ][ SellerName ] = Seller
		end
	end
end

hook.Add( "InitPostEntity", "S:Business:InitPostEntity", spawnSellers)
hook.Add( "PostCleanupMap", "S:Business:PostCleanupMap", spawnSellers)

--[[-------------------------------------------------------------------------
	Spawn Content
---------------------------------------------------------------------------]]

SA.Business:AddEvent( "SpawnContent", function( pPlayer, tblInfos )
	if !tblInfos[ 'Ent' ] then return end
	if !tblInfos[ 'Content' ] then return end

	local Ent = tblInfos[ 'Ent' ]
	local Content = tblInfos[ 'Content' ]

	if !IsValid( Ent ) then return end
	if pPlayer:GetPos():DistToSqr( Ent:GetPos() ) > 90000 then return end
	if Ent:GetClass() ~= "s-business-crate" then return end
	if !Ent.tblContents then return end
	if !Ent.tblContents[ Content ] then return end
	if !SA.Business.SellersContents[ Content ] then return end

	local Item = ents.Create( Content ) 
	Item:SetModel( SA.Business.SellersContents[ Content ][ 'Model' ] )
	Item:SetPos( Ent:GetPos() + Ent:GetUp() * 35 )
	Item:SetAngles( Ent:GetAngles() )
	Item:Spawn()

	if SA.Business.SellersContents[ Content ][ 'Food' ] && SA.Business.SellersContents[ Content ][ 'Energy' ] then
		if FoodItems then -- check if food module is active
			Item:Setowning_ent( Ent:GetCrateOwner() )
			Item.FoodEnergy = SA.Business.SellersContents[ Content ][ 'Energy' ]
			for k,v in pairs( FoodItems ) do
				Item.foodItem = v
			end
		else
			ErrorNoHalt("404 food not found\n")
			Item:Remove()
		end
	end

	if Ent.tblContents[ Content ] > 1 then
		Ent.tblContents[ Content ] = Ent.tblContents[ Content ] - 1
	else
		Ent.tblContents[ Content ] = nil
	end

	if table.Count( Ent.tblContents ) <= 0 then
		Ent:Remove()
	end
end)

timer.Create( "S:Business:PayDay", SA.Business.PayDay, 0, function()
	for _, pPlayer in pairs( player.GetAll() ) do
		for k,v in pairs( SA.Business.List ) do
			if SA.Business.List[ k ][ 'Employees' ][ pPlayer:SteamID() ] then
				if SA.Business.List[ k ][ 'Treasury' ] - SA.Business.List[ k ][ 'Employees' ][ pPlayer:SteamID() ][ 'Salary' ] < 0 then
					DarkRP.notify( pPlayer, 1, 5, "L'entreprise ( " .. k .. " ) n'a pas assez d'argent pour vous payer" )
				else
					pPlayer:addMoney( SA.Business.List[ k ][ 'Employees' ][ pPlayer:SteamID() ][ 'Salary' ] )
					SA.Business.List[ k ][ 'Treasury' ] = SA.Business.List[ k ][ 'Treasury' ] - SA.Business.List[ k ][ 'Employees' ][ pPlayer:SteamID() ][ 'Salary' ]
					DarkRP.notify( pPlayer, 0, 5, "L'entreprise ( " .. k .. " ) vous a payé " .. DarkRP.formatMoney( SA.Business.List[ k ][ 'Employees' ][ pPlayer:SteamID() ][ 'Salary' ] ) )
				end
			end
		end
	end
end)