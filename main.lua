function love.load()
    WW, WH = love.graphics.getDimensions()
    currentDImage = love.graphics.newImage("start.png")
    playing = false
    music = love.audio.newSource("loop.wav", "stream")
    blockLength = 25
    music:setLooping(true)
    music:play()
end

function love.draw()
    if playing then
        for i = 1, #objectImages do
            if objectsVisible[i] then
                love.graphics.draw(objectImages[i], objectXs[i], objectYs[i])
            end
        end
        love.graphics.print(clicksRemaining)
        love.graphics.print("time: "..math.ceil(counter), 0, 25)
    else
        love.graphics.draw(currentDImage)
    end
end

function love.update(dt)
    if playing then
        if counter < 0 then 
            objectsVisible = {false, false, false}
            counter = 0
        end
        if counter > 0 then
            counter = counter - dt
        end
        if (objectsVisible[1] == true) and (objectsVisible[2] == true) and (objectsVisible[3] == true) and counter == 0 then
            -- yes it's inefficient
            startGame()
            timeToWait = timeToWait / 2
            counter = timeToWait
            print("YEP")
        end
    end
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "space" and not playing then timeToWait = 4 startGame() end
end

function startGame()
    counter = timeToWait
    playing = true
    objectImages = {love.graphics.newImage("red.png"), love.graphics.newImage("green.png"), love.graphics.newImage("blue.png")}
    objectsVisible = {true, true, true}
    objectXs = {}
    objectYs = {}
    for i = 1, 3 do
        table.insert(objectXs, love.math.random(WW - 25))
        table.insert(objectYs, love.math.random(WH - 25))
    end
    clicksRemaining = 4
end

function love.mousepressed(mouseX, mouseY, button)
    if playing and counter == 0 then
        clicksRemaining = clicksRemaining - 1
        for i = 1, #objectXs do
            local x = objectXs[i]
            local y = objectYs[i]
            if mouseX > x and mouseX < x + blockLength and mouseY > y and mouseY < y + blockLength then
                objectsVisible[i] = true
            end
        end
        if clicksRemaining == 0 and not (objectsVisible == {true, true, true}) then 
            playing = false
            currentDImage = love.graphics.newImage("start.png")
        end
    end
end

function love.focus(f)
    if f then
        love.window.setTitle("where?")
    else
        love.window.setTitle("ples dont go")
    end
end