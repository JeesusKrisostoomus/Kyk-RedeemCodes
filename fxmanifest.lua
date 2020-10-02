fx_version 'cerulean'
games { 'gta5' }

author 'Jeesus Krisostoomus#7737'

client_scripts {
    'client.lua'
}
server_scripts {
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    'server.lua'
}
shared_scripts {
    'config.lua'
}

dependencies {
	'async',
    'mysql-async'
}
