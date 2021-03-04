fx_version 'adamant'
game 'gta5'

client_script 'client.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

shared_script 'config.lua'