fx_version 'bodacious'
game "gta5"
lua54 'yes'

author "finalLy#1138"
description "QB Advanced Dispatch System"
repository "https://github.com/finalLy134/fl-dispatch"

version "2.1.0"

ui_page "html/index.html"

client_script "client.lua"
server_script { "version.lua", "server.lua" }
shared_script "config.lua"

files {
    "html/*.html",
    "html/*.css",
    "html/*.js",
    "colors.json"
}
