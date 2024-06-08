-- This script is used to export an excess of items from an AE2 network to an arbitrary machine.
-- This machine may smelt, compress, store, or otherwise process the items.

-- Header at top of monitor
label = "AE2 Stockkeeper"

-- Define list of items that should be exported. This table is a list of tables, each containing
-- the following:
-- 1. The user-facing name of the item
-- 2. The item's ID in Minecraft
-- 3. The threshold quantity of the item in the AE2 network before it should be exported
-- 4. The direction in which the item should be exported
-- 5. The amount of an item to export at a time when the threshold is exceeded.
-- 6. The name of the ME Bridge peripheral on the computer network that the item should
--    be exported to. Usually something like "meBridge_0", "meBridge_1", etc.
exportItems = {
    -- Crushing
    [1] = {"Sulfur", "thermal:sulfur", 50000, "west", 32, "meBridge_0"},
    [2] = {"Iron Ingot", "minecraft:iron_ingot", 50000, "west", 32, "meBridge_0"},
    [3] = {"Copper Ingot", "minecraft:copper_ingot", 50000, "west", 32, "meBridge_0"},
    [4] = {"Lead Ingot", "thermal:lead_ingot", 50000, "west", 32, "meBridge_0"},
    [5] = {"Tin Ingot", "thermal:tin_ingot", 50000, "west", 32, "meBridge_0"},

    -- Smelting
    [6] = {"Raw Iron", "minecraft:raw_iron", 2500, "down", 32, "meBridge_0"},
    [7] = {"Raw Copper", "minecraft:raw_copper", 2500, "down", 32, "meBridge_0"},
    [8] = {"Raw Lead", "thermal:raw_lead", 2500, "down", 32, "meBridge_0"},
    [9] = {"Raw Tin", "thermal:raw_tin", 2500, "down", 32, "meBridge_0"},
    [10] = {"Raw Silver", "thermal:raw_silver", 2500, "down", 32, "meBridge_0"},
    [11] = {"Raw Gold", "minecraft:raw_gold", 2500, "down", 32, "meBridge_0"},
    [12] = {"Raw Uranium", "mekanism:raw_uranium", 2500, "down", 32, "meBridge_0"},
    [13] = {"Raw Iesnium", "occultism:raw_iesnium", 2500, "down", 32, "meBridge_0"},
    [14] = {"Raw Zinc", "create:raw_zinc", 2500, "down", 32, "meBridge_0"},
    [15] = {"Raw Nickel", "thermal:raw_nickel", 2500, "down", 32, "meBridge_0"},
    
    -- Coal Enriching
    [16] = {"Iron Ingot", "minecraft:iron_ingot", 2500, "east", 32, "meBridge_0"},
    
    -- Redstone Enriching
    [17] = {"Iron Ingot", "minecraft:iron_ingot", 2500, "west", 32, "meBridge_4"},

    -- Diamond Enriching
    [18] = {"Infused Alloy", "mekanism:alloy_infused", 2500, "down", 32, "meBridge_4"},

    -- Obsidian Enriching
    [19] = {"Infused Alloy", "mekanism:alloy_reinforced", 2500, "east", 32, "meBridge_4"},
    -- [20] = {},
    -- [21] = {},
    -- [22] = {},
    -- [23] = {},
    -- [24] = {},
    -- [25] = {},
    -- [26] = {},
    -- [27] = {},
    -- [28] = {},
    -- [29] = {},
    -- [30] = {},
    -- [31] = {},
    -- [32] = {},
    -- [33] = {},
    -- [34] = {},
    -- [35] = {},
    -- [36] = {},
    -- [37] = {},
    -- [38] = {},
    -- [39] = {},
    -- [40] = {},
    -- [41] = {},
    -- [42] = {},
    -- [43] = {},
    -- [44] = {},
    -- [45] = {},
    -- [46] = {},
    -- [47] = {},
    -- [48] = {},
    -- [49] = {},
    -- [50] = {},
    -- [51] = {},
    -- [52] = {},
    -- [53] = {},
    -- [54] = {},
    -- [55] = {},
    -- [56] = {},
    -- [57] = {},
    -- [58] = {},
    -- [59] = {},
    -- [60] = {},
    -- [61] = {},
    -- [62] = {},
    -- [63] = {},
    -- [64] = {},
    -- [65] = {},
    -- [66] = {},
    -- [67] = {},
    -- [68] = {},
    -- [69] = {},
    -- [70] = {},
    -- [71] = {},
    -- [72] = {},
    -- [73] = {},
    -- [74] = {},
    -- [75] = {},
    -- [76] = {},
    -- [77] = {},
    -- [78] = {},
    -- [79] = {},
    -- [80] = {},
    -- [81] = {},
    -- [82] = {},
    -- [83] = {},
    -- [84] = {},
    -- [85] = {},
    -- [86] = {},
    -- [87] = {},
    -- [88] = {},
    -- [89] = {},
    -- [90] = {},
    -- [91] = {},
    -- [92] = {},
    -- [93] = {},
    -- [94] = {},
}

function listItems()
    -- Iterate through the list of items to export and try to get information about
    -- them from the AE2 network.
    row = 3
    for i, item in ipairs(exportItems) do
        -- Get the item's name, ID, and threshold
        userFacingName = item[1]
        name = item[2]
        threshold = item[3]
        exportDirection = item[4]
        exportQuantity = item[5]
        meBridgeName = item[6]

        meBridge = peripheral.find(meBridgeName)

        -- Print the item's name to the monitor
        centerText(userFacingName, row, colors.black, colors.white, "west", false)

        -- Get the item's information from the AE2 network
        meItemInfo = me.getItem({name = name})

        -- If the item is found in the network, fetch how many are available
        if meItemInfo then
            if not meItemInfo.amount then
                size = 0
            else
                size = meItemInfo.amount
            end
            -- If the item's quantity in the network is above the threshold, export it.
            if size > threshold then
                -- Get user-facing symbol to indicate what direction the item is being exported
                if exportDirection == "down" then
                    directionSymbol = "D"
                elseif exportDirection == "up" then
                    directionSymbol = "U"
                elseif exportDirection == "west" then
                    directionSymbol = "L"
                elseif exportDirection == "right" then
                    directionSymbol = "R"
                elseif exportDirection == "front" then
                    directionSymbol = "F"
                elseif exportDirection == "back" then
                    directionSymbol = "B"
                else
                    directionSymbol = "?"
                end

                -- Try to export the item
                item_to_export = {name=name, count=exportQuantity}
                exported, exportError = me.exportItem(item_to_export, exportDirection)
                if not exported then
                    exported = 0
                end

                if exportError then
                    -- Add flag to monitor output indicating we attempted to export the item, but failed
                    print("Error exporting " .. userFacingName .. " out of ME Bridge " .. meBridgeName .. "in direction " .. exportDirection .. ": " .. exportError)
                    centerText("(" .. meBridgeName .. " export " .. directionSymbol .. ") [" .. size .. "/" .. threshold .. "] !F2E!", row, colors.black, colors.red, "right", true)
                else
                    -- Indicate on monitor that the item is being exported.
                    centerText("(" .. meBridgeName .. " export " .. directionSymbol .. ") [" .. size .. "/" .. threshold .. "]", row, colors.black, colors.yellow, "right", true)
                    -- Also print to console that the item has been exported.
                    print("Successfully exported " .. exported .. " of " .. userFacingName .. " out of ME Bridge " .. meBridgeName .. " in direction " .. exportDirection .. ".")
                end
            else
                -- Indicate on monitor the item's current quantity
                centerText("[" .. size .. "/" .. threshold .. "]", row, colors.black, colors.white, "right", true)
            end
        else
            -- Indicate on monitor that the item was not found in the network
            centerText("Not found!", row, colors.black, colors.red, "right", true)
        end
        row = row + 1
    end
end

function prepareMonitor()
    monitor.clear()
    centerText(label, 1, colors.black, colors.white, "head", false)
end

function centerText(text, line, txtback, txtcolor, pos, clear)
    monitorX, monitorY = monitor.getSize()
    monitor.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monitorX - length)
    x = math.floor(dif / 2)

    if pos == "head" then
        monitor.setCursorPos(x + 1, line)
        monitor.write(text)
    elseif pos == "west" then
        if clear then
            clearBox(2, 2 + length, line, line)
        end
        monitor.setCursorPos(2, line)
        monitor.write(text)
    elseif pos == "right" then
        if clear then
            clearBox(monitorX - length - 8, monitorX, line, line)
        end
        monitor.setCursorPos(monitorX - length, line)
        monitor.write(text)
    end
end


function clearBox(xMinimum, xMaximum, yMinimum, yMaximum)
    monitor.setBackgroundColor(colors.black)
    for xPosition = xMinimum, xMaximum, 1 do
        for yPosition = yMinimum, yMaximum, 1 do
            monitor.setCursorPos(xPosition, yPosition)
            monitor.write(" ")
        end
    end
end

print("Starting AE2 stockkeeper.")

-- Connect to nearby monitor for reporting
monitor = peripheral.find("monitor")
-- If we can't find a monitor, print an error the console.
if not monitor then
    print("No monitor found! Please connect a monitor to the computer and try again.")
    return
end

prepareMonitor()

-- Get a list of unique ME bridges
meBridges = {}
for i, item in ipairs(exportItems) do
    meBridgeName = item[6]
    if not meBridges[meBridgeName] then
        meBridges[meBridgeName] = true
    end
end

-- Confirm we have connectivity to all of them
for meBridgeName, _ in pairs(meBridges) do
    if not peripheral.find(meBridgeName) then
        centerText("ME Bridge not found: " .. meBridgeName, 3, colors.black, colors.red, "head", true)
        centerText("Please connect the ME bridge to the computer", 4, colors.black, colors.red, "head", true)
        centerText("and try again.", 5, colors.black, colors.red, "head", true)

        -- Print error message to console as well
        print("ME Bridge not found: " .. meBridgeName .. ". Please connect the ME bridge to the computer and try again.")
        return
    end
end

while true do
    listItems()
    sleep(3)
end

print("Finished AE2 stockkeeper.")
