SA.Business:AddEvent( "AddEmployee", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'Employee' ] then return end
	if !tblInfos[ 'Perms' ] then return end
	if !tblInfos[ 'Salary' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Manage Employees" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end
	
	if !IsValid( tblInfos[ 'Employee' ] ) then 
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidEmployee" ), SA.Business.Red, 5 )
	end

	if tonumber( tblInfos[ 'Salary' ] ) > SA.Business.MaxSalary then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "SalaryTooHigh" ), SA.Business.Red, 5 )
	end	

	if tonumber( tblInfos[ 'Salary' ] ) < 0 then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidSalary" ), SA.Business.Red, 5 )
	end

	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ] then
		SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ] = {}
	end

	if tblInfos[ 'Employee' ]:SteamID() == SA.Business.List[ tblInfos[ 'Business' ] ][ 'Owner' ] then return end

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ][ tblInfos[ 'Employee' ]:SteamID() ] = {
		Perms = tblInfos[ 'Perms' ],
		Salary = tonumber( tblInfos[ 'Salary' ] ),
	}

	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "EmployeeAdded" ), SA.Business.Green, 5 )

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateEmployees" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )
end)

SA.Business:AddEvent( "DeleteEmployee", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'Employee' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ] then SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ] = {} end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Manage Employees" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end

	if tblInfos[ 'Employee' ] == SA.Business.List[ tblInfos[ 'Business' ] ][ 'Owner' ] then return end
	
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ][ tblInfos[ 'Employee' ] ] then 
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidEmployee" ), SA.Business.Red, 5 )
	end

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ][ tblInfos[ 'Employee' ] ] = nil

	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "EmployeeDeleted" ), SA.Business.Green, 5 )

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateEmployees" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )
end)

SA.Business:AddEvent( "EditEmployee", function( pPlayer, tblInfos )
	if !tblInfos[ 'Business' ] then return end
	if !tblInfos[ 'Employee' ] then return end
	if !tblInfos[ 'Perms' ] then return end
	if !tblInfos[ 'Salary' ] then return end

	if !SA.Business.List[ tblInfos[ 'Business' ] ] then return end
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ] then SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ] = {} end

	if !SA.Business:HasPermission( tblInfos[ 'Business' ], pPlayer, "Manage Employees" ) then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "NoPermission" ), SA.Business.Red, 5 )
	end

	if tblInfos[ 'Employee' ] == SA.Business.List[ tblInfos[ 'Business' ] ][ 'Owner' ] then return end
	
	if !SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ][ tblInfos[ 'Employee' ] ] then 
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidEmployee" ), SA.Business.Red, 5 )
	end

	if tonumber( tblInfos[ 'Salary' ] ) > SA.Business.MaxSalary then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "SalaryTooHigh" ), SA.Business.Red, 5 )
	end	

	if tonumber( tblInfos[ 'Salary' ] ) < 0 then
		return SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "InvalidSalary" ), SA.Business.Red, 5 )
	end

	SA.Business.List[ tblInfos[ 'Business' ] ][ 'Employees' ][ tblInfos[ 'Employee' ] ] = {
		Perms = tblInfos[ 'Perms' ],
		Salary = tonumber( tblInfos[ 'Salary' ] ),
	}
	
	SA.Business:SendBusiness( pPlayer, tblInfos[ 'Business' ] )

	SA.Business:AddNotify( pPlayer, SA.Business:GetLanguage( "EmployeeChanged" ), SA.Business.Green, 5 )

	SA.Business:SaveBusiness( tblInfos[ 'Business' ] )

	net.Start( "S:Business:Events" )
	net.WriteString( "UpdateEmployees" )
	net.WriteTable( {
		Business = tblInfos[ 'Business' ]
	} )
	net.Send( pPlayer )	
end)