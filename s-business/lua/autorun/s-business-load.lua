SA = SA or {}
SA.Business = {}
SA.Business.Languages = {}

if ( SERVER ) then
	// Load Shared Files
	for k, v in pairs( file.Find( "s-business/*.lua", "LUA" ) ) do
		AddCSLuaFile( "s-business/" .. v )
		include( "s-business/" .. v )
	end		

	// Load Languages Files
	for k, v in pairs( file.Find( "s-business/languages/*.lua", "LUA" ) ) do
		AddCSLuaFile( "s-business/languages/" .. v )
		include( "s-business/languages/" .. v )
	end	

	// Load Server Files
	for k, v in pairs( file.Find( "s-business/server/*.lua", "LUA" ) ) do
		include( "s-business/server/" .. v )
	end		

	for k, v in pairs( file.Find( "s-business/server/manage/*.lua", "LUA" ) ) do
		include( "s-business/server/manage/" .. v )
	end	

	// Load Client Files
	for k, v in pairs( file.Find( "s-business/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "s-business/client/" .. v )
	end	

	for k, v in pairs( file.Find( "s-business/panels/*.lua", "LUA" ) ) do
		AddCSLuaFile( "s-business/panels/" .. v )
	end	

	for k, v in pairs( file.Find( "s-business/panels/manage/*.lua", "LUA" ) ) do
		AddCSLuaFile( "s-business/panels/manage/" .. v )
	end
end

if ( CLIENT ) then
	// Load Shared Files
	for k, v in pairs( file.Find( "s-business/*.lua", "LUA" ) ) do
		include( "s-business/" .. v )
	end	

	// Load Languages Files
	for k, v in pairs( file.Find( "s-business/languages/*.lua", "LUA" ) ) do
		include( "s-business/languages/" .. v )
	end	

	// Load Client Files
	for k, v in pairs( file.Find( "s-business/client/*.lua", "LUA" ) ) do
		include( "s-business/client/" .. v )
	end	

	for k, v in pairs( file.Find( "s-business/panels/*.lua", "LUA" ) ) do
		include( "s-business/panels/" .. v )
	end

	for k, v in pairs( file.Find( "s-business/panels/manage/*.lua", "LUA" ) ) do
		include( "s-business/panels/manage/" .. v )
	end	
end