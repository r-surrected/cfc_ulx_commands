local transformations = {
    ["you"] = "thou", 
    ["your"] = "thy", 
    ["yours"] = "thine", 
    ["my"] = "mine",
    ["are"] = "art", 
    ["is"] = "be", 
    ["have"] = "hath", 
    ["do"] = "dost",
    ["does"] = "doth", 
    ["will"] = "shalt", 
    ["shall"] = "shalt",
    ["the"] = "ye", 
    ["a"] = "an", 
    ["he"] = "he doth", 
    ["she"] = "she doth",
    ["it"] = "it doth", 
    ["they"] = "they doth", 
    ["we"] = "we doth",
    ["me"] = "thee", 
    ["mine"] = "mine own", 
    ["to"] = "unto", 
    ["for"] = "forsooth",
    ["with"] = "withal", 
    ["of"] = "o'", 
    ["good"] = "verily good", 
    ["bad"] = "vile",
    ["no"] = "nay", 
    ["yes"] = "aye", 
    ["hello"] = "hark!", 
    ["bye"] = "fare thee well",
    ["friend"] = "companion", 
    ["love"] = "affection", 
    ["hate"] = "spurn",
    ["fight"] = "duel", 
    ["death"] = "mortal end", 
    ["come"] = "hither",
    ["go"] = "hence", 
    ["stop"] = "halt", 
    ["wait"] = "bide"
}

local function transform( sentence )
    sentence = string.lower( sentence )

    for word, replacement in pairs( transformations ) do
        sentence = string.gsub( sentence, "%f[%g]" .. word .. "%f[%G]", replacement )
    end

    local transformedWords = {}
    for word in sentence:gmatch( "%S+" ) do
        if not transformations[word] and math.random() < 0.2 then
            table.insert( transformedWords, word + ( word:EndsWith("e") or word:EndsWith("i") ) and "th" or "eth" ) -- if its not a word that we have a transformation for, there's a 20% chance we'll add "eth" to the end of it
        else
            table.insert( transformedWords, word )
        end
    end

    return table.concat( transformedWords, " " )
end

local targetedPlayers = {}
hook.Add( "PlayerSay", "CFC_Shakespeak", function( ply, msg )
    if not targetedPlayers[ply] then return end
    return transform( msg )
end )

local function setShakespeak( caller, targetPlayers, unSet )
    local shouldSet = not unSet
    for _, ply in ipairs( targetPlayers ) do
        if shouldSet then
            targetedPlayers[ply] = true
        else
            targetedPlayers[ply] = nil
        end
    end

    local message = shouldSet and "Hark! #T now speaketh in the manner of the great Shakespeare, thanks to #A" or "Fret not! #T speaketh once more as they did, undone by #A!"

    ulx.fancyLogAdmin( caller, message, targetPlayers )
end

local shakespeak = ulx.command( "Fun", "ulx shakespeak", setShakespeak, "!shakespeak" )
shakespeak:defaultAccess( ULib.ACCESS_ADMIN )
shakespeak:addParam( { type = ULib.cmds.PlayersArg } )
shakespeak:addParam( { type = ULib.cmds.BoolArg, invisible = true } )
shakespeak:help( "Bestoweth upon the chosen one a boon of grandeur and honor" )
shakespeak:setOpposite( "ulx unshakespeak", { nil, nil, true }, "!unshakespeak" )
