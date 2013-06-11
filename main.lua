function love.load()
    love.graphics.setCaption('KEYBANG')
    love.mouse.setVisible(false)
    love.graphics.toggleFullscreen()

    font = love.graphics.newFont(400)
    love.graphics.setFont(font)

    -- This is what must be typed to exit the program
    secret = "baby is done playing now"
    positionInSecret = 0

    -- Load all sounds in the sounds folder
    unmappedSounds = {}
    for i, file in pairs(love.filesystem.enumerate('sounds')) do
        print(i, file)
        unmappedSounds[i] = love.audio.newSource('sounds/' .. file)
    end
    keySounds = {}
end

function play_sound(source)
    source:setPitch(1 + math.random(-8, 8) / 100)

    if source:isStopped() then
        source:play()
    else
        source:rewind()
    end
end

function play_key_sound(key)
    -- If this key has not already been assigned a sound
    if not keySounds[key] then
        -- If there are any unmapped sounds left
        if #unmappedSounds > 0 then
            -- Assign a random unmapped sound to this key
            keySounds[key] = table.remove(unmappedSounds,
                                          math.random(1, #unmappedSounds))
        else
            return
        end
    end

    -- Play the assigned sound for this key
    play_sound(keySounds[key])
end

function love.keypressed(key, unicode)
    play_key_sound(key)

    -- DEBUG: press Esc to exit
    if key == 'escape' then love.event.quit() end

    if key == secret:sub(positionInSecret + 1, positionInSecret + 1) then
        positionInSecret = positionInSecret + 1
        if positionInSecret == secret:len() then
            love.event.quit()
        end
    else
        positionInSecret = 0
    end

    lastKey = key

    change_background_color()
    change_letter_appearance()
end

function change_background_color()
    local bgColor = {math.random(0, 255),
                     math.random(0, 255),
                     math.random(0, 255)}

    love.graphics.setBackgroundColor(bgColor)
end

function change_letter_appearance()
    letter = {}
    letter.string = lastKey
    letter.width = font:getWidth(letter.string)
    letter.height = font:getHeight()
    letter.position = {
        x = math.random(0, love.graphics.getWidth() - letter.width),
        y = math.random(0, love.graphics.getHeight() - letter.height)}
    --letter.size = math.random(100, 1000)

end

function love.draw()
    if letter then
        love.graphics.setColorMode('modulate')
        love.graphics.setColor(255, 255, 255)
        love.graphics.setBlendMode('additive')
        love.graphics.print(letter.string,
                            letter.position.x,
                            letter.position.y)
    end
end
