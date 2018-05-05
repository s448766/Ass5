-----------------------------------------------------------------------------------------
--
-- Md Faiyaz Hossain
--
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--
-- 2018-05-01
--
-----------------------------------------------------------------------------------------



-- Gravity



local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

local playerBullets = {} -- Table that holds the players Bullets

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )
local explosionSound = audio.loadSound( './assets/audio/Explosion.mp3')
audio.setVolume( 0.2 )

local theGround1 = display.newImage( "land.png" )
theGround1.x = 520
theGround1.y = display.contentHeight
theGround1.id = "the ground"
physics.addBody( theGround1, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround2 = display.newImage( "land.png" )
theGround2.x = 1520
theGround2.y = display.contentHeight
theGround2.id = "the ground" -- notice I called this the same thing
physics.addBody( theGround2, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )
local background = display.newImageRect( 'background.png', 2048, 1536 )
background.x = display.contentCenterX
background.y = display.contentCenterY
background.id = "Enemy"



local dinobad = display.newImageRect( 'dino2.png', 430, 519 )
dinobad.x = 1700
dinobad.y = 1000
dinobad.xScale = -1
physics.addBody( dinobad, "static" )
dinobad.gravityScale = 0
dinobad.id = "dinobad"
dinobad.alpha = 1

local theCharacter = display.newImage( "dino1.png", 430, 519  )
theCharacter.x = display.contentCenterX - 200
theCharacter.y = display.contentCenterY
theCharacter.id = "the character"

theCharacter.x = 300
theCharacter.y = 1000
physics.addBody( theCharacter, "static" )
theCharacter.gravityScale = 0
theCharacter.id = "Dino"



theCharacter.isFixedRotation = true -- If you apply this property before the physics.addBody() command for the object, it will merely be treated as a property of the object like any other custom property and, in that case, it will not cause any physical change in terms of locking rotation.


local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5
 
local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

-- if character falls off the end of the world, respawn back to where it came from
local function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if theCharacter.y > display.contentHeight + 500 then
        theCharacter.x = display.contentCenterX - 200
        theCharacter.y = display.contentCenterY
    end
end

local function checkPlayerBulletsOutOfBounds()
	-- check if any bullets have gone off the screen
	local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 , -1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.id == "bad character" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "bad character" ) ) then
            -- Remove both the laser and asteroid
            display.remove( obj1 )
            display.remove( obj2 )
 			
 			-- remove the bullet
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    playerBullets[bulletCounter]:removeSelf()
                    playerBullets[bulletCounter] = nil
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end

            --remove character
            badCharacter:removeSelf()
            badCharacter = nil

            -- Increase score
            print ("you could increase a score here.")

            -- make an explosion sound effect
            local expolsionSound = audio.loadStream( "./assets/sounds/explosion.mp3" )
            local explosionChannel = audio.play( expolsionSound )

        end
    end
end

if dinobad.alpha == 1 then 
	for timesShot = 1, 1, 1 do
		local function dinobadShooting( event )
			-- create bullet2 sprite
			local bullet2 = display.newImageRect( './assets/sprites/bullet2.jpg', 200, 200 )
			bullet2.x = 1675
			bullet2.y = 1000
			bullet2.xScale = -1
			bullet2.alpha = 0
			local function addPhysicsToBullet2( event )
				-- adding physics to bullet2 with delay
				physics.addBody( bullet2,"dynamic" )
				bullet2.gravityScale = 0
			end
			timer.performWithDelay( 700, addPhysicsToBullet2 ) -- delay ensures the bullet doesn't collide itself(dinobad)
			bullet2.id = "bullet2"
			
			-- show bullet2
			transition.fadeIn( bullet2, { time=100 } )
			-- move bullet2
			transition.moveTo( bullet2, { x=300, y=1000, time=2000 } )
			-- fade out bullet2 
			local function fadeBullet2( event )
				transition.fadeOut( bullet2, { time=100 } )
			end
			timer.performWithDelay( 2000, fadeBullet2 )
		end
		-- wait 5 seconds before shooting
		timer.performWithDelay( 5000, dinobadShooting )
	end
end


local function onShootClicked( event )
	local bullet = display.newImageRect( './assets/sprites/bullet.jpg', 200, 800 )
	bullet.x = 775
	bullet.y = 975
	bullet.alpha = 0
	local function addPhysicsToBullet( event )
		-- adding physics to bullet2 with delay
		physics.addBody( bullet,"dynamic" )
		bullet.gravityScale = 0
	end
	timer.performWithDelay( 500, addPhysicsToBullet ) -- delay ensures the bullet doesn't collide with itself(Dino)
	bullet.id = "bullet"

	transition.fadeIn( bullet, { time=100 } )
	-- move bullet
	transition.moveTo( bullet, { x=1700, y=1000, time=2000 } )
	
	-- fade out bullet 
	local function fadeBullet( event )
		transition.fadeOut( bullet, { time=100 } )
	end
	timer.performWithDelay( 2000, fadeBullet )
end

local function ondinobadHit( event )
	-- fade out Dino
	transition.fadeOut( dinobad, { time=100 } )

	local explosion2 = display.newImageRect( './assets/sprites/explosion.png', 500, 500 )
	explosion2.x = 1700
	explosion2.y = 1000
	explosion2.alpha = 0
	explosion2.id = "explosion2"

	-- show explosion
	transition.fadeIn( explosion2, { time=100 } )
	-- play explosion sound
	audio.play(explosionSound)

	local winText = display.newText( 'You Win!', display.contentCenterX, 350, native.systemFont, 200)
	winText:setFillColor( 1, 0, 1)
end

local function ondinoHit( event )
	-- fade out Dino
	transition.fadeOut( Dino, { time=100 } )

	local explosion = display.newImageRect( './assets/sprites/explosion.png', 900, 900 )
	explosion.x = 300
	explosion.y = 1000
	explosion.alpha = 0
	explosion.id = "explosion"

	-- show explosion
	transition.fadeIn( explosion, { time=100 } )
	-- play explosion sound
	audio.play(explosionSound)

	local loseText = display.newText( 'You Lose!', display.contentCenterX, 350, native.systemFont, 200)
	loseText:setFillColor( 1, 0, 0)
end


shootButton:addEventListener( "touch", shootButton )

Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )
Runtime:addEventListener( "collision", onCollision )
dinobad:addEventListener( 'collision', ondinobadHit )
theCharacter:addEventListener( 'collision', ondinoHit )
shootButton:addEventListener( 'tap', onShootClicked )