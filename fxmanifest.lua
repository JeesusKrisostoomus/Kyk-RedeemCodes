fx_version 'cerulean'
games { 'gta5' }

author 'Jeesus Krisostoomus#7737'
description 'https://github.com/JeesusKrisostoomus/FiveM-RedeemCodes'

client_scripts {
	'client.lua'
}

server_scripts {
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    'server.lua',
	'config.lua'
}

dependencies {
	'async',
	'mysql-async',
	'es_extended'
}
