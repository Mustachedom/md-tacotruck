Config = Config or {}
Config.Dealers = {}
Config.UseTarget = GetConvar('UseTarget', 'false') == 'false'

Config.Fuel = 'cdn-fuel' --- make this your fuel script ie LegacyFuel, ps-fuel, cdn-fuel
Config.Job = "tacoshop" --- job title 
Config.Payfortruck = vector3(8.71, -1599.93, 29.39)
Config.truckspawn =  vector4(18.53, -1596.06, 29.28, 58.09) -- must be vec4 for heading

-- Selling Config
Config.SuccessChance = 98
Config.ScamChance = 1
Config.RobberyChance = 1
Config.MinimumDrugSalePolice = 0

Config.DrugsPrice = {
    ["mdtacos"] = {
        min = 15,
        max = 24,
    },
   
}
