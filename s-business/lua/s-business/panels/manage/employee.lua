function SA.Business:EditEmployee( strBusiness, strEmployee )
	if ValidPanel( SA.Business.BaseEditEmployee ) then SA.Business.BaseEditEmployee:Remove() end
	if !SA.Business.List[ strBusiness ] then return end
	if !SA.Business.List[ strBusiness ][ 'Employees' ] then return end
	if !SA.Business.List[ strBusiness ][ 'Employees' ][ strEmployee ] then return end
	
	SA.Business.BaseEditEmployee = vgui.Create( "DFrame" )
	SA.Business.BaseEditEmployee:SetSize( 500, 130 )
	SA.Business.BaseEditEmployee:Center()
	SA.Business.BaseEditEmployee:SetTitle( '' )
	SA.Business.BaseEditEmployee:MakePopup()
	SA.Business.BaseEditEmployee.Paint = function( self, w, h ) 
		SA.Business:DrawBlur( self, 6, 25 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 47, 59, 225 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 27, 37, 47 ) )
	end

	local ESalary = vgui.Create( "DTextEntry", SA.Business.BaseEditEmployee )
	ESalary:SetSize( SA.Business.BaseEditEmployee:GetWide() - 10, 25 )
	ESalary:SetPos( 5, 30 )
	ESalary:SetText( SA.Business.List[ strBusiness ][ 'Employees' ][ strEmployee ][ 'Salary' ] )
	ESalary:SetNumeric( true )

	local Perms = vgui.Create( "S:Business:DButton", SA.Business.BaseEditEmployee )
	Perms:SetSize( SA.Business.BaseEditEmployee:GetWide() - 10, 30 )
	Perms:SetPos( 5, 60 )
	Perms:SetText( SA.Business:GetLanguage( "Permission" ) )
	Perms.DoClick = function()
		SA.Business:EmployeePermissions( strBusiness, strEmployee )
	end	

	local Edit = vgui.Create( "S:Business:DButton", SA.Business.BaseEditEmployee )
	Edit:SetSize( SA.Business.BaseEditEmployee:GetWide() - 10, 30 )
	Edit:SetPos( 5, 95 )
	Edit:SetText( SA.Business:GetLanguage( "Edit" ) )
	Edit.DoClick = function()
		if ESalary:GetValue() == "" then return end
		
		if !SA.Business.Perms then SA.Business.Perms = {} end

		net.Start( "S:Business:Events" )
		net.WriteString( "EditEmployee" )
		net.WriteTable( {
			Business = strBusiness,
			Employee = strEmployee,
			Perms = SA.Business.Perms,
			Salary = ESalary:GetValue() 
		} )
		net.SendToServer()

		SA.Business.BaseEditEmployee:Remove()
	end
end

function SA.Business:EmployeePermissions( strBusiness, strEmployee )
	if ValidPanel( SA.Business.BaseEmployeePerms ) then SA.Business.BaseEmployeePerms:Remove() end
	if !strEmployee then return end
	if !SA.Business.List[ strBusiness ] then return end
	if !SA.Business.List[ strBusiness ][ 'Employees' ] then return end
	if !SA.Business.DefaultPerms then return end
	
	local Perms = {}

	if SA.Business.List[ strBusiness ][ 'Employees' ][ strEmployee ] && SA.Business.List[ strBusiness ][ 'Employees' ][ strEmployee ][ 'Perms'] then
		Perms = SA.Business.List[ strBusiness ][ 'Employees' ][ strEmployee ][ 'Perms' ]
	else
		Perms = SA.Business.DefaultPerms
	end

	SA.Business.BaseEmployeePerms = vgui.Create( "DFrame" )
	SA.Business.BaseEmployeePerms:SetSize( 500, 200 )
	SA.Business.BaseEmployeePerms:Center()
	SA.Business.BaseEmployeePerms:SetTitle( '' )
	SA.Business.BaseEmployeePerms:MakePopup()
	SA.Business.BaseEmployeePerms.Paint = function( self, w, h ) 
		SA.Business:DrawBlur( self, 6, 25 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 47, 59, 225 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 27, 37, 47 ) )
	end

	local PermsList = vgui.Create( "DScrollPanel", SA.Business.BaseEmployeePerms )
	PermsList:SetSize( SA.Business.BaseEmployeePerms:GetWide() - 10, SA.Business.BaseEmployeePerms:GetTall() - 65 )
	PermsList:SetPos( 5, 25 )
    local scrollbar = PermsList:GetVBar()
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
 
 	for k,v in pairs( Perms ) do
 		local BPerm = vgui.Create( "DPanel", PermsList )
 		BPerm:Dock( TOP )
 		BPerm:DockMargin( 0, 5, 0, 0 )
 		BPerm.Paint = function() end
 		
 		local PermText = vgui.Create( "DLabel", BPerm )
 		PermText:SetPos( 0, 2 )
 		PermText:SetText( k )	
 		PermText:SizeToContents()

 		local Perm = vgui.Create( "DCheckBox", BPerm )
 		Perm:SetPos( PermText:GetWide() + 5, 2 )
 		Perm:SetValue( v )
 		Perm.OnChange = function( bool )
 			if Perm:GetChecked() then
 				Perms[ k ] = 1
 			else
 				Perms[ k ] = 0
 			end
 		end
 	end

	local SavePerms = vgui.Create( "S:Business:DButton", SA.Business.BaseEmployeePerms )
	SavePerms:SetSize( SA.Business.BaseEmployeePerms:GetWide() - 10, 30 )
	SavePerms:SetPos( 5, SA.Business.BaseEmployeePerms:GetTall() - 35 )
	SavePerms:SetText( SA.Business:GetLanguage( "Save" ) )
	SavePerms.DoClick = function()
		SA.Business.Perms = Perms

		SA.Business.BaseEmployeePerms:Remove()
	end
end

function SA.Business:ManageEmployees( strBusiness )
	if !ValidPanel( SA.Business.Bg ) then return end
	if !SA.Business.List[ strBusiness ] then return end
	if !SA.Business.List[ strBusiness ][ 'Employees' ] then SA.Business.List[ strBusiness ][ 'Employees' ] = {} end

	SA.Business.Perms = SA.Business.DefaultPerms

	SA.Business.EmployeesList = vgui.Create( "DScrollPanel", SA.Business.Bg )
	SA.Business.EmployeesList:SetSize( SA.Business.Bg:GetWide(), SA.Business.Bg:GetTall() - 125 )
	SA.Business.EmployeesList:SetPos( 0, - 5 )
    local scrollbar = SA.Business.EmployeesList:GetVBar()
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

	local MEmployees = 0

	if table.Count( SA.Business.List[ strBusiness ][ 'Employees' ] ) >= 9 then
		MEmployees = 15
	end

	for k,v in pairs( SA.Business.List[ strBusiness ][ 'Employees' ] ) do

		local pl = player.GetBySteamID( k )

		local Background = vgui.Create( "DPanel", SA.Business.EmployeesList )
		Background:SetSize( SA.Business.EmployeesList:GetWide(), 35 )
		Background:Dock( TOP )
		Background:DockMargin( 0, 5, 0, 0 )
		Background.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 37, 47 ) )

			if IsValid( pl ) then
				draw.SimpleText( pl:Nick() .. " ( " .. DarkRP.formatMoney( v[ 'Salary' ] ) .. " )", "S:Business:Roboto:18", 10, h / 2, color_white, 0, 1 )
			else
				draw.SimpleText( k .. " ( " .. DarkRP.formatMoney( v[ 'Salary' ] ) .. " )", "S:Business:Roboto:18", 10, h / 2, color_white, 0, 1 )
			end
		end

		local Edit = vgui.Create( "S:Business:DButton", Background )
		Edit:SetSize( 150, 25 )
		Edit:SetPos( SA.Business.EmployeesList:GetWide() - Edit:GetWide() - 150  - 10 - MEmployees, 5 )
		Edit:SetText( SA.Business:GetLanguage( "Edit" ) )
		Edit:BackgroundColor( SA.Business.Orange )
		Edit.DoClick = function()
			SA.Business:EditEmployee( strBusiness, k )
		end		

		local Delete = vgui.Create( "S:Business:DButton", Background )
		Delete:SetSize( 150, 25 )
		Delete:SetPos( SA.Business.EmployeesList:GetWide() - Delete:GetWide() - 5 - MEmployees, 5 )
		Delete:SetText( SA.Business:GetLanguage( "Delete" ) )
		Delete:BackgroundColor( SA.Business.Red )
		Delete.DoClick = function()
			net.Start( "S:Business:Events" )
			net.WriteString( "DeleteEmployee" )
			net.WriteTable( {
				Business = strBusiness,
				Employee = k,
			} )
			net.SendToServer()
		end
	end

	local Employee = vgui.Create( "DComboBox", SA.Business.Bg )
	Employee:SetSize( SA.Business.Bg:GetWide(), 25 )
	Employee:SetPos( 0, SA.Business.Bg:GetTall() - 125 )
	Employee:SetValue( 'Choissisez un employé...' )
	for k,v in pairs( player.GetAll() ) do
		if v == LocalPlayer() then continue end
		if SA.Business.List[ strBusiness ][ 'Employees' ][ v:SteamID() ] then continue end
		
		Employee:AddChoice( v:Nick(), v )
	end

	local ESalary = vgui.Create( "DTextEntry", SA.Business.Bg )
	ESalary:SetSize( SA.Business.Bg:GetWide(), 25 )
	ESalary:SetPos( 0, SA.Business.Bg:GetTall() - 95 )
	ESalary:SetText( "Entrez le salaire..." )
	ESalary.OnGetFocus = function( self ) if self:GetText() == "Entrez le salaire..." then self:SetText( '' ) end end
	ESalary.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( "Entrez le salaire..." ) end end
	ESalary:SetNumeric( true )

	local Perms = vgui.Create( "S:Business:DButton", SA.Business.Bg )
	Perms:SetSize( SA.Business.Bg:GetWide(), 30 )
	Perms:SetPos( 0, SA.Business.Bg:GetTall() - 64 )
	Perms:SetText( SA.Business:GetLanguage( "Permission" ) )
	Perms.DoClick = function()
		if Employee:GetValue() == "Choissisez un employé..." then return end
		
		SA.Business:EmployeePermissions( strBusiness, Employee:GetOptionData( 1 ):SteamID() )
	end	

	local Create = vgui.Create( "S:Business:DButton", SA.Business.Bg )
	Create:SetSize( SA.Business.Bg:GetWide(), 30 )
	Create:SetPos( 0, SA.Business.Bg:GetTall() - 30 )
	Create:SetText( SA.Business:GetLanguage( "Add" ) )
	Create.DoClick = function()
		if ESalary:GetValue() == "" || ESalary:GetValue() == "Entrez le salaire..." then return end
		if Employee:GetValue() == "" || Employee:GetValue() == "Choissisez un employé..." then return end
		
		if !SA.Business.Perms || table.Count( SA.Business.Perms ) <= 0 then
			SA.Business.Perms = SA.Business.DefaultPerms
		end

		net.Start( "S:Business:Events" )
		net.WriteString( "AddEmployee" )
		net.WriteTable( {
			Business = strBusiness,
			Employee = Employee:GetOptionData( 1 ),
			Perms = SA.Business.Perms,
			Salary = ESalary:GetValue() 
		} )
		net.SendToServer()
	end
end