local transformations = {
    ["you"] = "thou", 
    ["your"] = "thy", 
    ["yours"] = "thine", 
    ["you're"] = "thou art",
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
    ["wait"] = "bide",
    ["i"] = "I doth",
    ["we"] = "we doth",
    ["should"] = "shouldst",
    ["can"] = "canst",
    ["cannot"] = "canst not",
    ["might"] = "mightst",
    ["would"] = "wouldst",
    ["better"] = "bettr'd",
    ["heart"] = "h'rt",
    ["heaven"] = "heav'n",
    ["time"] = "hour",
    ["wealth"] = "treasure",
    ["year"] = "twelvemonth",
    ["child"] = "lad",
    ["kid"] = "lad",
    ["let"] = "alloweth",
    ["for"] = "f'r",
    ["happy"] = "joyous",
    ["ever"] = "e'er",
    ["always"] = "at each moment",
    ["there"] = "thence",
    ["skibidi"] = "privy-wight",
    ["sigma"] = "sigmatus",
    ["rizzler"] = "heartmaster",
    ["based"] = "truth-stead",
    ["that"] = "yond",
}

function tableLookup( t )
    local lookup = {}
    
    for i,v in pairs(t) do
        lookup[v] = true
    end
    
    return lookup
end

local function transform( sentence )
    sentence = string.lower( sentence )

    for word, replacement in pairs( transformations ) do
        sentence = string.gsub( sentence, "%f[%g]" .. word .. "%f[%G]", replacement )
    end

    local transformedWords = {}
    
    for word in sentence:gmatch( "%S+" ) do
        if not tableLookup(transformations)[word] then
            local punctuationStart = word:find("%p")

            if punctuationStart then
                local letters = word:sub(1, punctuationStart - 1)
                local punctuation = word:sub(punctuationStart)

                table.insert( transformedWords, letters ..( (letters:EndsWith("e") or letters:EndsWith("i") ) and "th" or "eth" ) .. punctuation )
            else
                table.insert( transformedWords, word ..( (word:EndsWith("e") or word:EndsWith("i") ) and "th" or "eth" ) .. punctuation)
            end
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
    -- theire is not a typo!!!
    local message = shouldSet and "#A granteth #T shakespearean manners" or "#A restoreth #T to theire former self"

    ulx.fancyLogAdmin( caller, message, targetPlayers )
end

local shakespeak = ulx.command( "Fun", "ulx shakespeak", setShakespeak, "!shakespeak" )
shakespeak:defaultAccess( ULib.ACCESS_ADMIN )
shakespeak:addParam( { type = ULib.cmds.PlayersArg } )
shakespeak:addParam( { type = ULib.cmds.BoolArg, invisible = true } )
shakespeak:help( "Bestoweth upon the chosen one a boon of grandeur and honor" )
shakespeak:setOpposite( "ulx unshakespeak", { nil, nil, true }, "!unshakespeak" )
