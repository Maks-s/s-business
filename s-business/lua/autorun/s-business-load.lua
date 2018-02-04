SA = SA or {}
SA.Business = {}
SA.Business.Languages = {}

local function addFile(path, doInclude)
	local files, folders = file.Find(path .. "*", "LUA")
	for _,v in pairs(files) do
		if doInclude then
			include(path .. v)
		else
			AddCSLuaFile(path .. v)
		end
	end
	
	for _,v in pairs(folders) do
		addFile(path .. v .. "/", doInclude)
	end
end

if SERVER then
	-- Load Shared Files
	for _, v in pairs( file.Find( "s-business/*.lua", "LUA" ) ) do
		AddCSLuaFile( "s-business/" .. v )
		include( "s-business/" .. v )
	end		

	-- Load Languages Files
	for _, v in pairs( file.Find( "s-business/languages/*.lua", "LUA" ) ) do
		AddCSLuaFile( "s-business/languages/" .. v )
		include( "s-business/languages/" .. v )
	end	

	-- Load Server Files
	addFile("s-business/server/", true)

	-- Load Client Files
	addFile("s-business/client/", false)
	addFile("s-business/panels/", false)
	addFile("s-business/manage/", false)
	return
end

-- Load Shared Files
for _, v in pairs( file.Find( "s-business/*.lua", "LUA" ) ) do
	include( "s-business/" .. v )
end	

-- Load Languages Files
addFile("s-business/languages/", true)

-- Load Client Files
addFile("s-business/client/", true)
addFile("s-business/panels/", true)
