


fx_version 'adamant'
game 'gta5'

client_script 'cl_*.lua'
server_script {
    'sv_*.lua',
    '@mysql-async/lib/MySQL.lua'
}