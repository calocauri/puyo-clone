extends Sprite

export(Texture) var blue_sprite
export(Texture) var pink_sprite
export(Texture) var yellow_sprite
export(Texture) var green_sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_flavor(flavor):
	match flavor:
		Puyo.BLUE:
			texture = blue_sprite
		Puyo.PINK:
			texture = pink_sprite
		Puyo.YELLOW:
			texture = yellow_sprite
		Puyo.GREEN:
			texture = green_sprite
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
