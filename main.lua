--[[
    GD50 2018
    Pong Remake

    pong-12
    "The Resize Update"

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
    the ball past your opponent's edge. First to 10 points wins.

    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on 
    modern systems.
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
Class = require 'class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'Paddle'

-- our Ball class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'Ball'
require 'Com'
require 'Man'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- speed at which we will move our paddle; multiplied by dt in update
PADDLE_SPEED = 200

PADS = {{'w', 's'}, {'o', '1'}}

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    smallFont = love.graphics.newFont('font.ttf', 8)
    love.graphics.setFont(smallFont)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)
    --love.graphics.setTitle('Pong')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- set the title of our application window
    love.window.setTitle('Pong')

    -- "seed" the RNG so that calls to random are always random
    -- use the current time, since that will vary on startup every time

    -- initialize our nice-looking retro text fonts

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- initialize window with virtual resolution

    -- initialize score variables, used for rendering on the screen and keeping
    -- track of the winner
    com = true
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    player1 = Man(Paddle(0, 30, 8, 40, PADS[1]), ball)
    --player1.paddle.setPad(PADS[1])
    tmp = Paddle(VIRTUAL_WIDTH - 8, VIRTUAL_HEIGHT - 40, 8, 40, PADS[2])
    if not com then
        player2 = Man(tmp, ball)
        --player2.paddle.setPad(PADS[2])
    else
        player2 = Com(tmp, ball)
    end

    gameState = 'start'
end

--[[
    Called by LÖVE whenever we resize the screen; here, we just want to pass in the
    width and height to push so our virtual resolution can be resized as needed.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Runs every frame, with "dt" passed in, our delta in seconds 
    since the last frame, which LÖVE2D supplies us.
]]
function love.update(dt)
    player1:move()
    if not com then
        player2:move()
    else
        --com here
        player2:move()
    end

    if gameState == 'play' then
        -- before switching to play, initialize ball's velocity based
        -- on player who last scored
        if ball.x < 0 then
            sounds['score']:play()
            player2.paddle.score = player2.paddle.score + 1
            if player2.paddle.score == 10 then
                gameState = 'winner2'
            else
            gameState = 'serve1'
            end
            ball:reset(1)
        end

        if ball.x > VIRTUAL_WIDTH then
            sounds['score']:play()
            player1.paddle.score = player1.paddle.score + 1
            if player1.paddle.score == 10 then
                gameState = 'winner1'
            else
            gameState = 'serve2'
            end
            ball:reset(2)
        end
        -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position of collision
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.paddle.x + player1.paddle.w

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx + 1.03
            ball.x = player2.paddle.x - payer2.paddle.w

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math,random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        -- detect upper and lower screen boundary collision and reverse if collided
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- -4 to account for the ball's size
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        
        ball:update(dt)
    end

    
    player1.paddle:update(dt)
    --com or not
    if not com then
        player2.paddle:update(dt)
    else
        --com here
        player2:update(dt)
    end
end

--[[
    Keyboard handling, called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    end
    -- if we press enter during either the start or serve phase, it should
    -- transition to the next appropriate state
    if key == 'enter' or key == 'return' then
        if gameState == 'start' or gameState == 'serve1' or gameState == ' serve2' then
            gameState = 'play'
        elseif gameState == 'winner1' or gameState == 'winner2' then
            gameReset()
            gameState = 'play'
        else
            -- game is simply in a restart phase here, but will set the serving
            -- player to the opponent of whomever won for fairness!
            gameState = 'start'

            ball:reset()

        end
    end
end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, 
    updated or otherwise.
]]
function love.draw()

    push:apply('start') then
        love.graphics.cleae(40,50,255,255)
        love.graphics.setFont(smallFont)
        love.graphics.setColor(20,20, 0, alpha)
        if gameState == 'start' then
            love.graphics.printf('Press Enter Key To Start!', 0, 20, VIRTUAL_WIDTH, 'center')
          elseif gameState == 'serve1' then
            love.graphics.printf('Player 1 to Serve', 0, 20, VIRTUAL_WIDTH, 'center')
          elseif gameState == 'serve2' then
            love.graphics.printf('Player 2 to Serve', 0, 20, VIRTUAL_WIDTH, 'center')
        else
            love.graphics.printf('Playing!', 0, 20, VIRTUAL_WIDTH, 'center')
        end
        love.graphics.setColor(250,0, 0, alpha)
        if gameState == 'winner1' then
            love.graphics.printf('Player 1 Won!', 0, 30, VIRTUAL_WIDTH, 'center')
        elseif gameState == 'winner2' then
            love.graphics.printf('Player 2  Won!', 0, 30, VIRTUAL_WIDTH, 'center')
        end
        love.graphics.setColor(0,255, 255, 255)
        love.graphics.printf('Hello Pong', 0, 4, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(scoreFont)
        love.graphics.setColor(255,255, 0, 255)
        love.graphics.printf(tostring(player1.paddle.score), 50, VIRTUAL_HEIGHT / 2 - 15, VIRTUAL_WIDTH / 2, 'center')
        love.graphics.printf(tostring(player2.paddle.score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 - 15, VIRTUAL_WIDTH / 2, 'center')
        player1.paddle:render()
        love.graphics.setColor(255,18, 0, 255)
        player2.paddle:render()
        love.graphics.setColor(22,255, 0, 255)
        ball:render()

        displayFPS()
    push:apply('end')
end

function gameReset()
    winner = 0
    player1.paddle.score = 0
    player2.paddle.score = 0
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

--[[
    Simply draws the score to the screen.
]]
function displayScore()
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end
