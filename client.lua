ESX                           = nil

local claimCoords = vector3(-57.63, -1096.88, 26.42)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if #(coords - claimCoords) < 5.0 then
            ESX.Game.Utils.DrawText3D(claimCoords, "~y~Press ~g~[E] ~y~to claim free car!", 0.5, 1)

            if IsControlJustReleased(0, 46) then
                TriggerServerEvent('skull_freecar:claimFreeCar')
            end
        end

    end
end)

RegisterNetEvent('skull_freecar:spawnVehicle')
AddEventHandler('skull_freecar:spawnVehicle', function(playerID, model)
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local carExist  = false

	ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle) --get vehicle info
		if DoesEntityExist(vehicle) then
			carExist = true
			SetEntityVisible(vehicle, false, false)
			SetEntityCollision(vehicle, false)
			
			local newPlate     = exports.esx_vehicleshop:GeneratePlate()
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			vehicleProps.plate = newPlate
            TriggerServerEvent('skull_freecar:setVehicle', vehicleProps, playerID)		
            ESX.Game.DeleteVehicle(vehicle)
            TriggerServerEvent('skull_freecar:setGarage', vehicleProps.plate)
		end		
	end)
end)