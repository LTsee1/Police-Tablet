local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

RegisterNetEvent('tablet_police:Mandat')
AddEventHandler('tablet_police:Mandat', function(target, mandatAmount, mandatReason)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local policjant = GetCharacterName(_source)
	local policee = policjant.." (".. sourceXPlayer.getName() ..")"
	local name = GetCharacterName(target)
	local mandat = tonumber(mandatAmount)
	targetXPlayer.removeAccountMoney('bank', mandat)
	sourceXPlayer.addAccountMoney('bank', mandat / 2)
    TriggerClientEvent('chatMessage', -1, 'MANDAT', { 147, 196, 109 }, '^*'..name ..' ^2dostał mandat o wartosci '..mandat..'$ ^1| ^2Powod: ^7'..mandatReason..' | '..policee.. ' ['..target..']')
	

end)

function GetLicenses(id)
	local dmv,weapon_license = false,false
	local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE owner = @a ", {
		['@a'] = id
			})
			for i=1,#result,1 do 
			if result[1] ~= nil then 
				if result[i]['type'] == "dmv" then
					dmv = true
				elseif result[i]['type'] == 'weapon' then
					weapon_license = true
				end
			end
			end
			return dmv,weapon_license
end

ESX.RegisterServerCallback('CheckUser', function(source, cb, arg)
	local splited = splitString(arg,' ')
	local identifier,height,sex,birth = nil,nil,nil,nil
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE firstname = @a AND lastname = @b", {
['@a'] = splited[1],
['@b'] = splited[2]
	})

if result[1] ~= nil then
		identifier = result[1]['identifier']
		height = result[1]['height']
		sex = result[1]['sex']
		birth = result[1]['dateofbirth']
	local dmv,license = GetLicenses(identifier)
	
	
	
		local data = {}
		data['dmv'] = dmv
		data['weapon']	= license
		data['height'] = height
		data['sex'] = sex
		data['birth'] = birth

		
cb(data)
end
end)



function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].firstname ~= nil and result[1].lastname ~= nil then
		return result[1].firstname .. ' ' .. result[1].lastname
	else
		return GetPlayerName(source)
	end
end
function GetImie(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].firstname ~= nil then
		return result[1].firstname
	else
		return GetPlayerName(source)
	end
end
function GetNazwisko(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].lastname ~= nil then
		return result[1].lastname
	else
		return GetPlayerName(source)
	end
end