How to install like a boss
step 1
```
add this to your qb-core -> shared -> jobs

['tacoshop'] = {
		label = 'Taco Shop',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Taco Slinger',
                payment = 100
            },
			['1'] = {
                name = 'Boss',
				isboss = true,
                payment = 300
            },
        },
	},
```
step 2 
```
add this to your qb-management

Config.BossMenus = {
	['tacoshop'] = {
        vector3(Choose a vec3),
    },
	
Config.BossMenuZones = {
    ['tacoshop'] = {
        { coords = vector3(choose a vec three must be same as above), length = 0.35, width = 0.45, heading = 351.0, minZ = 30.58, maxZ = 30.68 } ,
    },
```
step 3
``` 
add this to your items.lua
["mdtacos"] 			 =          {["name"] = "mdtacos",      ["label"] = "MD Tacos",          ["weight"] = 1, ["type"] = "item", ["image"] = "mdtacos.png", ["unique"] = false, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = ""},
```

step 4
```
add image to your inventory
```

step 5

``` add this to your radial menu
["tacoshop"] = {
			{
                id = 'Toggletaco',
                title = 'Taco Selling',
                icon = 'hotdog',
                type = 'client',
                event = 'md-tacotruck:client:cornerselling',
                shouldClose = true
            },
```

step 6
```
make sure this is in city hall 
local AvailableJobs = {
    "tacoshop",
   
}
```

