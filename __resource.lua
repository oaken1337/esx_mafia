resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.0.1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'prevod/en.lua',
	'config.lua',
	'server/main.lua',
	'sefovi/config.lua',
	'sefovi/server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'prevod/en.lua',
	'config.lua',
	'client/main.lua',
	'sefovi/config.lua',
	'sefovi/client/main.lua'
}

ui_page 'client/html/index.html'

files {
	'client/html/index.html',
	'client/html/css/style.css',
	'client/html/js/script.js'
}