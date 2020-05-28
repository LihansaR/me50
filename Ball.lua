--[[
    This is CS50 2019.
    Games Track
    Pong

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.w = width
    self.h = height

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50) == 1 and math.random(-80, -100) or math.random(80, 100)
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles overlap.
]]
function Ball:collides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > paddle.paddle.x + paddle.paddle.width or paddle.paddle.x > self.x + self.w then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.paddle.y + paddle.paddle.h or paddle.paddle.y > self.y + self.h then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the ball in the middle of the screen, with an initial random velocity
    on both axes.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dy = math.random(-50, 50)

    if p == 1 then
        self.dx = 100
    elseif p == 2 then
        self.dx = -100
    else
        self.dx = math.random(2) == 1 and 100 or -100
    end
end

--[[
    Simply applies velocity to position, scaled by deltaTime.
]]
function Ball:update(dt)
    self.x = self.x + (self.dx * 1.5) * dt
    self.y = self.y + (self.dy * 1.5) * dt
end

function Ball:render()
    love.graphics.rectangle('fill', ball.x, ball.y, ball.w, ball.h)
end