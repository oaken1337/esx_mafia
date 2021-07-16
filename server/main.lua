ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'lcn', 'lcn', 'society_lcn', 'society_lcn', 'society_lcn', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'automafija', 'automafija', 'society_automafija', 'society_automafija', 'society_automafija', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'zemunski', 'zemunski', 'society_zemunski', 'society_zemunski', 'society_zemunski', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'scarface', 'scarface', 'society_scarface', 'society_scarface', 'society_scarface', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'camorra', 'camorra', 'society_camorra', 'society_camorra', 'society_camorra', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'pinkpanteri', 'pinkpanteri', 'society_pinkpanteri', 'society_pinkpanteri', 'society_pinkpanteri', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'gsf', 'gsf', 'society_gsf', 'society_gsf', 'society_gsf', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'bajkeri', 'bajkeri', 'society_bajkeri', 'society_bajkeri', 'society_bajkeri', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'vagos', 'vagos', 'society_vagos', 'society_vagos', 'society_vagos', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'ballas', 'ballas', 'society_ballas', 'society_ballas', 'society_ballas', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'medelin', 'medelin', 'society_medelin', 'society_medelin', 'society_medelin', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'sinaloa', 'sinaloa', 'society_sinaloa', 'society_sinaloa', 'society_sinaloa', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'mexican', 'mexican', 'society_mexican', 'society_mexican', 'society_mexican', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'bloods', 'bloods', 'society_bloods', 'society_bloods', 'society_bloods', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'barani', 'barani', 'society_barani', 'society_barani', 'society_barani', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'yakuza', 'yakuza', 'society_yakuza', 'society_yakuza', 'society_yakuza', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'skaljarski', 'skaljarski', 'society_skaljarski', 'society_skaljarski', 'society_skaljarski', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'ltf', 'ltf', 'society_ltf', 'society_ltf', 'society_ltf', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'crnogorci', 'crnogorci', 'society_crnogorci', 'society_crnogorci', 'society_crnogorci', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'brazicli', 'brazicli', 'society_brazicli', 'society_brazicli', 'society_brazicli', {type = 'public'})

--[[local Posao = {
	[0] = '',
	[1] = ''

}

RegistrujPosao = function(posao) do


end
--]]
-----------------------
-----CALLBACKOVI-------
-----------------------
ESX.RegisterServerCallback('bullc_mafije:getOtherPlayerData', function(source, cb, target)
		local xPlayer = ESX.GetPlayerFromId(target)
		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout
		}
		cb(data)
end)

ESX.RegisterServerCallback('bullc_mafije:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

-----------------------
-------EVENTOVI--------
-----------------------
RegisterServerEvent('bullc_mafije:oduzmiItem')
AddEventHandler('bullc_mafije:oduzmiItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- provera kolicine
		if targetItem.count > 0 and targetItem.count <= amount then

			-- da li moze da nosi stvari
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
				mafije("Mafije", sourceigrac.name .. " (" .. sourceigrac.identifier .. ") je oduzeo " .. amount .. " x " .. sourceItem.label .. " od " .. targetigrac.name .. " (" .. targetigrac.identifier .. ")")
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))
		mafije("Mafije", sourceigrac.name .. " (" .. sourceigrac.identifier .. ") je oduzeo €" .. amount .. " " .. itemName .. " od " .. targetigrac.name .. " (" .. targetigrac.identifier .. ")")

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
		mafije("Mafije", sourceigrac.name .. " (" .. sourceigrac.identifier .. ") je oduzeo " .. ESX.GetWeaponLabel(itemName) .. " sa " .. amount .. " metkova od " .. targetigrac.name .. " (" .. targetigrac.identifier .. ")")
	end
end)

RegisterServerEvent('bullc_mafije:vezivanje')
AddEventHandler('bullc_mafije:vezivanje', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('bullc_mafije:vezivanje', target)
end)

RegisterServerEvent('bullc_mafije:vuci')
AddEventHandler('bullc_mafije:vuci', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('bullc_mafije:vuci', target, source)
end)

RegisterServerEvent('bullc_mafije:staviUVozilo')
AddEventHandler('bullc_mafije:staviUVozilo', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('bullc_mafije:staviUVozilo', target)
end)

RegisterServerEvent('bullc_mafije:staviVanVozila')
AddEventHandler('bullc_mafije:staviVanVozila', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('bullc_mafije:staviVanVozila', target)
end)

RegisterServerEvent('bullc_mafije:poruka')
AddEventHandler('bullc_mafije:poruka', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

function mafije(name, message)
    local poruka = {
        {
            ["color"] = 16711680,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
            ["text"] = " Mafije Logovi",
            },
        }
      }
    PerformHttpRequest("https://discord.com/api/webhooks/863393807014166548/QcgTzpI6UbuBbKtM2Bc2WcZk7DhZ187iVcjmyoaWwA6KhGjbOJg8K0pAaSSwEJY1yMqk", function(err, text, headers) end, 'POST', json.encode({username = " Mafija Logovi ", embeds = poruka, avatar_url = ""}), { ['Content-Type'] = 'application/json' })
end