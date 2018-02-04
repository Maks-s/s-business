SA.Business.Events = {}

function SA.Business:AddEvent( typeID, func )
	if !SA.Business.Events then SA.Business.Events = {} end
	
	SA.Business.Events[ typeID ] = func
end

net.Receive( "S:Business:Events", function()
	local strEventName = net.ReadString()
	local tblInfos = net.ReadTable() or {}

	if strEventName == nil then return end
	if SA.Business.Events[ strEventName ] == nil then return end

	SA.Business.Events[ strEventName ]( tblInfos )
end)

SA.Business:AddEvent( "UpdateBusiness", function( tblInfos )
	if !ValidPanel( SA.Business.Bg ) then return end
	if !ValidPanel( SA.Business.MyBusinessList ) then return end

	SA.Business.Bg:Clear()
	SA.Business:MyBusiness()
end)

SA.Business:AddEvent( "UpdateEmployees", function( tblInfos )
	if !ValidPanel( SA.Business.Bg ) then return end
	if !ValidPanel( SA.Business.EmployeesList ) then return end

	SA.Business.Bg:Clear()
	SA.Business:ManageEmployees( tblInfos[ 'Business' ] )
end)

SA.Business:AddEvent( "UpdateSellers", function( tblInfos )
	if !ValidPanel( SA.Business.Bg ) then return end
	if !ValidPanel( SA.Business.SellersList ) then return end

	SA.Business.Bg:Clear()
	SA.Business:ManageSellers( tblInfos[ 'Business' ] )
end)

SA.Business:AddEvent( "UpdateTreasury", function( tblInfos )
	if !ValidPanel( SA.Business.Bg ) then return end
	if !ValidPanel( SA.Business.BaseTreasury ) then return end

	SA.Business.Bg:Clear()
	SA.Business:Treasury( tblInfos[ 'Business' ] )
end)

SA.Business:AddEvent( "SendBusiness", function( tblInfos )
	if !SA.Business.List then SA.Business.List = {} end

	if tblInfos[ 'All' ] == true then
		SA.Business.List = tblInfos[ 'MyBusiness' ]
	else
		SA.Business.List[ tblInfos[ 'All' ] ] = tblInfos[ 'MyBusiness' ]
	end
end)