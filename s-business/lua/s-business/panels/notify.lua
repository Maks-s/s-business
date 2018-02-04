function SA.Business:AddNotify( strMsg, color, intTime, seller )
	if !SA.Business.NotifyList then return end

	local Base

	if seller then
		if !ValidPanel( SA.Business.SellerBase ) then return end

		Base = SA.Business.SellerBase
	else
		if !ValidPanel( SA.Business.Base ) then return end

		Base = SA.Business.Base
	end

	if !ValidPanel( Base ) then return end
	
	local Notify = vgui.Create( "DFrame", Base )
	Notify:SetSize( 220, 35 )
	Notify:SetPos( - 220, Base:GetTall() - 35 + ( ( table.Count( SA.Business.NotifyList ) )  * - 35 ) )
	Notify:MoveTo( 0, Base:GetTall() - 35 + ( ( table.Count( SA.Business.NotifyList ) )  * - 35 ), 0.25 )
	Notify:ShowCloseButton( false )
	Notify:SetTitle( "" )
	Notify:SetDraggable( false )
	Notify.Paint = function( self, w, h )
		local font = "S:Business:Roboto:18"
		local sheight = draw.GetFontHeight( "S:Business:Roboto:18" )
		local pos =  h / 2 - sheight / 2
		local strNewMsg = strMsg

        if string.len( strMsg ) > 30 then
        	font = "S:Business:Roboto:16"
        	pos = pos - 8
            strNewMsg = string.sub( strMsg, 0, 30 ) .. "\n" .. string.sub( strMsg, 31, string.len( strMsg ) )
        end

		draw.RoundedBox( 0, 0, 0, w, h, color )
		draw.DrawText( strNewMsg, font, w / 2, pos, color_white, TEXT_ALIGN_CENTER )
	end

	timer.Simple( intTime, function()
		if ValidPanel( Notify ) && ValidPanel( Base ) && SA.Business.NotifyList then
			local x, y = Notify:GetPos()

			Notify:MoveTo( - 220, y, 0.25, 0, -1, function()
				Notify:Remove()
				table.RemoveByValue( SA.Business.NotifyList, Notify )

				for k, v in pairs( SA.Business.NotifyList ) do
					v:MoveTo( 0, Base:GetTall() - 35 + ( k - 1 ) * -35, 0.25 )
				end
			end)
		end
	end)

	SA.Business.NotifyList[ #SA.Business.NotifyList + 1 ] = Notify
end

net.Receive( "S:Business:Notify", function()
	local strMsg = net.ReadString()
	local color = net.ReadColor()
	local intTime = net.ReadUInt( 16 )
	local seller = net.ReadBool()
	SA.Business:AddNotify( strMsg, color, intTime, seller )
end)