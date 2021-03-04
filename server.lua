ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('skull_freecar:claimFreeCar')
AddEventHandler('skull_freecar:claimFreeCar', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchScalar('SELECT identifier FROM log_freecar WHERE identifier = @identifier', { ['identifier'] = xPlayer.getIdentifier()}, function(result)
        if result then
            TriggerClientEvent('esx:showNotification', src, 'You already claimed a free car!')
        else
            TriggerClientEvent('esx:showNotification', src, '~b~Please get your ~g~free car~w~ from ~r~nearby garage!')

            MySQL.Async.execute('INSERT INTO log_freecar (identifier) VALUES (@identifier)', {['@identifier'] = xPlayer.getIdentifier()})   

            TriggerClientEvent('skull_freecar:spawnVehicle', src, src, Config.Modelname)
        end
    end)

end)

RegisterServerEvent('skull_freecar:setVehicle')
AddEventHandler('skull_freecar:setVehicle', function (vehicleProps, playerID)
	local _source = playerID
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (@owner, @plate, @vehicle, @type,@stored)',
	{
		['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@type']    = 'car',
		['@vehicle'] = json.encode(vehicleProps),
		['@stored']  = 1
	}, function ()
        TriggerClientEvent('esx:showNotification', _source, string.format("You received a vehicle with plate number ~y~%s", string.upper(vehicleProps.plate)))
	end)
end)

RegisterServerEvent('skull_freecar:setGarage')
AddEventHandler('skull_freecar:setGarage', function(plate)
    MySQL.Async.execute("UPDATE owned_vehicles SET `stored` = '1', `fuel` = '100.0' WHERE plate = @plate", {['@plate']  = plate})
end)