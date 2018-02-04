-- Language of script
SA.Business.Language = "fr"

-- Save Businees or no
SA.Business.Save = true

-- Command to open menu
SA.Business.Command = "!b"

-- Price to create business
SA.Business.BPrice = 150

-- Time to receive Payday
SA.Business.PayDay = 30 * 60

-- Max salary of employee
SA.Business.MaxSalary = 3500

SA.Business.Red = Color( 231, 76, 60 )
SA.Business.Green = Color( 30, 134, 74 )
SA.Business.Orange = Color( 157, 122, 30 )

-- Contents of sellers
SA.Business.SellersContents = {
	[ 'weapon_deagle2' ] = {
		Name = "Deagle",
		Model = "models/weapons/w_pist_deagle.mdl",
		Price = 100000,

		Weapon = true,
	},

	[ 'weapon_ak472' ] = {
		Name = "AK-47",
		Model = "models/weapons/w_rif_ak47.mdl",
		Price = 1000,

		Weapon = true,
	},

	[ 'spawned_food' ] = {
		Name = "Pizza",
		Model = "models/combine_helicopter/helicopter_bomb01.mdl",
		Price = 65,

		Food = true,
		Energy = 30
	}
}

-- Don't touch !!
function SA.Business:GetLanguage( strName )
	if !SA.Business.Language then return "" end
	if !SA.Business.Languages[ SA.Business.Language ] then return "Invalid language" end
	if !SA.Business.Languages[ SA.Business.Language ][ strName ] then return "" end
	
	return SA.Business.Languages[ SA.Business.Language ][ strName ]
end