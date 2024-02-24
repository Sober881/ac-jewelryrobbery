fx_version 'cerulean'
game 'gta5'

client_script {
    'wrapper/cl_wrapper.lua',
    'client/cl_main.lua',
}
server_script{
    'wrapper/sv_wrapper.lua',
    'server/sv_main.lua'
}

shared_scripts {
    'shared/sh_settings.lua',
    'shared/sh_main.lua',
    'shared/sh_peds.lua'
}

lua54 'yes'