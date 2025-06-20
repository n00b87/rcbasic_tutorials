Dim bullet_x[20]
Dim bullet_y[20]
Dim speed_x[20]
Dim speed_y[20]

Sub move_bullet(id)
	bullet_x[id] = bullet_x[id] + speed_x[id]
	bullet_y[id] = bullet_y[id] + speed_y[id]
End Sub

bullet_x[0] = 5
bullet_y[0] = 6
speed_x[0] = 3
speed_y[0] = 2

move_bullet(0)

print "bullet position = "; bullet_x[0]; ", "; bullet_y[0]

