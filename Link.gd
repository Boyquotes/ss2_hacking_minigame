extends Node2D

var grid_x=0
var grid_y=0

func init(x,y):
	$Line1.color = Color.darkgreen
	$Line2.color = Color.darkgreen
	$Line3.color = Color.darkgreen
	grid_x = x
	grid_y = y
	self.position += Vector2(x*50, y*50)

func success():
	$Line1.color = Color.orange
	$Line2.color = Color.orange
	$Line3.color = Color.orange

func ice():
	$Line1.color = Color.orangered
	$Line2.color = Color.orangered
	$Line3.color = Color.orangered

func vertical():
	self.set_rotation_degrees(90)
	self.position+=Vector2(25, 0)
	
func debug():
	$debug.visible = true
	$debug.text = str(grid_x)+','+str(grid_y)
	
func disable():
	$Line1.color = Color.gray
	$Line2.color = Color.gray
	$Line3.color = Color.gray
	self.visible=false
