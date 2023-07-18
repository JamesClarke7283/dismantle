local function parse_itemstring(itemstring)
    local name, count = string.match(itemstring, "^([%w_:]+) ([%d]+)$")
    if not name then
        name = itemstring
        count = 1
    else
        count = tonumber(count)
    end
    return name, count
end

local function items_substitute(items, original_items, output_items)
    local substituted_items = {}
    for i, item in ipairs(items) do
        local substituted_item = item
        for j, original_item in ipairs(original_items) do
            if item == original_item then
                substituted_item = output_items[j]
                break
            end
        end
        table.insert(substituted_items, substituted_item)
    end
    return substituted_items
end

ORIGINAL_ITEMS = {"group:wood", "group:wool"}
OUTPUT_ITEMS = {"mcl_core:wood", "mcl_wool:white"}

local function uncraft(stack)
    if stack and not stack:is_empty() then
        local recipe = minetest.get_craft_recipe(stack:get_name())
        local real_items = {}
        if recipe.items and ItemStack(recipe.output):get_count() <= stack:get_count() then 
            real_items = items_substitute(recipe.items, ORIGINAL_ITEMS, OUTPUT_ITEMS)
            return real_items
        end
    end
    return nil
end

-- Return the uncraft function from this file so it can be used in other files.
return {
    uncraft = uncraft
}
