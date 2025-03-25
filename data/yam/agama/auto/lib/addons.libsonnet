local template_lib = import '../template.libsonnet';
local sles_ha(code='') = {
    id: 'sles-ha',
    registrationCode: code,
    version: '16.0'
};

local get_addon(addon='') = {
    id: addon
};


/*{
    sles_ha: sles_ha(super.code),
}*/

function(addon='', registration_code='') {
    [if addon == 'sles_ha' then 'addons']: sles_ha(registration_code),
    [if addon == 'we' then 'addons']: sles_ha(registration_code)
}
