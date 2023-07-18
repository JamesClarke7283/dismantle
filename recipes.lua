if minetest.get_modpath("default") then
    minetest.register_craft({
        output = "uncraft:table",
        recipe = {
            {"group:wood", "default:mese", "group:wood"},
            {"group:wood", "default:mese", "group:wood"},
            {"group:wood", "group:wood", "group:wood"},
        },
    })
end

if minetest.get_modpath("mcl_core") then
    minetest.register_craft({
        output = "uncraft:table",
        recipe = {
            {"mcl_core:wood", "mesecons:redstone", "mcl_core:wood"},
            {"mcl_core:wood", "mesecons:redstone", "mcl_core:wood"},
            {"mcl_core:wood", "mcl_core:wood", "mcl_core:wood"},
        },
    })
end