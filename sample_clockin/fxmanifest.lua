fx_version 'cerulean'
game 'gta5'

author 'Sample'
version '0.0.1'

lua54 'yes'

server_script {
    'sv_*.lua',
    '@mysql-async/lib/MySQL.lua'
}
shared_script 'sh_*.lua'
client_script 'cl_*.lua'