fx_version 'cerulean'
game 'gta5'

description 'md-tacoshop with a slice of qb-drugs cornerselling'
version '1.0.0.'

shared_scripts{
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_scripts{
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/tacotruck.lua'
}

server_scripts{
    'server/tacotruck.lua'
}

lua54 'yes'
