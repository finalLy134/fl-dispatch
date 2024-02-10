fx_version 'bodacious'

games { "gta5" }

author "finalLy#1138"
description "QB Advanced Active Officers System"
version "2.0.0"

ui_page "html/index.html"

client_script "client.lua"
server_script "server.lua"
shared_script "config.lua"

files {
    "html/*.html",
    "html/*.css",
    "html/*.js",
    "colors.json"
}
