local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, playerInService = false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
local done = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	done = true
end)

-----------------------------------------------------------
-------------------------- NUI ----------------------------
-----------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj
			ESX.PlayerData = ESX.GetPlayerData()
		end)
		Citizen.Wait(15000)
		if PlayerData.job and (PlayerData.job.name == 'lcn' or PlayerData.job.name == 'automafija' or PlayerData.job.name == 'zemunski' or PlayerData.job.name == 'scarface' 
		or PlayerData.job.name == 'yakuza' or PlayerData.job.name == 'camorra' or PlayerData.job.name == 'pinkpanteri' or PlayerData.job.name == 'gsf'
		or PlayerData.job.name == 'bajkeri' or PlayerData.job.name == 'vagos' or PlayerData.job.name == 'ballas' or PlayerData.job.name == 'medelin' or PlayerData.job.name == 'sinaloa'
		or PlayerData.job.name == 'mexican' or PlayerData.job.name == 'bloods' or PlayerData.job.name == 'barani' or PlayerData.job.name == 'skaljarski' 
		or PlayerData.job.name == 'ltf' or PlayerData.job.name == 'crnogorci' or PlayerData.job.name == 'brazilci') then
			for i=1, #Config.Mafije[PlayerData.job.name]['VIP'], 1 do
				viplevel = (Config.Mafije[PlayerData.job.name]['VIP'][i])
				break
			end
			grade = ESX.PlayerData.job.grade_name
			orgname = ESX.PlayerData.job.label
			SendNUIMessage({
				action = 'setInfo',
				orgname = orgname,
				viplevel = viplevel,
				grade = grade
			})
		end
	end
end)

-- NUI Osnovno

local enableField = false

function toggleField(enable)
    SetNuiFocus(enable, enable)
    enableField = enable

    if enable then
        SendNUIMessage({
            action = 'open'
        }) 
    else
        SendNUIMessage({
            action = 'close'
        }) 
    end
end

AddEventHandler('onResourceStart', function(name)
    if GetCurrentResourceName() ~= name then
        return
    end

    toggleField(false)
end)

RegisterNUICallback('escape', function(data, cb)
    toggleField(false)
    SetNuiFocus(false, false)

    cb('ok')
end)

RegisterNUICallback('zaposljavanje', function(cb)
	local society = ESX.PlayerData.job.name
	exports['bullc_organizacije']:OpenRecruitMenu(society)
    cb('ok')
end)

RegisterNUICallback('listaClanova', function()
	local society = ESX.PlayerData.job.name
	exports['bullc_organizacije']:OpenEmployeeList(society)
end)

RegisterNUICallback('otvoriSef', function()
	local society = ESX.PlayerData.job.name
	local ime = ESX.PlayerData.job.label
	TriggerEvent('m3:inventoryhud:client:openStash', ime.." - Sef", society)
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
    for k,v in pairs(Config.Mafije[PlayerData.job.name]) do
		vozilo = (Config.Mafije[PlayerData.job.name]['MeniVozila'][data.name])
		break
	end
	for i=1, #Config.Mafije[PlayerData.job.name]['SpawnPoint'], 1 do
		coords = (Config.Mafije[PlayerData.job.name]['SpawnPoint'][i])
		break
	end
	ESX.Game.SpawnVehicle(vozilo, coords, 100, function(vehicle) -- 
		TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
	end)
	Wait(200)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleDirtLevel(vehicle, 0.0)
	--exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
    cb('ok')
end)

-- VIP VOZILA

RegisterNUICallback('spawnVehicleVip', function(data, cb)
    for k,v in pairs(Config.Mafije[PlayerData.job.name]) do
		vozilo = (Config.Mafije[PlayerData.job.name]['MeniVozila'][data.name])
		break
	end
	for i=1, #Config.Mafije[PlayerData.job.name]['SpawnPoint'], 1 do
		coords = (Config.Mafije[PlayerData.job.name]['SpawnPoint'][i])
		break
	end
	for a=1, #Config.Mafije[PlayerData.job.name]['VIP'], 1 do
		vip = (Config.Mafije[PlayerData.job.name]['VIP'][a])
		break
	end
	if data.name == 'Vozilo4' then
		if vip == 1 or vip == 2 or vip == 3 or vip == 4 or vip == 5 then
			ESX.Game.SpawnVehicle(vozilo, coords, 100, function(vehicle) -- 
				TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
			end)
			Wait(200)
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			SetVehicleDirtLevel(vehicle, 0.0)
			SetNuiFocus(false, false)
			SendNUIMessage({
				action = 'close'
			})
			--exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
			cb('ok')
		else
			SendNUIMessage({
				action = 'novip'
			})
		end
	end
	if data.name == 'Vozilo5' then
		if vip == 2 or vip == 3 or vip == 4 or vip == 5 then
			ESX.Game.SpawnVehicle(vozilo, coords, 100, function(vehicle) -- 
				TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
			end)
			Wait(200)
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			SetVehicleDirtLevel(vehicle, 0.0)
			toggleField(false)
    		SetNuiFocus(false, false)
			--exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
			cb('ok')
		else
			SendNUIMessage({
				action = 'novip'
			})
		end
	end
	if data.name == 'Vozilo6' then
		if vip == 3 or vip == 4 or vip == 5 then
			ESX.Game.SpawnVehicle(vozilo, coords, 100, function(vehicle) -- 
				TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
			end)
			Wait(200)
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			SetVehicleDirtLevel(vehicle, 0.0)
			toggleField(false)
    		SetNuiFocus(false, false)
			--exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
			cb('ok')
		else
			SendNUIMessage({
				action = 'novip'
			})
		end
	end
	-- BROD SPAWNPOINT DODAT I KOD ZA IME
	if data.name == 'Vozilo7' then
		if vip == 4 or vip == 5 then
			ESX.Game.SpawnVehicle(vozilo, coords, 100, function(vehicle) -- 
				TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
			end)
			Wait(200)
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			SetVehicleDirtLevel(vehicle, 0.0)
			toggleField(false)
    		SetNuiFocus(false, false)
			--exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
			cb('ok')
		else
			SendNUIMessage({
				action = 'novip'
			})
		end
	end
	-- HELI SPAWNPOINT DODAT I KOD ZA IME
	if data.name == 'Vozilo8' then
		if vip == 5 then
			ESX.Game.SpawnVehicle(vozilo, coords, 100, function(vehicle) -- 
				TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
			end)
			Wait(200)
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			SetVehicleDirtLevel(vehicle, 0.0)
			toggleField(false)
    		SetNuiFocus(false, false)
			--exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
			cb('ok')
		else
			SendNUIMessage({
				action = 'novip'
			})
		end
	end
end)

-----------------------------------------------------------
----------------------- NUI KRAJ --------------------------
-----------------------------------------------------------


-----------------------
-------FUNKCIJE--------
-----------------------
ocistiIgraca = function(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

ObrisiVozilo = function()
	local playerPed = PlayerPedId()
    local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
	ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
	ESX.ShowNotification("Uspešno ste parkirali ~r~vozilo~s~ u garažu.")
end

--Sef Menu --
OpenArmoryMenu = function(station)
	local elements = {
		{label = 'Sef | 📷', value = 'sef'},
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		css      = 'mafia',
		title    = _U('armory'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'sef' then
			TriggerServerEvent("sogolisica_sefovi:povuciInv", PlayerData.job.name)
		end
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end

StvoriVozilo = function(vozilo)
    local playerPed = PlayerPedId()
    local playerpos = GetEntityCoords(playerPed)
    local headingIgraca = GetEntityHeading(playerPed)

    for k,v in pairs(Config.Mafije[PlayerData.job.name]) do
        a = (Config.Mafije[PlayerData.job.name]['MeniVozila'][vozilo])
        break
    end

    ESX.Game.SpawnVehicle(a, playerpos, headingIgraca, function(vozilo)
        TaskWarpPedIntoVehicle(playerPed, vozilo, -1)
        if PlayerData.job.name == 'gsf' then
            SetVehicleColours(vozilo, 53, 53)
        elseif PlayerData.job.name == 'ballas' then
            SetVehicleColours(vozilo, 145, 145)
        elseif PlayerData.job.name == 'vagos' then
            SetVehicleColours(vozilo, 88, 88)
        elseif PlayerData.job.name == 'medelin' then
            SetVehicleColours(vozilo, 0, 0)
        elseif PlayerData.job.name == 'bloods' then
            SetVehicleColours(vozilo, 27, 27)
        elseif PlayerData.job.name == 'crips' then
            SetVehicleColours(vozilo, 64, 64)
        end
    end)
end

function SetVehicleMaxMods(vehicle)
    local props = {
		plate           = 'BULLS',
        modEngine       = 4,
        modBrakes       = 4,
        modTransmission = 4,
        modSuspension   = 4,
        modTurbo        = true
    }

    ESX.Game.SetVehicleProperties(vehicle, props)
end

OtvoriAutoSpawnMenu = function(type, station, part, partNum)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vozila_meni',
        {
        	css      = 'vagos',
            title    = 'Izaberi Vozilo | 🚗',
            elements = {
            	{icon= 'fas fa-car', label = 'Vozilo 1 | 🚗', value = 'primo2'},
				{icon= 'fas fa-car', label = 'Vozilo 2 | 🚗', value = 'seminole'},
				{icon= 'fas fa-car', label = 'Vozilo 3 | 🚗', value = 'enduro'},
            }
        },
        function(data, menu)
            if data.current.value == 'primo2' then
				StvoriVozilo('Vozilo1')
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'seminole' then
				StvoriVozilo('Vozilo2')
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'enduro' then
				StvoriVozilo('Vozilo3')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

OtvoriHeliSpawnMenu = function(type, station, part, partNum)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vozila_meni',
        {
        	css      = 'vagos',
            title    = 'Izaberi Vozilo | 🚁',
            elements = {
            	{icon= 'fas fa-car', label = 'Helikopter | 🚁', value = 'fxho'},
				{icon= 'fas fa-car', label = 'Helikopter2 | 🚁', value = 'seashark'},
            }
        },
        function(data, menu)
        	local playerPed = PlayerPedId()
            if data.current.value == 'fxho' then
				ESX.Game.SpawnVehicle("volatus", vector3(-1906.37, 2017.2, 140.94), 96.17, function(vehicle) -- 
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
                exports["balkankings_gorivo"]:SetFuel(vehicle, 100)

				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'seashark' then
				ESX.Game.SpawnVehicle("seasparrow", vector3(-1906.37, 2017.2, 140.94), 96.17, function(vehicle) -- 
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
                exports["balkankings_gorivo"]:SetFuel(vehicle, 100)

				ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

OtvoriBrodSpawnMenu = function(type, station, part, partNum)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vozila_meni',
        {
        	css      = 'vagos',
            title    = 'Izaberi Vozilo | 🛶',
            elements = {
            	{icon= 'fas fa-car', label = 'JetSki | 🛶', value = 'fxho'},
				{icon= 'fas fa-car', label = 'Jahta | 🛶', value = 'seashark'},
            }
        },
        function(data, menu)
        	local playerPed = PlayerPedId()
            if data.current.value == 'fxho' then
				ESX.Game.SpawnVehicle("fxho", vector3(-2126.66, -601.68, 0.33), 177.44, function(vehicle) -- 
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
                exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'seashark' then
				ESX.Game.SpawnVehicle("yacht2", vector3(-2126.66, -601.68, 0.33), 177.44, function(vehicle) -- 
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
                exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
				ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

OtvoriPosaoMenu = function()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'panteri_actions', {
		css      = 'vagos',
		title    = 'Mafija Meni | 🎩',
		align    = 'top-left',
		elements = {
			{icon = 'fas fa-user', label = _U('citizen_interaction'), value = 'citizen_interaction'},
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {
				--{icon = 'fas fa-search', label = _U('search'), value = 'body_search'},
				{icon= 'fas fa-search', label = _U('search'), value = 'body_search'},
				{icon = 'fas fa-lock', label = _U('handcuff'), value = 'handcuff'},
				{icon = 'fas fa-handshake', label = _U('drag'), value = 'drag'},
				{icon = 'fas fa-arrow-up ', label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
				{icon = 'fas fa-arrow-down ', label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'vagos',
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'body_search' then
						exports["progressBars"]:startUI(3000, "Pretrazivanje..")
						Wait(3000)
						TriggerServerEvent('bullc_mafije:poruka', GetPlayerServerId(closestPlayer), _U('being_searched'))
						PretrazivanjeIgraca(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('bullc_mafije:vezivanje', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('bullc_mafije:vuci', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('bullc_mafije:staviUVozilo', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('bullc_mafije:staviVanVozila', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

PretrazivanjeIgraca = function(player)
	ESX.TriggerServerCallback('bullc_mafije:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {label = _U('guns_label')})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			css      = 'vagos',
			title    = _U('search'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('bullc_mafije:oduzmiItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				PretrazivanjeIgraca(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))

end

-----------------------------
---------EVENTOVI------------
-----------------------------

AddEventHandler('bullc_mafije:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Helikopter' then
		CurrentAction     = 'Helikopter'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Brodovi' then
		CurrentAction     = 'Brodovi'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	elseif part == 'ParkirajAuto' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'ParkirajAuto'
			CurrentActionMsg  = 'Pritisnite ~INPUT_CONTEXT~ da ~r~parkirate~s~ vozilo u garažu.'
			CurrentActionData = { vehicle = vehicle }
		end
	end
end)

AddEventHandler('bullc_mafije:hasExitedMarker', function(station, part, partNum)
    ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('bullc_mafije:vezivanje')
AddEventHandler('bullc_mafije:vezivanje', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		if isHandcuffed then
			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, true)
			DisplayRadar(false)
		else
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)
end)

RegisterNetEvent('bullc_mafije:odvezivanje')
AddEventHandler('bullc_mafije:odvezivanje', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('bullc_mafije:vuci')
AddEventHandler('bullc_mafije:vuci', function(copId)
	if not isHandcuffed then
		return
	end
	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed
	while true do
		Citizen.Wait(1)
		if isHandcuffed then
			playerPed = PlayerPedId()
			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
				-- Odvezi ako je igrac u autu
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end
				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end
			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('bullc_mafije:staviUVozilo')
AddEventHandler('bullc_mafije:staviUVozilo', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not isHandcuffed then
		return
	end
	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end
			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('bullc_mafije:staviVanVozila')
AddEventHandler('bullc_mafije:staviVanVozila', function()
	local playerPed = PlayerPedId()
	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
    TriggerEvent('bullc_mafije:odvezivanje')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

-------MAFIJA DRAWMARKERI----------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
-- cvecar, farmer, elektricar, mechanic, police, vinarija, taxi, vlada, rudar, ribar, picerija, gradjevinar, ambulance, vodoinstalater, saj, sheriff
		if PlayerData.job and (PlayerData.job.name ~= 'nezaposlen' or PlayerData.job.name ~= 'cvecar' or PlayerData.job.name ~= 'farmer' or PlayerData.job.name ~= 'elektricar' or PlayerData.job.name ~= 'mechanic' or PlayerData.job.name ~= 'police'
			or PlayerData.job.name ~= 'vinarija' or PlayerData.job.name ~= 'taxi' or PlayerData.job.name ~= 'vlada' or PlayerData.job.name ~= 'rudar' or PlayerData.job.name ~= 'ribar' or PlayerData.job.name ~= 'picerija' 
			or PlayerData.job.name ~= 'gradjevinar' or PlayerData.job.name ~= 'ambulance' or PlayerData.job.name ~= 'vodoinstalater' or PlayerData.job.name ~= 'saj' or PlayerData.job.name ~= 'sheriff' or PlayerData.job.name ~= 'vlada') 
			then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum
			if Config.Mafije[PlayerData.job.name] == nil then
				return
			end
			for k,v in pairs(Config.Mafije[PlayerData.job.name]) do
				--[[if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'savetnik' then
					for i=1, #Config.Mafije[PlayerData.job.name]['Armories'], 1 do
						local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['Armories'][i], true)
	
						if distance < Config.DrawDistance then
							DrawMarker(21, Config.Mafije[PlayerData.job.name]['Armories'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end
	
						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
						end
					end
				end]]
				for i=1, #Config.Mafije[PlayerData.job.name]['ParkirajAuto'], 1 do
					local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['ParkirajAuto'][i], true)

					if distance < Config.DrawDistance then
						DrawMarker(1, Config.Mafije[PlayerData.job.name]['ParkirajAuto'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 255, 0, 0, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerAuto.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'ParkirajAuto', i
					end
				end

				--[[for i=1, #Config.Mafije[PlayerData.job.name]['Vehicles'], 1 do
					local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['Vehicles'][i], true)

					if distance < Config.DrawDistance then
						DrawMarker(36, Config.Mafije[PlayerData.job.name]['Vehicles'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
					end
				end

			if PlayerData.job.name == 'barani' then
				for i=1, #Config.Mafije[PlayerData.job.name]['Helikopter'], 1 do
					local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['Helikopter'][i], true)

					if distance < Config.DrawDistance then
						DrawMarker(34, Config.Mafije[PlayerData.job.name]['Helikopter'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helikopter', i
					end
				end

				for i=1, #Config.Mafije[PlayerData.job.name]['Brodovi'], 1 do
					local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['Brodovi'][i], true)

					if distance < Config.DrawDistance then
						DrawMarker(35, Config.Mafije[PlayerData.job.name]['Brodovi'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Brodovi', i
					end
				end
			end]]

			if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'glava' or PlayerData.job.grade_name == 'savetnik' or PlayerData.job.grade_name == 'regrut' then
				for i=1, #Config.Mafije[PlayerData.job.name]['BossActions'], 1 do
					local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['BossActions'][i], true)

					if distance < Config.DrawDistance then
						DrawMarker(22, Config.Mafije[PlayerData.job.name]['BossActions'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
					end
				end
			end
		end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('bullc_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('bullc_mafije:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('bullc_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(1000)
			end

		else
			Citizen.Wait(500)
		end
	end
end)

-- Trenutna akcija za markere i key kontrole--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38)  then
				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				elseif CurrentAction == 'menu_armory' then
					OpenArmoryMenu(CurrentActionData.station)
				elseif CurrentAction == 'menu_vehicle_spawner' then
					OtvoriAutoSpawnMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
				elseif CurrentAction == 'ParkirajAuto' then
					ObrisiVozilo()
				elseif CurrentAction == 'Helikopter' then
					OtvoriHeliSpawnMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
				elseif CurrentAction == 'Brodovi' then
					OtvoriBrodSpawnMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
				elseif CurrentAction == 'menu_boss_actions' then
					--[[ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)
						menu.close()
						
						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false })]]
					toggleField(true)
				end

				CurrentAction = nil
			end
		end -- CurrentAction end

		if PlayerData.job and (PlayerData.job.name == 'lcn' or PlayerData.job.name == 'automafija' or PlayerData.job.name == 'zemunski' or PlayerData.job.name == 'scarface' 
		or PlayerData.job.name == 'yakuza' or PlayerData.job.name == 'camorra' or PlayerData.job.name == 'pinkpanteri' or PlayerData.job.name == 'gsf'
		or PlayerData.job.name == 'bajkeri' or PlayerData.job.name == 'vagos' or PlayerData.job.name == 'ballas' or PlayerData.job.name == 'medelin' or PlayerData.job.name == 'sinaloa'
		or PlayerData.job.name == 'mexican' or PlayerData.job.name == 'bloods' or PlayerData.job.name == 'barani' or PlayerData.job.name == 'skaljarski' 
		or PlayerData.job.name == 'ltf' or PlayerData.job.name == 'crnogorci' or PlayerData.job.name == 'brazilci') then
				if IsControlJustReleased(0, 167) and not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') then
					OtvoriPosaoMenu()
				end
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('bullc_mafije:odvezivanje')
	end
end)