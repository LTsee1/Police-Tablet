ui_page  'client/html/index.html'

resource_manifest_version "77731fab-63ca-442c-a67b-abc70f28dfa5"

client_script "client/client.lua"

server_scripts { "server/server.lua", 	'@mysql-async/lib/MySQL.lua', }

files {
    "client/html/index.html",
    "client/html/style.css",
    "client/html/listener.js",
    "client/html/reset.css"
}