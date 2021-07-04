ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
	while true do
		local plyPed = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(plyPed)
		local inRange = false
		local distance = #(plyCoords - Config.Locations["ClaimCoords"])

		if distance < 5 then
			inRange = true
			DrawMarker(2, Config.Locations["ClaimCoords"].x, Config.Locations["ClaimCoords"].y, Config.Locations["ClaimCoords"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)

			if distance < 2 then
				DrawText3Ds(Config.Locations["ClaimCoords"].x, Config.Locations["ClaimCoords"].y, Config.Locations["ClaimCoords"].z+0.2, "~g~[E]~w~ - Claim Free Car")

				if IsControlJustReleased(0, 38) then
					TriggerServerEvent("no1_freecar:server:claimVehicle")
				end
			elseif distance < 5 then
				DrawText3Ds(Config.Locations["ClaimCoords"].x, Config.Locations["ClaimCoords"].y, Config.Locations["ClaimCoords"].z+0.2, "Free Car")
			end
		end

		if not inRange then
			Citizen.Wait(2000)
		end

		Citizen.Wait(0)
	end
end)

AddEventHandler("no1_freecar:client:spawnClaimedVehicle", function()
	local plyPed = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(plyPed)

	if not ESX.Game.IsSpawnPointClear(Config.Locations["SpawnCoords"], 5) then 
		ESX.ShowNotification("Spawn point is not clear!")
		return
	end

	LoadVehicleModel(Config.Vehicle["model"])

	ESX.Game.SpawnVehicle(Config.Vehicle["model"], Config.Locations["SpawnCoords"], Config.Locations["SpawnCoords"].w, function(spawnedVehicle) 
		if DoesEntityExist(spawnedVehicle) then
			local plate = exports['esx_vehicleshop']:GeneratePlate()

			SetVehicleNumberPlateText(spawnedVehicle, plate)
			TaskWarpPedIntoVehicle(PlayerPedId(), spawnedVehicle, -1)

			local vehicleProps = ESX.Game.GetVehicleProperties(spawnedVehicle)
			TriggerServerEvent("no1_freecar:server:SetOwnedVehicle", plate, vehicleProps)
		end
	end)
end)

function LoadVehicleModel(vehicleModel)
	vehicleModel = GetHashKey(vehicleModel)

	if not HasModelLoaded(vehicleModel) then
		RequestModel(vehicleModel)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName('Vehicle model is loading')
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(vehicleModel) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end

RegisterNetEvent("no1_freecar:client:spawnClaimedVehicle")
