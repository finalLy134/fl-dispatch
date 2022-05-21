fx_version 'bodacious'

games {"gta5"}

author "finalLy#1138"
description "QB Advanced Active Officers System"
version "1.0.3"

ui_page "html/index.html"

shared_script "config.lua"
client_script "client.lua"
server_script '@qb-core/import.lua'
server_script "server.lua"

files {
    "html/*.html",
    "html/*.css",
    "html/*.js",
}
