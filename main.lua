local functions = dofile(modpath .. "/functions.lua")

minetest.register_node("dismantle:dismantling_table", {
    description = "Dismantling Table",
    tiles = {
        "dismantling_table_top.png",
        "dismantling_table_side.png",
        "dismantling_table_side.png",
        "dismantling_table_side.png",
        "dismantling_table_side.png",
        "dismantling_table_side.png"
    },
    groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1 },
    drop = "dismantle:dismantling_table",
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("output", 9)

        meta:set_string("formspec",
            "size[8,9]" ..
            "label[3.5,-0.2;Input]" ..  -- Adjusted position for "Input" label
            "list[context;input;3.5,0.5;1,1;]" ..
            "label[2,1.5;Output]" ..
            "list[context;output;2.5,2;3,3;]" ..
            "label[0,0;" .. minetest.formspec_escape(minetest.colorize("#313131", "Dismantling Table")) .. "]" ..
            "listcolors[#AAAAAA;#888888;#FFFFFF]" ..
            "list[current_player;main;0,5;8,4;]" ..
            "listring[context;input]" ..
            "listring[context;output]" ..
            "listring[current_player;main]"
        )
    end,

    can_dig = function(pos, player)
        return true
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "input" then
            return 1
        end
        return 0
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        if to_list == "input" then
            return count
        end
        return 0
    end,

    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "input" then
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            local input = inv:get_stack("input", 1)
            local output = functions.uncraft(input)
    
            if output then
                inv:remove_item("input", ItemStack(input:get_name().." "..ItemStack(output[1]):get_count()))
                inv:set_list("output", output)
            else
                inv:set_list("output", {})
            end
        end
    end,

    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        if listname == "input" then
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            local input = inv:get_stack("input", 1):get_name()

            -- Only update the output slots if the taken item matches the one in the "input" slot
            if stack:get_name() == input then
                local output = functions:uncraft(stack)

                -- Decrease the stack size of the input item by one
                if stack:get_count() > 1 then
                    stack:take_item(1)
                    inv:set_stack("input", 1, stack)
                else
                    inv:set_stack("input", 1, nil)
                end

                -- Re-fill the output slots if uncrafted items are available,
                -- otherwise, clear the output slots
                if output then
                    inv:set_list("output", output)
                else
                    inv:set_list("output", {})
                end
            end
        end
    end,
})
