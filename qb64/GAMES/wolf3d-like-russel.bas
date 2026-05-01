 
' Raycasting engine (fixed and enhanced)
Option _Explicit
'$Dynamic
 
' ---------------------------------------------------------
' Function Declarations Section
' ---------------------------------------------------------
DECLARE SUB InitializeWindow()
DECLARE SUB HandleInput(deltaTime AS _Float)
DECLARE SUB Update(deltaTime AS _Float)
DECLARE SUB RenderWallProjection()
DECLARE SUB RenderSpriteProjection()
DECLARE SUB CastRay(rayAngle AS _Float, stripId AS INTEGER)
DECLARE SUB CastAllRays()
DECLARE SUB RenderMapGrid()
DECLARE SUB RenderMapPlayer()
DECLARE SUB RenderMapSprites()
DECLARE SUB NormalizeAngle(angle AS _Float)
 
' ---------------------------------------------------------
' Global Variables Section
' ---------------------------------------------------------
Dim Shared windowWidth As Integer ' Width of the display window in pixels
Dim Shared windowHeight As Integer ' Height of the display window in pixels
Dim Shared mapWidth As Integer ' Width of the game map in tiles
Dim Shared mapHeight As Integer ' Height of the game map in tiles
Dim Shared tileSize As Integer ' Size of each tile in pixels (square tiles assumed)
Dim Shared fovAngle As _Float ' Field of view angle in radians
Dim Shared distanceProjPlane As _Float ' Distance from player to projection plane
 
' ---------------------------------------------------------
' Player Structure Definition
' ---------------------------------------------------------
Type Player
      x As _Float ' Player's X coordinate in world space (pixels)
      y As _Float ' Player's Y coordinate in world space (pixels)
      angle As _Float ' Player's facing direction in radians (angle of view)
End Type
 
' ---------------------------------------------------------
' Sprite Structure Definition
' ---------------------------------------------------------
Type Sprite
      x As _Float ' Sprite's X coordinate in world space (pixels)
      y As _Float ' Sprite's Y coordinate in world space (pixels)
      texture As Integer ' Texture index identifier for sprite rendering
End Type
 
' ---------------------------------------------------------
' Shared Global Variables
' ---------------------------------------------------------
Dim Shared player As Player ' Main player character information
Dim Shared walls(1) As Integer ' Array storing wall data for the game map (0 = empty, 1 = wall)
Dim Shared rays(1) As _Float ' Array storing calculated ray distances for each screen column
Dim Shared raySide(1) As Integer ' Array storing which side of a tile was hit by each ray
Dim Shared sprites(10) As Sprite ' Array storing sprite data (max 10 sprites supported)
Dim Shared numSprites As Integer ' Counter variable tracking the actual number of sprites
 
' ---------------------------------------------------------
' Game Settings Initialization
' ---------------------------------------------------------
windowWidth = 640 ' Screen width: 640 pixels
windowHeight = 480 ' Screen height: 480 pixels
mapWidth = 20 ' Map width: 20 tiles horizontally
mapHeight = 13 ' Map height: 13 tiles vertically
tileSize = 64 ' Tile size: 64x64 pixel squares
fovAngle = 60 * (_Pi / 180) ' Field of view: 60 degrees converted to radians
 
' ---------------------------------------------------------
' Main Program Initialization and Loop
' ---------------------------------------------------------
 
' Initialize the graphics window and game state variables
InitializeWindow
 
' Game loop control variable - stores time from previous frame for delta time calculations
Dim lastTime As _Float
lastTime = Timer
 
' Main program execution loop
Do While InKey$ <> Chr$(27)
      ' Timing variables to calculate deltaTime for smooth animation
      Dim currentTime As _Float, deltaTime As _Float
 
      ' Calculate current time and delta time (time elapsed since last frame)
      currentTime = Timer
      deltaTime = currentTime - lastTime
      If deltaTime <= 0 Then deltaTime = 0.001 ' Prevent division by zero or negative values
 
      lastTime = currentTime
 
      ' Update game logic for this frame using delta time for smooth animation
      Update deltaTime
 
      ' Render all visual elements to the screen buffer
      RenderWallProjection ' Draw wall projections (3D walls based on raycasting)
      RenderSpriteProjection ' Draw sprites in 3D space with proper sorting
 
      RenderMapGrid ' Display minimap grid showing map layout
      RenderMapPlayer ' Show player position on minimap
      RenderMapSprites ' Display sprite positions on minimap
 
      _Display ' Swap buffers to display the rendered frame
      Cls ' Clear drawing surface for next frame rendering
 
      _Limit 60 ' Limit execution rate to ~60 FPS for smooth gameplay
Loop
 
' ---------------------------------------------------------
' InitializeWindow Subroutine - Sets up initial game state
' ---------------------------------------------------------
Sub InitializeWindow ()
      ' Create a new graphics screen buffer with specified dimensions and color depth
      Screen _NewImage(windowWidth, windowHeight, 32)
 
      ' Set player starting position in the center of tile (3.5, 3.5) scaled by tileSize
      player.x = 3.5 * tileSize
      player.y = 3.5 * tileSize
 
      ' Set initial player facing direction to 90 degrees (facing right horizontally)
      player.angle = 90 * (_Pi / 180)
 
      ' Calculate the distance from player's eye point to projection plane
      distanceProjPlane = (windowWidth / 2) / Tan(fovAngle / 2)
 
      ' Dynamically allocate arrays to exact required sizes to save memory
 
      ' Wall data array - size based on total tiles in map multiplied by tile dimensions
      ReDim walls(mapWidth * mapHeight - 1)
 
      ' Distance ray array - one entry per screen column for optimized rendering
      ReDim rays(windowWidth - 1)
 
      ' Ray side hit array - stores which wall side was hit for shading effects
      ReDim raySide(windowWidth - 1) ' FIXED - allocate raySide array!
 
      ' Initialize the map layout with borders and interior walls
 
      Dim i As Integer, j As Integer
 
      ' Loop through all tiles to build the base map structure
      For i = 0 To mapHeight - 1
              For j = 0 To mapWidth - 1
 
                    ' Create outer walls around the entire map area
                    If i = 0 Or i = mapHeight - 1 Or j = 0 Or j = mapWidth - 1 Then
                            walls(i * mapWidth + j) = 1 ' Wall tile designation
 
                    Else
                            walls(i * mapWidth + j) = 0 ' Empty space interior tiles
                    End If
 
              Next j
      Next i
 
      ' Add specific internal wall structures for gameplay obstacles
 
      ' Horizontal walls across the map (lines of blocks)
      For i = 2 To 6
              walls(5 * mapWidth + i) = 1 ' Row 5, columns 2-6 filled with walls
      Next i
 
      ' Add a few scattered individual wall tiles
      walls(8 * mapWidth + 10) = 1 ' Single wall at position (8,10)
      walls(9 * mapWidth + 10) = 1 ' Single wall at position (9,10)
      walls(9 * mapWidth + 11) = 1 ' Single wall at position (9,11)
 
      ' Initialize sprite objects with positions and textures
 
      numSprites = 3 ' Three sprites defined in this setup
 
      ' Sprite 0 - positioned near center of the map
      sprites(0).x = 6.5 * tileSize ' X coordinate scaled by tile size
      sprites(0).y = 6.5 * tileSize ' Y coordinate scaled by tile size
      sprites(0).texture = 1 ' Texture index for sprite rendering
 
      ' Sprite 1 - positioned lower in map area
      sprites(1).x = 8.5 * tileSize ' X coordinate
      sprites(1).y = 8.5 * tileSize ' Y coordinate
      sprites(1).texture = 2 ' Different texture for sprite rendering
 
      ' Sprite 2 - positioned upper right corner area
      sprites(2).x = 12.5 * tileSize ' X coordinate
      sprites(2).y = 3.5 * tileSize ' Y coordinate
      sprites(2).texture = 3 ' Another texture for sprite rendering
 
End Sub
 
' ---------------------------------------------------------
' CastRay Subroutine - Raycasting algorithm implementation
' ---------------------------------------------------------
Sub CastRay (rayAngle As _Float, stripId As Integer)
 
      ' Normalize angle to keep within valid range of [0, 2p radians]
      NormalizeAngle rayAngle
 
      ' Ray direction calculation from the given ray angle
      Dim rayDirX As _Float, rayDirY As _Float
      rayDirX = Cos(rayAngle) ' X component of ray direction vector
      rayDirY = Sin(rayAngle) ' Y component of ray direction vector
 
      ' Starting position and map coordinates for ray traversal
 
      Dim mapX As Integer, mapY As Integer ' Grid coordinates within the map array
      Dim posX As _Float, posY As _Float ' World coordinates in pixel space
 
      posX = player.x ' Player's current X coordinate
      posY = player.y ' Player's current Y coordinate
      mapX = Int(posX / tileSize) ' Convert pixel position to tile grid X
      mapY = Int(posY / tileSize) ' Convert pixel position to tile grid Y
 
      ' Distance calculations for DDA (Digital Differential Analysis) raycasting
 
      Dim deltaDistX As _Float, deltaDistY As _Float ' Distances between intersections with grid lines
 
      ' Handle division by zero cases when ray is vertical or horizontal
      If Abs(rayDirX) < 1E-9 Then
              deltaDistX = 1E30 ' Large number representing infinite distance
      Else
              deltaDistX = Abs(tileSize / rayDirX)
      End If
 
      If Abs(rayDirY) < 1E-9 Then
              deltaDistY = 1E30 ' Large number representing infinite distance
      Else
              deltaDistY = Abs(tileSize / rayDirY)
      End If
 
      Dim stepX As Integer, stepY As Integer ' Direction to step in x/y direction (-1 or +1)
      Dim sideDistX As _Float, sideDistY As _Float ' Current distances to next grid line
 
      ' Determine stepping direction and initial side distance based on ray direction
 
      If rayDirX < 0 Then
              stepX = -1 ' Step backward in X direction
              sideDistX = (posX - mapX * tileSize) / Abs(rayDirX)
      Else
              stepX = 1 ' Step forward in X direction
              sideDistX = ((mapX + 1) * tileSize - posX) / Abs(rayDirX)
      End If
 
      If rayDirY < 0 Then
              stepY = -1 ' Step backward in Y direction
              sideDistY = (posY - mapY * tileSize) / Abs(rayDirY)
      Else
              stepY = 1 ' Step forward in Y direction
              sideDistY = ((mapY + 1) * tileSize - posY) / Abs(rayDirY)
      End If
 
      Dim hit As Integer ' Boolean flag indicating if wall was hit
      hit = 0 ' Start with no collision
 
      Dim side As Integer ' Side indicator (0 horizontal, 1 vertical hit)
      Dim maxDepth As Integer ' Depth limiting to prevent infinite loops
 
      maxDepth = 2000 ' Maximum traversal depth before giving up
 
      Do While hit = 0 And maxDepth > 0
              ' Determine which grid line distance was smaller and step accordingly
 
              If sideDistX < sideDistY Then
                    sideDistX = sideDistX + deltaDistX ' Move distance to next X grid intersection
                    mapX = mapX + stepX ' Step to the next tile in X direction
                    side = 0 ' Mark as horizontal wall hit
 
              Else
                    sideDistY = sideDistY + deltaDistY ' Move distance to next Y grid intersection
                    mapY = mapY + stepY ' Step to the next tile in Y direction
                    side = 1 ' Mark as vertical wall hit
 
              End If
 
              ' Check if ray went out of bounds
              If mapX < 0 Or mapX >= mapWidth Or mapY < 0 Or mapY >= mapHeight Then
                    hit = 1 ' Hit boundary (outside the world)
                    Exit Do
              End If
 
              ' Check for collision with wall tile in current position
              If walls(mapY * mapWidth + mapX) <> 0 Then
                    hit = 1 ' Wall tile detected - ray has hit
                    Exit Do
              End If
 
              maxDepth = maxDepth - 1 ' Decrement depth counter to prevent infinite loop
 
      Loop
 
      ' Calculate perpendicular wall distance accounting for viewing angle distortion
 
      Dim perpWallDist As _Float
 
      If hit = 0 Then
              perpWallDist = 1.0E6 ' No walls found, set large distance
 
      Else
              ' Proper calculation of perpendicular distance to avoid fish-eye effect
              ' This compensates for the angle at which we view walls
 
              If side = 0 Then ' Hit horizontal grid line (X step)
                    ' Distance traveled along ray direction projected onto wall normal
                    perpWallDist = (mapX * tileSize - posX + (1 - stepX) * tileSize / 2.0) / rayDirX
 
              Else ' Hit vertical grid line (Y step)
                    ' Same calculation but for Y direction
                    perpWallDist = (mapY * tileSize - posY + (1 - stepY) * tileSize / 2.0) / rayDirY
 
              End If
 
              perpWallDist = Abs(perpWallDist) ' Ensure positive distance value
      End If
 
      ' Store calculated wall distance and hit side information for rendering
 
      If stripId >= 0 And stripId <= UBound(rays) Then
              rays(stripId) = perpWallDist ' Distance stored by screen column index
              raySide(stripId) = side ' Side hit information also stored
      End If
 
End Sub
 
' ---------------------------------------------------------
' CastAllRays Subroutine - Casts rays for all screen columns
' ---------------------------------------------------------
Sub CastAllRays ()
 
      Dim i As Integer ' Screen/column iterator
 
      Dim rayAngle As _Float ' Calculated angle of each ray
 
      ' Loop through each pixel column on the screen (from left to right)
      For i = 0 To windowWidth - 1
 
              ' Camera space coordinate mapping (-1.0 to +1.0 normalized range)
              Dim cameraX As _Float
              cameraX = 2.0# * i / windowWidth - 1.0#
 
              ' Compute actual ray direction based on FOV and current screen position
              ' This accounts for perspective correction using field of view mapping
 
              rayAngle = player.angle + Atn(cameraX * Tan(fovAngle / 2))
 
              ' Cast a single ray from the player's location in calculated direction
              Call CastRay(rayAngle, i)
 
      Next i
 
End Sub
 
' ---------------------------------------------------------
' RenderWallProjection Subroutine - Renders 3D walls to screen
' ---------------------------------------------------------
Sub RenderWallProjection ()
 
      Dim i As Integer ' Screen column iterator
 
      Dim wallHeight As Integer ' Calculated height of projected wall strip
      Dim wallTopY As Integer ' Top pixel Y coordinate for drawing wall
      Dim wallBottomY As Integer ' Bottom pixel Y coordinate for drawing wall
 
      ' Loop through each screen column to render corresponding wall segment
 
      For i = 0 To windowWidth - 1
 
              If rays(i) > 0 Then ' Only process valid ray distances (non-zero)
 
                    ' Project wall height using perspective projection formula
                    ' This creates the illusion of distance from player
 
                    wallHeight = Int((tileSize / rays(i)) * distanceProjPlane)
 
                    ' Minimum wall height to ensure visibility
 
                    If wallHeight < 1 Then wallHeight = 1
 
                    ' Calculate vertical pixel boundaries for wall strip drawing
 
                    wallTopY = Int(windowHeight / 2 - wallHeight / 2) ' Upper boundary pixel
                    If wallTopY < 0 Then wallTopY = 0
 
                    wallBottomY = Int(windowHeight / 2 + wallHeight / 2) ' Lower boundary pixel
                    If wallBottomY > windowHeight Then wallBottomY = windowHeight
 
                    ' Draw ceiling section (top part of screen above wall)
 
                    Line (i, 0)-(i, wallTopY), _RGB(50, 50, 150), BF
 
                    ' Calculate shading based on distance for realistic depth perception
 
                    Dim shade As Integer
                    shade = Int(255 - Min(220, rays(i) * 0.2)) ' Decrease brightness with distance
 
                    If shade < 30 Then shade = 30 ' Minimum shading threshold
 
                    ' Apply additional darkness for wall sides to create depth perception
 
                    If raySide(i) = 1 Then shade = shade * 0.7 ' Vertical side darker than horizontal
 
                    ' Draw the main wall segment using calculated shading
 
                    Line (i, wallTopY)-(i, wallBottomY), _RGB(shade, shade, shade), BF
 
                    ' Draw floor section (bottom part of screen below wall)
 
                    Line (i, wallBottomY)-(i, windowHeight), _RGB(80, 80, 80), BF
 
              End If
 
      Next i
 
End Sub
 
' ---------------------------------------------------------
' RenderSpriteProjection Subroutine - Renders sprites in world space
' ---------------------------------------------------------
Sub RenderSpriteProjection ()
 
      ' Sprite sorting structure to order sprites by distance from player
      Type SpriteOrder
              distance As _Float ' Squared distance to sprite for comparison
              index As Integer ' Index into sprites array for sorting
      End Type
 
      Dim spriteOrder(10) As SpriteOrder ' Array storing sprite distances and indices
 
      Dim i As Integer, j As Integer ' Loop counters
 
      ' Calculate sprite distances from player and create ordering structure
 
      For i = 0 To numSprites - 1
 
              ' Store squared distance (avoiding sqrt computation for efficiency)
              spriteOrder(i).distance = ((player.x - sprites(i).x) ^ 2 + (player.y - sprites(i).y) ^ 2)
 
              spriteOrder(i).index = i ' Index into original sprites array
 
      Next i
 
      ' Simple bubble sort algorithm to order sprites from farthest to nearest
 
      For i = 0 To numSprites - 2
              For j = 0 To numSprites - 2 - i
 
                    ' Swap elements if current sprite is closer (higher distance value)
                    If spriteOrder(j).distance < spriteOrder(j + 1).distance Then
 
                            Dim tempDist As _Float ' Temporary storage for swapping distances
                            Dim tempIndex As Integer ' Temporary storage for swapping indices
 
                            tempDist = spriteOrder(j).distance
                            tempIndex = spriteOrder(j).index
 
                            spriteOrder(j).distance = spriteOrder(j + 1).distance
                            spriteOrder(j).index = spriteOrder(j + 1).index
 
                            spriteOrder(j + 1).distance = tempDist
                            spriteOrder(j + 1).index = tempIndex
 
                    End If
 
              Next j
      Next i
 
      ' Render sprites in reverse order (nearest to farthest) for proper z-buffering
 
      For i = 0 To numSprites - 1
 
              Dim spriteIndex As Integer ' Index of sprite being processed
 
              spriteIndex = spriteOrder(i).index ' Get actual sprite index from sorted list
 
              ' Transform sprite coordinates relative to player position
 
              Dim spriteX As _Float, spriteY As _Float ' Sprite offset from player
 
              spriteX = sprites(spriteIndex).x - player.x ' X difference between sprite and player
              spriteY = sprites(spriteIndex).y - player.y ' Y difference between sprite and player
 
              ' Camera plane vectors (perpendicular to player direction vector)
 
              Dim planeX As _Float, planeY As _Float
 
              planeX = -Sin(player.angle) ' X component of camera plane normal vector
              planeY = Cos(player.angle) ' Y component of camera plane normal vector
 
              ' Player direction vectors (forward direction of player view)
 
              Dim dirX As _Float, dirY As _Float
 
              dirX = Cos(player.angle) ' Forward X movement
              dirY = Sin(player.angle) ' Forward Y movement
 
              ' Calculate inverse determinant for affine transformation matrix inversion
 
              Dim invDet As _Float ' Inverse of determinant
 
              invDet = 1.0 / (planeX * dirY - dirX * planeY)
 
              ' Apply camera transformation to sprite coordinates
 
              Dim transformX As _Float, transformY As _Float ' Transformed sprite coordinates in view space
 
              transformX = invDet * (dirY * spriteX - dirX * spriteY) ' Camera X coordinate
              transformY = invDet * (-planeY * spriteX + planeX * spriteY) ' Camera Y coordinate
 
              If transformY > 0 Then ' Only render sprites that are in front of player
 
                    ' Convert normalized camera coordinates to screen pixels
 
                    Dim spriteScreenX As Integer ' Sprite X position on screen
 
                    spriteScreenX = Int((windowWidth / 2) * (1 + transformX / transformY))
 
                    ' Calculate sprite height and width based on distance from player
 
                    Dim spriteHeight As Integer, spriteWidth As Integer
 
                    spriteHeight = Int(Abs(windowHeight / transformY)) ' Height scales with inverse distance
                    spriteWidth = spriteHeight ' Assuming square sprites for simplicity
 
                    ' Determine drawing boundaries of sprite on screen
 
                    Dim drawStartY As Integer, drawEndY As Integer ' Vertical pixel range
                    drawStartY = Int(-spriteHeight / 2 + windowHeight / 2)
                    drawEndY = Int(spriteHeight / 2 + windowHeight / 2)
 
                    Dim drawStartX As Integer, drawEndX As Integer ' Horizontal pixel range
                    drawStartX = Int(-spriteWidth / 2 + spriteScreenX)
                    drawEndX = Int(spriteWidth / 2 + spriteScreenX)
 
                    ' Clamp drawing bounds to screen area
 
                    If drawStartX < 0 Then drawStartX = 0
                    If drawEndX > windowWidth Then drawEndX = windowWidth
                    If drawStartY < 0 Then drawStartY = 0
                    If drawEndY > windowHeight Then drawEndY = windowHeight
 
                    ' Draw sprite columns in pixel strips
 
                    Dim stripe As Integer
 
                    For stripe = drawStartX To drawEndX - 1
 
                            ' Render only if sprite is visible and closer than wall at this screen column
 
                            If transformY > 0 And stripe > 0 And stripe < windowWidth And transformY < rays(stripe) Then
 
                                  ' Simple colored rectangle rendering (would be textured in enhanced version)
 
                                  Dim spriteColor As Long
 
                                  Select Case sprites(spriteIndex).texture
 
                                          Case 1: spriteColor = _RGB(255, 0, 0) ' Red sprite texture
                                          Case 2: spriteColor = _RGB(0, 255, 0) ' Green sprite texture
                                          Case 3: spriteColor = _RGB(0, 0, 255) ' Blue sprite texture
                                          Case Else: spriteColor = _RGB(255, 255, 0) ' Yellow fallback
 
                                  End Select
 
                                  ' Draw single pixel column for this sprite strip
 
                                  Line (stripe, drawStartY)-(stripe, drawEndY), spriteColor, BF
 
                            End If
 
                    Next stripe
 
              End If
 
      Next i
 
End Sub
 
' ---------------------------------------------------------
' HandleInput Subroutine - Processes keyboard input for player movement
' ---------------------------------------------------------
Sub HandleInput (deltaTime As _Float)
 
      ' Movement forward/backward with collision detection
 
      If _KeyDown(Asc("w")) Or _KeyDown(Asc("W")) Or _KeyDown(18432) Then ' W or Up Arrow
 
              Dim newX As _Float, newY As _Float ' New potential player coordinates
 
              ' Calculate new position based on facing angle and movement speed
              newX = player.x + Cos(player.angle) * 180 * deltaTime
              newY = player.y + Sin(player.angle) * 180 * deltaTime
 
              ' Collision detection for proposed move
 
        If Int(newX / tileSize) >= 0 And Int(newX / tileSize) < mapWidth _
          And Int(newY / tileSize) >= 0 And Int(newY / tileSize) < mapHeight Then
 
                    ' Check if intended tile is empty (not a wall)
                    If walls(Int(newY / tileSize) * mapWidth + Int(newX / tileSize)) = 0 Then
 
                            player.x = newX ' Accept the movement
                            player.y = newY
 
                    End If
 
              End If
 
      End If
 
      ' Movement backward with collision detection
 
      If _KeyDown(Asc("s")) Or _KeyDown(Asc("S")) Or _KeyDown(20480) Then ' S or Down Arrow
 
              Rem Dim newX As _Float, newY As _Float          ' New potential player coordinates
 
              ' Calculate new backwards position based on facing angle and movement speed
              newX = player.x - Cos(player.angle) * 180 * deltaTime
              newY = player.y - Sin(player.angle) * 180 * deltaTime
 
              ' Collision detection for proposed backward move
 
        If Int(newX / tileSize) >= 0 And Int(newX / tileSize) < mapWidth _
          And Int(newY / tileSize) >= 0 And Int(newY / tileSize) < mapHeight Then
 
                    ' Check if intended tile is empty (not a wall)
                    If walls(Int(newY / tileSize) * mapWidth + Int(newX / tileSize)) = 0 Then
 
                            player.x = newX ' Accept the backward movement
                            player.y = newY
 
                    End If
 
              End If
 
      End If
 
      ' Turning left with rotation speed adjustment
 
      If _KeyDown(Asc("a")) Or _KeyDown(Asc("A")) Or _KeyDown(19200) Then ' A or Left Arrow
 
              player.angle = player.angle - 2.0 * deltaTime ' Subtract angle for left turn
 
      End If
 
      ' Turning right with rotation speed adjustment
 
      If _KeyDown(Asc("d")) Or _KeyDown(Asc("D")) Or _KeyDown(19712) Then ' D or Right Arrow
 
              player.angle = player.angle + 2.0 * deltaTime ' Add angle for right turn
 
      End If
 
      ' Normalize the final angle to keep it within valid range (0 - 2p radians)
 
      NormalizeAngle player.angle
 
End Sub
 
' ---------------------------------------------------------
' Update Subroutine - Main game logic update function
' ---------------------------------------------------------
Sub Update (deltaTime As _Float)
 
      ' Cast rays for all screen columns and calculate wall distances
      CastAllRays
 
      ' Process keyboard input to control player movement/rotation
      HandleInput deltaTime
 
End Sub
 
' ---------------------------------------------------------
' RenderMapGrid Subroutine - Renders minimap overview grid of the map
' ---------------------------------------------------------
Sub RenderMapGrid ()
 
      Dim i As Integer, j As Integer ' Loop variables for tile iteration
 
      Dim sx As Integer, sy As Integer ' Screen pixel coordinates for drawing
 
      Dim scale As _Float ' Zoom factor for minimap view
 
      scale = 0.2 ' Scale down original tiles to fit minimap area
 
      ' Render each tile of the map grid at scaled resolution
 
      For i = 0 To mapHeight - 1
 
              For j = 0 To mapWidth - 1
 
                    ' Calculate screen pixel location for this tile
                    sx = Int(j * tileSize * scale)
                    sy = Int(i * tileSize * scale)
 
                    ' Draw tile based on whether it contains wall or empty space
 
                    If walls(i * mapWidth + j) <> 0 Then
 
                Line (sx, sy)-(sx + Int(tileSize * scale), sy + Int(tileSize * scale)), _
                      _RGB(255, 255, 255), BF    ' White wall tile
 
                    Else
 
                Line (sx, sy)-(sx + Int(tileSize * scale), sy + Int(tileSize * scale)), _
                      _RGB(0, 0, 0), BF          ' Black empty space tile
 
                    End If
 
              Next j
 
      Next i
 
End Sub
 
' ---------------------------------------------------------
' RenderMapPlayer Subroutine - Shows player position on minimap
' ---------------------------------------------------------
Sub RenderMapPlayer ()
 
      Dim scale As _Float ' Zoom factor for minimap view
 
      scale = 0.2 ' Same scaling used in map grid rendering
 
      Dim playerScreenX As Integer, playerScreenY As Integer ' Player pixel coordinates
 
      playerScreenX = Int(player.x * scale) ' Scale world coordinates to screen pixels
      playerScreenY = Int(player.y * scale)
 
      ' Draw a crosshair marker at player position
 
    Line (playerScreenX - 3, playerScreenY - 3)-(playerScreenX + 3, playerScreenY + 3), _
          _RGB(255, 255, 0), BF                  ' Yellow square marker
 
      ' Draw directional indicator line showing facing direction
 
    Line (playerScreenX, playerScreenY)- _
        (playerScreenX + Int(Cos(player.angle) * 10), playerScreenY + Int(Sin(player.angle) * 10)), _
          _RGB(255, 0, 0)                        ' Red directional arrow line
 
End Sub
 
' ---------------------------------------------------------
' RenderMapSprites Subroutine - Shows sprite positions on minimap
' ---------------------------------------------------------
Sub RenderMapSprites ()
 
      Dim scale As _Float ' Zoom factor for minimap view
 
      scale = 0.2 ' Same scaling used in other map rendering functions
 
      Dim i As Integer ' Sprite counter
 
      For i = 0 To numSprites - 1 ' Loop through all defined sprites
 
              Dim spriteScreenX As Integer, spriteScreenY As Integer ' Sprite pixel coordinates
 
              spriteScreenX = Int(sprites(i).x * scale) ' Scale sprite world coordinates
              spriteScreenY = Int(sprites(i).y * scale)
 
              ' Draw sprite markers based on their texture type using different colors
 
              Select Case sprites(i).texture
 
            Case 1: Line (spriteScreenX - 2, spriteScreenY - 2)-(spriteScreenX + 2, spriteScreenY + 2), _
                  _RGB(255, 000, 100), BF        ' Red square for texture type 1
 
            Case 2: Line (spriteScreenX - 2, spriteScreenY - 2)-(spriteScreenX + 2, spriteScreenY + 2), _
                  _RGB(100, 255, 100), BF        ' Green square for texture type 2
 
            Case 3: Line (spriteScreenX - 2, spriteScreenY - 2)-(spriteScreenX + 2, spriteScreenY + 2), _
                  _RGB(100, 100, 255), BF        ' Blue square for texture type 3
 
            Case Else: Line (spriteScreenX - 2, spriteScreenY - 2)-(spriteScreenX + 2, spriteScreenY + 2), _
                  _RGB(255, 255, 100), BF        ' Yellow fallback color
 
              End Select
 
      Next i
 
End Sub
 
' ---------------------------------------------------------
' Helper Functions Section
' ---------------------------------------------------------
 
' Function to return the smaller of two floating-point values
Function Min (a As _Float, b As _Float)
 
      If a < b Then
              Min = a ' Return first parameter if it's smaller
 
      Else
              Min = b ' Otherwise return second parameter
 
      End If
 
End Function
 
' Normalize angle to keep within the valid range of [0, 2p radians]
Sub NormalizeAngle (angle As _Float)
 
      ' Keep angle positive by repeatedly adding full rotations until >= zero
 
      Do While angle < 0
              angle = angle + 2 * _Pi
 
      Loop
 
      ' Keep angle bounded by subtracting full rotations until < 2p
 
      Do While angle >= 2 * _Pi
              angle = angle - 2 * _Pi
 
      Loop
 
End Sub