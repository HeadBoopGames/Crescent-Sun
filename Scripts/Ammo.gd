extends Sprite

export var tag = "Ammo"
export var type = ""
export var amount = 20

func _ready():
	randomize()
	var type_of_ammo = ["Bullet", "Energy", "Explosive", "Shell"]
	type = type_of_ammo[randi()%type_of_ammo.size()]
	amount = range(5,25)[randi()%range(5,25).size()]