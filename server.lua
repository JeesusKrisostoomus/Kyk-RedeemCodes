local oldPrint = print
print = function(trash)
	oldPrint('^7[^2Redeem Codes^7] '..trash..'^0')
end

ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local RandomCode = ""


--[[
	Random code generation function
]]
function RandomCodeGenerator()
	if Config.numericGenerator then
		RandomCode = math.random(Config.minNumber, Config.maxNumber)
		return RandomCode
	elseif Config.alphanumericGen then
		local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
		local length = Config.length
	
		charTable = {}
		for c in chars:gmatch"." do
			table.insert(charTable, c)
		end
	
		for i = 1, length do
			RandomCode = RandomCode .. charTable[math.random(1, #charTable)]
		end
	
		return RandomCode
	else
		print("^1No valid generator method selected.")
	end
	
end


--[[
	Single code generation command
]]
RegisterCommand("genCode", function(source, args, rawCommand)
	--[[ Check to prevent both config values being false ]]
	if (Config.numericGenerator == false and Config.alphanumericGen == false) then
		if (source ~= 0) then
			TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "No valid generation method selected. Check if the config is setup correctly." }, color = 255,255,255 })
		else
			print("^1Please select a valid generation method from the config first.")
		end
	else
		--[[ Check to prevent args[1] from being nil ]]
		if (args[1] == nil) then
			if (source == 0) then
				print("Invalid type.\n[^2Redeem Codes^7] Current Types: Item, Bank, Cash, Weapon")
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid type. Current Types: Item, Cash, Bank, Weapon" }, color = 255,255,255 })
			end
		--[[ Check to prevent args[2] from being nil ]]
		elseif (args[1] ~= nil and args[2] == nil) then
			if (args[1] == "bank" and args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments.\n[^2Redeem Codes^7] Usage: genCode bank 'reward_amount'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments. Usage: /genCode bank 'reward_amount'" }, color = 255,255,255 })
				end
			elseif (args[1] == "cash" and args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments.\n[^2Redeem Codes^7] Usage: genCode cash 'reward_amount'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments. Usage: /genCode cash 'reward_amount'" }, color = 255,255,255 })
				end
			elseif (args[1] == "item" and args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments.\n[^2Redeem Codes^7] Usage: genCode item item_spawn_name' 'item count'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments. Usage: /genCode item 'item_spawn_name' 'item count'" }, color = 255,255,255 })
				end
			elseif (args[1] == "weapon" and args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments.\n[^2Redeem Codes^7] Usage: genCode weapon 'weapon_spawn_name' 'ammo_count'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments. Usage: /genCode weapon 'weapon_spawn_name' 'ammo_count'" }, color = 255,255,255 })
				end
			else
				if (source == 0) then
					print("Unknown Type.\n[^2Redeem Codes^7] Current Types: Item, Weapon, Bank Cash")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Unknown Type. Current Types: Current Types: Item, Weapon, Bank Cash" }, color = 255,255,255 })
				end
			end
		--[[ Bank reward code generation ]]
		elseif (string.lower(args[1]) == "bank") then
			MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, data1) VALUES (@code,@type,@data1)", {
				['@code'] = RandomCodeGenerator(),
				['@type'] = "bank", 
				['@data1'] = args[2]
			})
			if (source ~= 0) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code generated successfully! Check the database to see the code." }, color = 255,255,255 })
			else
				if RandomCode ~= nil and RandomCode ~= "" then
					print("Code Generated Successfully! Code: "..RandomCode)
				end
			end
			Wait(5)
			RandomCode = ""
		--[[ Cash reward code generation ]]
		elseif (string.lower(args[1]) == "cash") then
			MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, data1) VALUES (@code,@type,@data1)", {
				['@code'] = RandomCodeGenerator(),
				['@type'] = "cash", 
				['@data1'] = args[2]
			})
			if (source ~= 0) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code generated successfully! Check the database to see the code." }, color = 255,255,255 })
			else
				if RandomCode ~= nil and RandomCode ~= "" then
					print("Code Generated Successfully! Code: "..RandomCode)
				end
			end
			Wait(5)
			RandomCode = ""
		--[[ Weapon reward code generation ]]
		elseif (string.lower(args[1]) == "weapon") then
			MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
				['@code'] = RandomCodeGenerator(),
				['@type'] = "weapon", 
				['@data1'] = "weapon_"..args[2],
				['@data2'] = args[3]
			})
			if (source ~= 0) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code generated successfully! Check the database to see the code." }, color = 255,255,255 })
			else
				if RandomCode ~= nil and RandomCode ~= "" then
					print("Code Generated Successfully! Code: "..RandomCode)
				end
			end
			Wait(5)
			RandomCode = ""
		--[[ Item reward code generation ]]
		elseif (string.lower(args[1]) == "item") then
			MySQL.Async.fetchAll('SELECT * FROM `items` WHERE `name` = @name', {
				['@name'] = args[2]
			}, function(data2)
				if (data2[1].name ~= string.lower(args[2])) then
					if (source == 0) then
						print("Invalid item")
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid item." }, color = 255,255,255 })
					end
				else
					if (args[2] == nil) then
						if (source == 0) then
							print("Invalid arguments")
						else
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments." }, color = 255,255,255 })
						end
					else
						MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
							['@code'] = RandomCodeGenerator(),
							['@type'] = "item",
							['@data1'] = string.lower(args[2]),
							['@data2'] = args[3]
						})
						if (source ~= 0) then
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code generated successfully! Check the database to see the code." }, color = 255,255,255 })
						else
							if RandomCode ~= nil and RandomCode ~= "" then
								print("Code Generated Successfully! Code: "..RandomCode)
							end
						end
						Wait(5)
						RandomCode = ""
					end
				end
			end)
		end
	end
end, true)


--[[
	Multiple code generation command
]]
RegisterCommand("multiGen", function(source, args, rawCommand)
	if (Config.numericGenerator == false and Config.alphanumericGen == false) then
		print("^1Please select a valid generation method from the config first.")
	else
		--[[ Check to prevent args[1] from being nil ]]
		if (args[1] == nil) then
			if (source == 0) then
				print("Invalid type.\n[^2Redeem Codes^7] Current Types: Item, Bank, Cash, Weapon")
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid type. Current Types: Item, Cash, Bank, Weapon" }, color = 255,255,255 })
			end
		--[[ Check to prevent args[2] from being nil ]]
		elseif (args[1] ~= nil and args[2] == nil) then
			if (args[1] == "bank" and args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments.\n[^2Redeem Codes^7] Usage: multiGen bank 'reward_amount'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments. Usage: /multiGen bank 'reward_amount'" }, color = 255,255,255 })
				end
			elseif (args[1] == "cash" and args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments.\n[^2Redeem Codes^7] Usage: multiGen cash 'reward_amount'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments. Usage: /multiGen cash 'reward_amount'" }, color = 255,255,255 })
				end
			elseif (args[1] == "item" and args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments.\n[^2Redeem Codes^7] Usage: multiGen item item_spawn_name' 'item count'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments. Usage: /genCode item 'item_spawn_name' 'item count'" }, color = 255,255,255 })
				end
			elseif (args[1] == "weapon" and args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments.\n[^2Redeem Codes^7] Usage: multiGen weapon 'weapon_spawn_name' 'ammo_count'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments. Usage: /multiGen weapon 'weapon_spawn_name' 'ammo_count'" }, color = 255,255,255 })
				end
			else
				if (source == 0) then
					print("Unknown Type.\n[^2Redeem Codes^7] Current Types: Item, Weapon, Bank Cash")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Unknown Type. Current Types: Current Types: Item, Weapon, Bank Cash" }, color = 255,255,255 })
				end
			end
		elseif (string.lower(args[1]) == "bank") then
			if (args[3] == nil) then args[3] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
			if (tonumber(args[3]) < 21) then
				for shit=0, args[3]-1 do
					MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, data1) VALUES (@code,@type,@data1)", {
						['@code'] = RandomCodeGenerator(),
						['@type'] = "bank", 
						['@data1'] = args[2]
					})
					if (source == 0) then
						print("Code Generated Successfully! Code: "..RandomCode)
					end
					RandomCode = ""
				end
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Codes generated successfully! Check the database to see the codes." }, color = 255,255,255 })
				else
					print("Codes Generated Successfully!")
				end
			else
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Chill. Lets not crash the database." }, color = 255,255,255 })
				else
					print("Chill. Lets not crash the database.")
				end
			end
		elseif (string.lower(args[1]) == "weapon") then
			if (args[2] == nil or args[3] == nil) then
				if (source == 0) then
					print("Invalid arguments")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments." }, color = 255,255,255 })
				end
			else
				if (tonumber(args[3]) < 21) then
					for shit=0, args[4]-1 do
						MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
							['@code'] = RandomCodeGenerator(),
							['@type'] = "weapon", 
							['@data1'] = "weapon_"..args[2],
							['@data2'] = args[3]

						})
						Wait(5)
						if (source == 0) then
							print("Code Generated Successfully! Code: "..RandomCode)
						end
						RandomCode = ""
					end
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Codes generated successfully! Check the database to see the code." }, color = 255,255,255 })
					else
						print("Codes Generated Successfully!")
					end
				else
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Chill. Lets not crash the database." }, color = 255,255,255 })
					else
						print("Chill. Lets not crash the database.")
					end
				end
			end
		elseif (string.lower(args[1]) == "cash") then
			if (args[3] == nil) then args[3] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
			if (tonumber(args[3]) < 21) then
				for shit=0, args[3]-1 do
					MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, data1) VALUES (@code,@type,@data1)", {
						['@code'] = RandomCodeGenerator(),
						['@type'] = "cash", 
						['@data1'] = args[2]
					})
					if (source == 0) then
						print("Code Generated Successfully! Code: "..RandomCode)
					end
					RandomCode = ""
				end
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Codes generated successfully! Check the database to see the codes." }, color = 255,255,255 })
				else
					print("Codes Generated Successfully!")
				end
			else
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Chill. Lets not crash the database." }, color = 255,255,255 })
				else
					print("Chill. Lets not crash the database.")
				end
			end
		elseif (string.lower(args[1]) == "item") then
			if (args[3] == nil) then args[3] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
			if (args[4] == nil) then args[4] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
			if (tonumber(args[4]) < 21) then
				for shit=0, args[4]-1 do
					MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
						['@code'] = RandomCodeGenerator(),
						['@type'] = "item", 
						['@data1'] = args[2],
						['@data2'] = args[3]
					})
					if (source == 0) then
						print("Code Generated Successfully! Code: "..RandomCode)
					end
					RandomCode = ""
				end
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Codes generated successfully! Check the database to see the codes." }, color = 255,255,255 })
				else
					print("Codes Generated Successfully!")
				end
			else
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Chill. Lets not crash the database." }, color = 255,255,255 })
				else
					print("Chill. Lets not crash the database.")
				end
			end
		end
	end
end, true)


--[[
	Redeem Command
]]
RegisterCommand("redeem", function(source, args, rawCommand)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if (args[1] == nil) then 
		if (source ~= 0) then
			TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Code cannot be empty!" }, color = 255,255,255 })
		else
			print("Code cannot be empty!")
		end
	elseif (source == 0) then
		print("You cant redeem codes as console!")
	else
    	MySQL.Async.fetchAll('SELECT * FROM `RedeemCodes` WHERE `code` = @code', {
				['@code'] = args[1]
		}, function(data)
			if (json.encode(data) == "[]" or json.encode(data) == "null") then
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Code!" }, color = 255,255,255 })
				else
					print("You cant redeem codes as console + Invalid Code")
				end
			else
				if (args[1] == data[1].code) then
					if (source ~= 0) then
						if (data[1].type == "bank") then
							MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							xPlayer.addAccountMoney('bank', tonumber(data[1].data1))
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! You just recieved: $"..data[1].data1.." Bank." }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2Reward Codes^7]', "^1"..GetPlayerName(source).." ^7Just redeemed a reward code and recieved: ^1$"..data[1].data1 }, color = 255,255,255 })
							end
						elseif (data[1].type == "cash") then
							MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							xPlayer.addMoney(data[1].data1)
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! You just recieved: $"..data[1].data1.." Cash." }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2Reward Codes^7]', "^1"..GetPlayerName(source).." ^7Just redeemed a reward code and recieved: ^1$"..data[1].data1 }, color = 255,255,255 })
							end
						elseif (data[1].type == "item") then
							MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							xPlayer.addInventoryItem(data[1].data1, data[1].data2)
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! You just recieved: "..data[1].data1.." of "..data[1].data2.."." }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2Reward Codes^7]', "^1"..GetPlayerName(source).." ^7Just redeemed a reward code and recieved: ^1"..data[1].data2.."x "..data[1].data1 }, color = 255,255,255 })
							end
						elseif (data[1].type == "weapon") then
							MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							xPlayer.addWeapon(tostring(data[1].data1), data[1].data2)
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! You just recieved: "..data[1].data1.." with "..data[1].data2.." Bullets." }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2Reward Codes^7]', "^1"..GetPlayerName(source).." ^7Just redeemed a reward code and recieved a ^1"..string.upper(string.gsub(data[1].data1, "weapon_", "")) }, color = 255,255,255 })
							end
						else
							MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! Reward: Unknown" }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2Reward Codes^7]', "^1"..GetPlayerName(source).." ^7Just redeemed a reward code and recieved an unknown reward" }, color = 255,255,255 })
							end
						end
					end
				else
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Code!" }, color = 255,255,255 })
					else
						print("Invalid Code + You can't redeem codes as console.")
					end
				end
			end
		end)
	end
end, false)

--[[
	Huge thanks to https://github.com/XvenDeR for helping with alot of stuff.
]]