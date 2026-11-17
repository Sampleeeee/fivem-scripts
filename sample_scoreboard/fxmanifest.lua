description 'Scoreboard'

-- temporary!
ui_page 'html/scoreboard.html'

client_script 'scoreboard.lua'
server_script 'server.lua'

lua54 'yes'

files {
    'html/scoreboard.html',
    'html/style.css',
    'html/reset.css',
    'html/listener.js',
}

fx_version 'adamant'
games { 'gta5' }