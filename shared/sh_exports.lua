function PoliceAlert()
    -- Put your police alert code
end

function AlarmHack()
    local cb = false
        
    exports['Script']:Hack(function(success)
        if success then cb = true end
    end, 1, 10)

    return cb
end

function PowerHack()
    local cb = false
        
    exports['Script']:Hack(function(success)
        if success then cb = true end
    end, 1, 10)

    return cb
end