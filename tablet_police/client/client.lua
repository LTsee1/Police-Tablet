local display = false
local PlayerData              = {}
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
	
	Citizen.Wait(1000)
	PlayerData = ESX.GetPlayerData()

end)
 function distance(coordsA, coordsB, useZ)
  local firstVec = vector3(coordsA.x, coordsA.y, coordsA.z)
  local secondVec = vector3(coordsB.x, coordsB.y, coordsB.z)
  if useZ then
      return #(firstVec - secondVec)
  else 
      return #(firstVec.xy - secondVec.xy)
  end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)


RegisterCommand("tablet", function()
    Citizen.CreateThread(function()
        if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice') then
        if not display then
      TriggerEvent('nui:on', true)
      SetNuiFocus(true, true)
        else
            TriggerEvent('nui:off', true)
            SetNuiFocus(false,false)
        end
        display = not display
    else
        ESX.ShowNotification("~r~Nie jesteś na służbie!")
    end
    end)
end)

RegisterNetEvent('nui:on')
AddEventHandler('nui:on', function()
  SendNUIMessage({
    type = "ui",
    display = true
  })
end)

RegisterNetEvent('nui:off')
AddEventHandler('nui:off', function()
  SendNUIMessage({
    type = "ui",
    display = false
  })
end)
RegisterNUICallback('Tablet_focusoff', function()
	SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        display = false
      })
	display = false
end)
RegisterNUICallback('get_persons', function()
local players = ESX.Game.GetPlayers()
local ped = PlayerPedId()
local ped_c = GetEntityCoords(ped, 0 )
local finded = 0
SendNUIMessage({
  type = "reset_persons",
})




for k,v in ipairs(players) do
  local targetPed = GetPlayerPed(v)
   local targetcoords = GetEntityCoords(targetPed, 0)
     local d = distance(targetcoords,ped_c, true)
     
    if (d <= 3.0 or d == -1) and targetPed ~= ped then
     finded = finded + 1
SendNUIMessage({
  type = "add_person",
  id =  GetPlayerServerId(v)
})
   end
   if finded <= 0 then
    SendNUIMessage({
      type = "add_person",
      id =  'W poblizu nie ma zadnego gracza'
    })
  end
end


end)
RegisterNUICallback('show_kare', function(data,cb)
  if data.kara ~= nil then
    local cmd = 'me '..data.kara
  ExecuteCommand(cmd)
  end
end)
RegisterNUICallback('tablet_search', function(data,cb)
  if data.name ~= nil then
  ESX.TriggerServerCallback('CheckUser', function(result)
     local height = 'Wzrost: '..result['height']
    local sex = 'Płeć: '..result['sex']
    local birth = 'Data urodzenia: '..result['birth']
    local weapon,dmv = '',''
    if result['weapon'] then
      weapon = 'ma'
    end
    if result['dmv'] then
      dmv = 'ma'
    end
    SendNUIMessage({
      type = "finded",
      h = height,
      s = sex,
      b = birth,
      w = weapon,
      d = dmv
    })
  end, data.name)
end
end)
function JailPlayer(player, czas, powod, grzywna)
	TriggerServerEvent("esx_jailer:sendToJail", player, czas * 30, powod, grzywna)
end

function MandatPlayer(id,g,r)
  TriggerServerEvent("tablet_police:Mandat", id, g, r)
end
RegisterNUICallback('tablet_jail', function(data,cb)
  print(ESX.DumpTable(data))
  if data.id ~= 'W poblizu nie ma zadnego gracza' then
		JailPlayer(data.id, data.jaillat, data.jailreason, data.jailamount)
  end
end)


RegisterNUICallback('tablet_mandat', function(data,cb)
  print(ESX.DumpTable(data))
  if data.id ~= 'W poblizu nie ma zadnego gracza' then
		MandatPlayer(data.id, data.mandatamount, data.mandatreason)
  end
end)