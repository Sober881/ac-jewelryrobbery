## Settings of hack when you open the file **sh_exports.lua** at the bottom you have a AlarmHack() or PowerHack() function there are lines that you should not remove *value cb* and *return cb* take export on your hack and paste it then add success on function() and finally add this *if success then cb = true* like this:

# Example:
```
    function ExampleHack()
        local cb = false
        
        exports['Script']:Hack(function(success)
            if success then cb = true end
        end, 1, 10)

        return cb
    end
```