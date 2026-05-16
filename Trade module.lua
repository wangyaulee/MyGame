local TradeModule = {}

local activeTrades = {} -- [tradeId] = {fromPlayer, toPlayer, fromItems, toItems, status}

-- Create a trade request
function TradeModule.CreateRequest(fromPlayer, toPlayer, fromItems)
    if not fromPlayer or not toPlayer or fromPlayer == toPlayer then
        return nil, "Invalid players"
    end
    
    local tradeId = tostring(os.time()) .. "_" .. fromPlayer.UserId .. "_" .. toPlayer.UserId
    
    activeTrades[tradeId] = {
        FromPlayer = fromPlayer,
        ToPlayer = toPlayer,
        FromItems = fromItems, -- {itemName = count}
        ToItems = {},
        Status = "Pending", -- Pending, Accepted, Declined, Completed
        CreatedAt = os.time()
    }
    
    return tradeId, "Trade request sent!"
end

-- Accept trade with items to give
function TradeModule.AcceptRequest(tradeId, toPlayer, toItems)
    local trade = activeTrades[tradeId]
    if not trade then return false, "Trade not found" end
    if trade.Status ~= "Pending" then return false, "Trade already " .. trade.Status end
    if trade.ToPlayer ~= toPlayer then return false, "Not your trade" end
    
    trade.ToItems = toItems
    trade.Status = "Accepted"
    
    return true, "Trade accepted!"
end

-- Complete the trade (transfer items)
function TradeModule.CompleteTrade(tradeId, fromInventory, toInventory)
    local trade = activeTrades[tradeId]
    if not trade or trade.Status ~= "Accepted" then 
        return false, "Trade not ready" 
    end
    
    -- Remove items from fromPlayer
    for itemName, count in pairs(trade.FromItems) do
        if (fromInventory[itemName] or 0) < count then
            return false, "From player missing: " .. itemName
        end
        fromInventory[itemName] = fromInventory[itemName] - count
        if fromInventory[itemName] <= 0 then
            fromInventory[itemName] = nil
        end
    end
    
    -- Remove items from toPlayer
    for itemName, count in pairs(trade.ToItems) do
        if (toInventory[itemName] or 0) < count then
            -- Rollback
            for rollItem, rollCount in pairs(trade.FromItems) do
                fromInventory[rollItem] = (fromInventory[rollItem] or 0) + rollCount
            end
            return false, "To player missing: " .. itemName
        end
        toInventory[itemName] = toInventory[itemName] - count
        if toInventory[itemName] <= 0 then
            toInventory[itemName] = nil
        end
    end
    
    -- Add items to fromPlayer (from toPlayer's offer)
    for itemName, count in pairs(trade.ToItems) do
        fromInventory[itemName] = (fromInventory[itemName] or 0) + count
    end
    
    -- Add items to toPlayer (from fromPlayer's offer)
    for itemName, count in pairs(trade.FromItems) do
        toInventory[itemName] = (toInventory[itemName] or 0) + count
    end
    
    trade.Status = "Completed"
    
    return true, "Trade completed!"
end

-- Decline trade
function TradeModule.DeclineTrade(tradeId, player)
    local trade = activeTrades[tradeId]
    if not trade then return false end
    if trade.FromPlayer ~= player and trade.ToPlayer ~= player then return false end
    
    trade.Status = "Declined"
    return true
end

-- Get pending trades for a player
function TradeModule.GetPendingTrades(player)
    local pending = {}
    for id, trade in pairs(activeTrades) do
        if trade.ToPlayer == player and trade.Status == "Pending" then
            table.insert(pending, {Id = id, FromPlayer = trade.FromPlayer.Name, FromItems = trade.FromItems})
        end
    end
    return pending
end

return TradeModule
