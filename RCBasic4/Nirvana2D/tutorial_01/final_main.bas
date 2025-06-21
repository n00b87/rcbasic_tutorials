Include "nirvana.bas"

'A function to check all the stage collision shapes to see if the sprite is touching the ground
Function SpriteOnGround(layer_index, sprite)
	layer_canvas = Nirvana_GetLayerCanvasID(layer_index)
	Canvas(layer_canvas)
	
	Dim center_x, center_y
	Dim pos_x, pos_y
	GetSpritePosition(sprite, pos_x, pos_y)
	
	Dim size_x, size_y
	GetSpriteSize(sprite, size_x, size_y)
	center_x = pos_x + (size_x/2)
	center_y = pos_y + (size_y/2)
	
	num_hits = CastRay2D_All(center_x, center_y, center_x, center_y + (size_y/2) + 1)
	
	spr_id = -1
	
	Dim hit_x
	Dim hit_y
	Dim normal_x
	Dim normal_y
	
	'Loop through all the ray hits
	For i = 0 To num_hits-1
		GetRayHit2D( i, spr_id, hit_x, hit_y, normal_x, normal_y )
		
		If spr_id < 0 Then
			Continue
		End If
		
		'Loop through all the layer shapes
		For shape_index = 0 to Nirvana_GetLayerShapeCount(layer_index)-1
			If spr_id = Nirvana_Stage_Shapes[shape_index].Sprite_ID Then
				Return True
			End If
		Next
	Next
	
	Return False
	
End Function

title$ = "Nirvana2D Template"
w = 640
h = 480
fullscreen = FALSE
vsync = FALSE

'Open a graphics window
OpenWindow( title$, w, h, fullscreen, vsync )

'Load Nirvana Stage
Nirvana_LoadStage("stage1", 0, 0, w, h)

'Get Sprite Canvas
sprite_layer_index = Nirvana_GetLayerIndex("sprite_layer")
sprite_canvas = Nirvana_GetLayerCanvasID(sprite_layer_index)

'Set Sprite Canvas Active
Canvas(sprite_canvas)
SetGravity2D(0, 60)

'Get character sprite 
dk_nv_index = Nirvana_GetLayerSpriteIndex(sprite_layer_index, "dk_obj")
dk_sprite = Nirvana_GetSpriteID(dk_nv_index)

coin1_nv_index = Nirvana_GetLayerSpriteIndex(sprite_layer_index, "coin1")
coin1_sprite = Nirvana_GetSpriteID(coin1_nv_index)

coin2_nv_index = Nirvana_GetLayerSpriteIndex(sprite_layer_index, "coin2")
coin2_sprite = Nirvana_GetSpriteID(coin2_nv_index)

print "dk_sprite = "; dk_sprite

SetSpriteSolid(dk_sprite, true)

SetSpriteSolid(coin1_sprite, true)
SetSpriteSolid(coin2_sprite, true)

'Vector for storing camera position
Dim camera_position As Nirvana_Vector2D

dk_speed = 120

dk_jump_velocity = -400

jump_ready = FALSE


'Get the run, jump, and idle animations
idle_left_animation = -1
run_left_animation = -1
jump_left_animation = -1

idle_right_animation = -1
run_right_animation = -1
jump_right_animation = -1

'The nirvana animation indexes don't count the base animation that is part of every sprite so we need to add 1 to account for that
for i = 0 To Nirvana_GetSpriteAnimationCount(dk_nv_index)-1
	If Nirvana_GetSpriteAnimationName$(dk_nv_index, i) = "RUN_LEFT" Then
		run_left_animation = i+1
	ElseIf Nirvana_GetSpriteAnimationName$(dk_nv_index, i) = "RUN_RIGHT" Then
		run_right_animation = i+1
	ElseIf Nirvana_GetSpriteAnimationName$(dk_nv_index, i) = "IDLE_LEFT" Then
		idle_left_animation = i+1
	ElseIf Nirvana_GetSpriteAnimationName$(dk_nv_index, i) = "IDLE_RIGHT" Then
		idle_right_animation = i+1
	ElseIf Nirvana_GetSpriteAnimationName$(dk_nv_index, i) = "JUMP_LEFT" Then
		jump_left_animation = i+1
	ElseIf Nirvana_GetSpriteAnimationName$(dk_nv_index, i) = "JUMP_RIGHT" Then
		jump_right_animation = i+1
	End If
next


'Variable to track the current animation
current_animation = idle_right_animation
SetSpriteAnimation(dk_sprite, current_animation, -1)


'Exit While Loop when ESCAPE is pressed
While Not Key(K_ESCAPE)
	'Get the Current Camera Position
	camera_position = Nirvana_GetStageOffset()
	
	dk_velocity = 0
	
	'Move camera position Left or Right when arrow keys are pressed
	If Key(K_LEFT) Then
		dk_velocity = -dk_speed
	ElseIf Key(K_RIGHT) Then
		dk_velocity = dk_speed
	End If
	
	Dim vx, vy
	GetSpriteLinearVelocity(dk_sprite, vx, vy)
	
	If dk_velocity <> 0 Then
		SetSpriteLinearVelocity(dk_sprite, dk_velocity, vy)
	Else
		SetSpriteLinearVelocity(dk_sprite, 0, vy)
	End If
	
	If SpriteOnGround(sprite_layer_index, dk_sprite) Then
		jump_ready = TRUE
		
		If dk_velocity < 0 Then
			if current_animation <> run_left_animation Then
				current_animation = run_left_animation
				SetSpriteAnimation(dk_sprite, current_animation, -1)
			End If
		ElseIf dk_velocity > 0 Then
			If current_animation <> run_right_animation Then
				current_animation = run_right_animation
				SetSpriteAnimation(dk_sprite, current_animation, -1)
			End If
		Else
			If current_animation = run_left_animation Or current_animation = jump_left_animation Then
				current_animation = idle_left_animation
				SetSpriteAnimation(dk_sprite, current_animation, -1)
			ElseIf current_animation = run_right_animation Or current_animation = jump_right_animation Then
				current_animation = idle_right_animation
				SetSpriteAnimation(dk_sprite, current_animation, -1)
			End If
		End If
		
	Else
		jump_ready = FALSE
	End If
	
	
	If Key(K_SPACE) And jump_ready Then
		SetSpriteLinearVelocity(dk_sprite, 0, dk_jump_velocity)
		
		If current_animation <> jump_left_animation And current_animation <> jump_right_animation Then
			Select Case current_animation
			Case idle_left_animation, run_left_animation
				current_animation = jump_left_animation
			Case idle_right_animation, run_right_animation
				current_animation = jump_right_animation
			End Select
			
			SetSpriteAnimation(dk_sprite, current_animation, -1)
		End If
	End If
	
	
	'Set camera to new position
	camera_position.X = SpriteX(dk_sprite) - 320
	camera_position.Y = SpriteY(dk_sprite) - 300
	Nirvana_SetStageOffset(camera_position)

	'This update function must be used for Nirvana Projects
	Nirvana_Update()
Wend
