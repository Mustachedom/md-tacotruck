QBCore = exports['qb-core']:GetCoreObject()

local function getAvailableDrugs(source)
    local AvailableDrugs = {}
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return nil end

    for k in pairs(Config.DrugsPrice) do
        local item = Player.Functions.GetItemByName(k)

        if item then
            AvailableDrugs[#AvailableDrugs + 1] = {
                item = item.name,
                amount = item.amount,
                label = QBCore.Shared.Items[item.name]["label"]
            }
        end
    end
    return table.type(AvailableDrugs) ~= "empty" and AvailableDrugs or nil
end

QBCore.Functions.CreateCallback('md-tacotruck:server:cornerselling:getAvailableDrugs', function(source, cb)
    cb(getAvailableDrugs(source))
end)

RegisterNetEvent('md-tacotruck:server:giveStealItems', function(drugType, amount)
    local availableDrugs = getAvailableDrugs(source)
    local Player = QBCore.Functions.GetPlayer(source)

    if not availableDrugs or not Player then return end

    Player.Functions.AddItem(availableDrugs[drugType].item, amount)
end)

RegisterNetEvent('md-tacotruck:server:sellCornerDrugs', function(drugType, amount, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)

    if not availableDrugs or not Player then return end

    local item = availableDrugs[drugType].item

    local hasItem = Player.Functions.GetItemByName(item)
    if hasItem.amount >= amount then
        TriggerClientEvent('QBCore:Notify', src, Lang:t("success.offer_accepted"), 'success')
        Player.Functions.RemoveItem(item, amount)
        Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
        TriggerClientEvent('md-tacotruck:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
    else
        TriggerClientEvent('md-tacotruck:client:cornerselling', src)
    end
end)

RegisterServerEvent('md-tacotruck:server:payment', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	
	if Player.Functions.RemoveMoney('cash', 500 ) or Player.Functions.RemoveMoney('bank', 500 ) then
		Player.Functions.AddItem('mdtacos', 100)
		TriggerClientEvent("md-tacotruck:Client:gettruckloc", src)
	end
end)
