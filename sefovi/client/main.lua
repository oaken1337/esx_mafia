local GUI, lastVehicle, lastOpen, vehiclePlate, CloseToVehicle, entityWorld, globalplate, allow = {}, nil, false, {}, false, nil, nil, true
ESX, GUI.Time = nil, 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
 	ESX.PlayerData.job = job
end)

function Notifikacija(message)
    if allow then
        allow = false
        TriggerEvent("pNotify:SendNotification", {text = message, type = "success", queue = "success", timeout = 2000, layout = "centerRight"})

        ESX.SetTimeout(1000, function()
            allow = true
        end)
    end
end

RegisterNetEvent('bullc_sefovi:ucitajInv')
AddEventHandler('bullc_sefovi:ucitajInv', function(inventory)
    local elements = {}
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    table.insert(elements, {
        label     = 'Stavi u Sef | 👜',
        value     = 'deposit',
    })

    if closestPlayer == -1 or closestDistance > 4.0 then

    if inventory ~= nil and #inventory > 0 then
        for k,v in ipairs(inventory) do
        	if v.type == 'item_standard' then
                table.insert(elements, {
                	label = ('<span style="color:yellow;">%sx</span> %s'):format(v.count, v.label),
                    count     = v.count,
                    value     = v.name,
                    type	  = v.type
                })
            elseif v.type == 'item_weapon' then
                table.insert(elements, {
                    label = ('<span style="color:yellow;">%sx</span> %s'):format(v.count, v.name),
                    count     = v.count,
                    value     = v.name,
                    type      = v.type
                })
            elseif v.type == 'item_account' then
            	table.insert(elements, {
                	label = ('<span style="color:yellow;">%sx</span> %s'):format(v.count, v.label),
                    count     = v.count,
                    value     = v.name,
                    type	  = v.type
                })
            end
        end
    end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'inventory_deposit',
        {
            title    = 'Sef',
            align    = 'bottom-right',
            elements = elements,
        },
        function(data, menu)
            if data.current.value == 'deposit' then

                ESX.TriggerServerCallback("bullc_core:itemLoop", function(elementi)
                    elem = {}
                    for k,v in ipairs(elementi) do
                        table.insert(elem, {
                            label = ('<span style="color:yellow;">%sx</span> %s'):format(v.count, v.label),
                            count = v.count,
                            value = v.name,
                            name = v.name,
                            limit = v.limit,
                            type = 'item_standard',
                        })
                    end
                end)

	            ESX.TriggerServerCallback("bullc_core:blackMoney", function(prljavkes)
                    for k,v in ipairs(prljavkes) do
                        table.insert(elem, {
                            label = ('<span style="color:yellow;">%sx</span> %s'):format(v.count, v.name),
                            count = v.count,
                            value = v.name,
                            name = v.name,
                            type = 'item_account',
                        })
                    end
                end)

                ESX.TriggerServerCallback("bullc_core:getLoadout", function(getLoadout)
                    for k,v in ipairs(getLoadout) do
                        table.insert(elem, {
                            label = ('<span style="color:yellow;">%sx</span> %s'):format(1, v.label),
                            count = 1,
                            value = v.name,
                            name = v.name,
                            type = 'item_weapon',
                        })
                    end
                end)

                while elem == nil do
                    Wait(1000)
                end

                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'inventory_player',
                    {
                        css      = 'meni',
                        title    = 'Inventar | 🤷‍',
                        align    = 'bottom-right',
                        elements = elem,
                    },function(data3, menu3)
                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', { title = 'kolicina' }, function(data4, menu4)
                                local quantity = tonumber(data4.value)

                                if quantity > 0 and quantity <= tonumber(data3.current.count) then
                                    TriggerServerEvent('bullc_sefovi:staviItemSef', ESX.PlayerData.job.name, data3.current.value, quantity, data3.current.name, data3.current.type)
                                    Citizen.Wait(500)
                                    TriggerServerEvent("bullc_sefovi:povuciInv", ESX.PlayerData.job.name)
                                else
                                	Notifikacija("Nevažeća količina!")
                                end
                                ESX.UI.Menu.CloseAll()
                            end,
                            function(data4, menu4)
                                ESX.UI.Menu.CloseAll()
                            end
                        )
                    end,
                    function(data, menu)
                        menu.close()
                    end)
            elseif data.current.type == 'cancel' then
                menu.close()
            else
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', { title = 'kolicina' }, function(data2, menu2)
                        local quantity = tonumber(data2.value)
                        if quantity > 0 and quantity <= tonumber(data.current.count) then
                            TriggerServerEvent('bullc_sefovi:izvadiIzSefa', ESX.PlayerData.job.name, data.current.value, data.current.type, quantity)
                        else
                        	Notifikacija("Nevažeća količina!")
                        end

                        ESX.UI.Menu.CloseAll()

                        ESX.SetTimeout(1500, function()
                            TriggerServerEvent("bullc_sefovi:povuciInv", ESX.PlayerData.job.name)
                        end)
                    end,
                    function(data2, menu2)
                        ESX.UI.Menu.CloseAll()
                    end
                )
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
    else
        TriggerEvent("auroraNotify:SendNotification", {text = "Recite ljudima u blizini da se pomere!", type = "success", queue = "success", timeout = 2500, layout = "centerRight"})
    end 

end)
