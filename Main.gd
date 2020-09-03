extends Node2D

var GRID = []
const GRID_W = 9
const GRID_H = 7
const MAX_ICE = 5
const MAX_FAIL = 7
var current_ice = 0
var current_fail = 0

var NODE = load("res://Node.tscn")
var LINK = load("res://Link.tscn")
var last_clicked = [-1,-1]
var rng = RandomNumberGenerator.new()

func _ready():
	init()


func reset():
	clear_grid()
	init()
	
func init():
	current_ice = 0
	current_fail = 0
	GRID = []
	$MaxEmpty.text = "MAX EMPTY: " + str( MAX_FAIL)
	$MaxIce.text = "MAX ICE: "+ str( MAX_ICE)
	rng.randomize()
	for x in range(GRID_W):
		GRID.append([])
		GRID[x]=[]        
		for y in range(GRID_H):
			GRID[x].append([])
			if y % 2 == 0:
				if x % 2 == 0:
					GRID[x][y] = init_node(x,y)
					GRID[x][y].connect("revealed", self, "on_reveal")
				else:
					GRID[x][y] = init_link(x,y)
			else:
				GRID[x][y]=init_link(x,y)
				if x % 2 != 0:
						GRID[x][y].disable()
				else:
					GRID[x][y].vertical()
			add_child(GRID[x][y])
	disable_unnecessary()

func clear_grid():
	for x in range(GRID_W):   
		for y in range(GRID_H):
			GRID[x][y].queue_free()
			
	
func init_node(x,y):
	var type = rng.randi_range(1, 3)
	if type == 1 and current_fail < MAX_FAIL:
		current_fail +=1
	elif type == 3 and current_ice < MAX_ICE:
		current_ice +=1
	else:
		type = 2	
		
	var node = NODE.instance()
	node.init(type,x,y)
	#node.debug()
	return node


func init_link(x,y):
	var link = LINK.instance()
	link.init(x,y)
	#link.debug()
	return link

func connected(x1,y1,x2,y2):
	if x1==x2 and abs(y1-y2)==2.0:
		return Vector2(x1, max(y1,y2) - 1)
	elif y1==y2 and abs(x1-x2)==2.0:
		return Vector2(max(y1,y2) - 1, y1)
	else:
		return null

func safe_get_node(x,y):
	if x >= GRID_W or y >= GRID_H:
		return null
	if x <0 or y<0:
		return null
	if GRID[x][y].opened == false:
		return null
	if GRID[x][y].visible == false:
		return null
	return GRID[x][y]

func link_with_around_nodes(x,y):
	if GRID[x][y].type != 'success':
		return 
		
	var up = safe_get_node(x,y+2)
	if up != null and up.type=='success':
		GRID[x][y+1].success()
		GRID[x][y].connected+=1
		GRID[x][y+2].connected+=1
		GRID[x][y].connected+=GRID[x][y+2].connected
		
	var down = safe_get_node(x,y-2)
	if down != null and down.type=='success':
		GRID[x][y-1].success()
		GRID[x][y].connected+=1
		GRID[x][y-2].connected+=1
		GRID[x][y].connected+=GRID[x][y-2].connected
		
		
	var right = safe_get_node(x+2,y)
	if right != null and right.type=='success':
		GRID[x+1][y].success()
		GRID[x][y].connected+=1
		GRID[x+2][y].connected+=1
		GRID[x][y].connected+=GRID[x+2][y].connected
		
		
	var left = safe_get_node(x-2,y)
	if left != null and left.type=='success':
		GRID[x-1][y].success()
		GRID[x][y].connected+=1
		GRID[x-2][y].connected+=1
		GRID[x][y].connected+=GRID[x-2][y].connected
	
	if GRID[x][y].connected >=3:
		$WinModal.dialog_text='Hacked! Try again?'
		$WinModal.popup_centered()

func on_reveal(type,x,y):
	#var linked = connected(x,y,last_clicked[0],last_clicked[1])
	#if linked:
	#	print(linked)
	#last_clicked[0] = x
	#last_clicked[1] = y
	if type == 'success':
		link_with_around_nodes(x,y)
	elif type == 'ice':
		$WinModal.dialog_text ='Busted...Try again?'
		$WinModal.popup_centered()
	
	
func disable_unnecessary():
	GRID[0][0].disable()
	GRID[0][1].disable()
	GRID[2][1].disable()
	GRID[1][0].disable()
	GRID[2][0].disable()
	GRID[3][0].disable()
	GRID[2][4].disable()
	GRID[2][3].disable()
	GRID[2][5].disable()
	GRID[1][4].disable()
	GRID[3][4].disable()
	GRID[8][6].disable()
	GRID[7][6].disable()
	GRID[8][5].disable()
	GRID[6][6].disable()
	GRID[6][5].disable()
	GRID[5][6].disable()
	GRID[6][2].disable()
	GRID[5][2].disable()
	GRID[7][2].disable()
	GRID[6][1].disable()
	GRID[6][3].disable()
	


func _on_WinModal_confirmed():
	reset()


func _on_Button_button_up():
	reset()
