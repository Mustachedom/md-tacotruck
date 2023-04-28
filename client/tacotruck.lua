QBCore = exports['qb-core']:GetCoreObject()

local cornerselling = false
local hasTarget = false
local lastPed = {}
local stealingPed = nil
local stealData = {}
local availableDrugs = {}
local currentOfferDrug = nil
local CurrentCops = 0
local textDrawn = false
local zoneMade = false


RegisterNetEvent("md-tacotruck:client:getruck")
AddEventHandler("md-tacotruck:client:getruck", function() 
if TriggerServerEvent('md-tacotruck:server:payment') then
end
end)

RegisterNetEvent("md-tacotruck:Client:gettruckloc", function()
	local coords = Config.truckspawn
	QBCore.Functions.SpawnVehicle('taco', function(veh)
    SetVehicleNumberPlateText(veh, 'Taco BB')
    SetEntityHeading(veh, coords.w)
    exports[Config.Fuel]:SetFuel(veh, 100.0)
    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
	TriggerEvent('QBCore:Notify', 'Your truck is here', 'success')
    SetVehicleEngineOn(veh, true, true)
end, coords, true)
end)



CreateThread(function()
 exports['qb-target']:AddBoxZone("tacotruck",Config.Payfortruck,1.5, 1.75, { -- 963.37, -2122.95, 31.47
	name = "vapestoreloc",
	heading = 11.0,
	debugPoly = false,
	minZ = Config.Payfortruck-2,
	maxZ = Config.Payfortruck+2,
}, {
	options = {
		{
            type = "client",
            event = "md-tacotruck:client:getruck",
			icon = "fas fa-sign-in-alt",
			label = "Pay For Truck",
			job = Config.Job,
			
		},
	},
	distance = 2.5
 })
 
 end)
 
 
 
 
-- Functions
local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

local function TooFarAway()
    QBCore.Functions.Notify("Damn Homie You Gotta Stay Around The Area", 'error')
   -- LocalPlayer.state:set("inv_busy", false, true)
    cornerselling = false
    hasTarget = false
    availableDrugs = {}
end

local function SellToPed(ped)
    hasTarget = true

    for i = 1, #lastPed, 1 do
        if lastPed[i] == ped then
            hasTarget = false
            return
        end
    end

    local successChance = math.random(1, 100)
    local scamChance = math.random(1, 100)
   -- local getRobbed = math.random(1, 100)
    if successChance <= Config.SuccessChance then hasTarget = false return end

    local drugType = math.random(1, #availableDrugs)
    local bagAmount = math.random(1, availableDrugs[drugType].amount)
    if bagAmount > 15 then bagAmount = math.random(9, 15) end

    currentOfferDrug = availableDrugs[drugType]

    local ddata = Config.DrugsPrice[currentOfferDrug.item]
    local randomPrice = math.random(ddata.min, ddata.max) * bagAmount
    if scamChance <= Config.ScamChance then randomPrice = math.random(3, 10) * bagAmount end

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)

    local coords = GetEntityCoords(PlayerPedId(), true)
    local pedCoords = GetEntityCoords(ped)
    local pedDist = #(coords - pedCoords)
  

    while pedDist > 1.5 do
        coords = GetEntityCoords(PlayerPedId(), true)
        pedCoords = GetEntityCoords(ped)
     
        TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)
        pedDist = #(coords - pedCoords)
        Wait(100)
    end

    TaskLookAtEntity(ped, PlayerPedId(), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(ped, PlayerPedId(), 5500)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, false)

    if hasTarget then
        while pedDist < 5 and not IsPedDeadOrDying(ped) do
            local coords2 = GetEntityCoords(PlayerPedId(), true)
            local pedCoords2 = GetEntityCoords(ped)
            local pedDist2 = #(coords2 - pedCoords2)
        
            if pedDist2 < 5 and cornerselling then
				if pedDist2 < 5 and cornerselling then
                    if not textDrawn then
                        textDrawn = true
                        exports['qb-core']:DrawText(Lang:t("info.drug_offer", {bags = bagAmount, drugLabel = currentOfferDrug.label, randomPrice = randomPrice}))
                    end
                    if IsControlJustPressed(0, 38) then
                        
                            exports['qb-core']:KeyPressed()
                            textDrawn = false
                            QBCore.Functions.Progressbar("cornerSelling", "Selling Some Tacos", '2000', false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = false,
                            }, {}, {}, {}, function()
                                TriggerServerEvent('md-tacotruck:server:sellCornerDrugs', drugType, bagAmount, randomPrice)
                                hasTarget = false
                                LoadAnimDict("gestures@f@standing@casual")
                                TaskPlayAnim(PlayerPedId(), "gestures@f@standing@casual", "gesture_point", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                                Wait(650)
                                ClearPedTasks(PlayerPedId())
                                SetPedKeepTask(ped, false)
                                SetEntityAsNoLongerNeeded(ped)
                                ClearPedTasksImmediately(ped)
                                lastPed[#lastPed + 1] = ped
                            end)
                        
                    end
                    if IsControlJustPressed(0, 47) then
                        exports['qb-core']:KeyPressed()
                        textDrawn = false
                        QBCore.Functions.Notify("Fuck That Offer", 'error')
                        hasTarget = false
                        SetPedKeepTask(ped, false)
                        SetEntityAsNoLongerNeeded(ped)
                        ClearPedTasksImmediately(ped)
                        lastPed[#lastPed + 1] = ped
                        break
                    end
                end
            else
                 if textDrawn then
                     exports['qb-core']:HideText()
                     textDrawn = false
                 end
                hasTarget = false
                SetPedKeepTask(ped, false)
                SetEntityAsNoLongerNeeded(ped)
                ClearPedTasksImmediately(ped)
                lastPed[#lastPed + 1] = ped
                break
            end
           -- end
            Wait(0)
        end
       -- Wait(math.random(4000, 7000))
    end
end

local function ToggleSelling()
    if not cornerselling then
        cornerselling = true
       -- LocalPlayer.state:set("inv_busy", true, true)
        QBCore.Functions.Notify("Selling Some Tacos BB")
        local startLocation = GetEntityCoords(PlayerPedId())
        CreateThread(function()
            while cornerselling do
                local player = PlayerPedId()
                local coords = GetEntityCoords(player)
                if not hasTarget then
                    local PlayerPeds = {}
                    if next(PlayerPeds) == nil then
                        for _, activePlayer in ipairs(GetActivePlayers()) do
                            local ped = GetPlayerPed(activePlayer)
                            PlayerPeds[#PlayerPeds + 1] = ped
                        end
                    end
                    local closestPed, closestDistance = QBCore.Functions.GetClosestPed(coords, PlayerPeds)
                    if closestDistance < 15.0 and closestPed ~= 0 and not IsPedInAnyVehicle(closestPed) and GetPedType(closestPed) ~= 28 then
                        SellToPed(closestPed)
                    end
                end
                local startDist = #(startLocation - coords)
                if startDist > 100 then
                    TooFarAway()
                end
                Wait(0)
            end
        end)
    else
        stealingPed = nil
        stealData = {}
        cornerselling = false
       -- LocalPlayer.state:set("inv_busy", false, true)
        QBCore.Functions.Notify("Sure Stop Selling Lazy Ass")
    end
end

-- Events
RegisterNetEvent('md-tacotruck:client:cornerselling', function()
    QBCore.Functions.TriggerCallback('md-tacotruck:server:cornerselling:getAvailableDrugs', function(result)
			if result then
				availableDrugs = result
				ToggleSelling()
			else
				QBCore.Functions.Notify("No More Tacos", 'error')
				--LocalPlayer.state:set("inv_busy", false, true)
			end
    end)
end)


RegisterNetEvent('md-tacotruck:client:refreshAvailableDrugs', function(items)
    availableDrugs = items
    if availableDrugs == nil or #availableDrugs <= 0 then
        QBCore.Functions.Notify("No Tacos Left", 'error')
        cornerselling = false
        --LocalPlayer.state:set("inv_busy", false, true)
    end
end)
