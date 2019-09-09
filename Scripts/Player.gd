extends KinematicBody2D

var timer
var character
var anim_walk
var anim_attack
var been_hit

export var shake_amount = 1.0

var Mat
var hitfx_x_value = 0.0
var hitfx_y_value = 0.0

var attack_timer = null
export var attack_delay = 0.5
var can_shoot

export var SPEED = 150
var movedir = Vector2(0,0)
var RotationPoint
var characterFacing = "Right"
var weaponPosition = "Front"

export var health = 5

var canPickUp
var itemToPickUp

var in_room

var ammo_bullets
var ammo_shells
var ammo_energy
var ammo_explosion

var interact_with


func _ready():
	if get_node("/root/").has_node("Main"):
		$Camera2D.current = true
	
	if get_node("/root/").has_node("RoomScene"):
		$Camera2D.current = false
	
	timer = Timer.new()
	timer.connect("timeout", self, "animateCharacter")
	add_child(timer)
	timer.wait_time = 0.1
	timer.start()
	
	attack_timer = Timer.new()
	attack_timer.set_one_shot(true)
	attack_timer.wait_time = attack_delay
	attack_timer.connect("timeout", self, "on_attacktimeout_complete")
	add_child(attack_timer)
	
	character = get_node("Character")
	RotationPoint = get_node("RotationPoint")
	canPickUp = false
	
	in_room = true
	
	been_hit = false
	
#	ammo_bullets = 20
#	ammo_energy = 20
#	ammo_explosion = 20
#	ammo_shells = 20
#	updateAmmo()
	
	Mat = $Character.get_material()
	

#func updateAmmo():
#	pass
#	$Camera2D/CanvasLayer/LBL_Bullet/LBL_Amount.text = str(ammo_bullets)
#	$Camera2D/CanvasLayer/LBL_Energy/LBL_Amount.text = str(ammo_energy)
#	$Camera2D/CanvasLayer/LBL_Explosive/LBL_Amount.text = str(ammo_explosion)
#	$Camera2D/CanvasLayer/LBL_Shell/LBL_Amount.text = str(ammo_shells)

func _input(event):
	if event.is_action_pressed('scroll_up'):
		$Camera2D.zoom = $Camera2D.zoom - Vector2(0.1, 0.1)
	if event.is_action_pressed('scroll_down'):
		$Camera2D.zoom = $Camera2D.zoom + Vector2(0.1, 0.1)
	
	if event.is_action_pressed("pickup"):
		# check if player is standing on a weapon
		# if so, pick up current game and move current weapon to weaponcontainer
		if canPickUp:
			print("Boop!")


func _physics_process(delta):
	controls_loop()
	movement_loop()
	
	if RotationPoint.rotation_degrees < -90:
		RotationPoint.rotation_degrees = 270
	
	if RotationPoint.rotation_degrees > 270:
		RotationPoint.rotation_degrees = -90
	
	if RotationPoint.rotation_degrees > 0 and RotationPoint.rotation_degrees < 180 and $RotationPoint/WeaponSlot.z_index == 49 and weaponPosition == "Back":
		$RotationPoint/WeaponSlot.z_index = 51
		weaponPosition = "Front"
	
	if RotationPoint.rotation_degrees < 0 and $RotationPoint/WeaponSlot.z_index == 51 and weaponPosition == "Front" or RotationPoint.rotation_degrees > 180 and $RotationPoint/WeaponSlot.z_index == 51 and weaponPosition == "Front":
		$RotationPoint/WeaponSlot.z_index = 49
		weaponPosition = "Back"
	
	if RotationPoint.rotation_degrees > -90 and RotationPoint.rotation_degrees < 90 and characterFacing == "Right":
		$Character.flip_h = false
		$RotationPoint/WeaponSlot.scale = Vector2(1, 1)
		characterFacing = "Left"
	
	if RotationPoint.rotation_degrees > 90 and RotationPoint.rotation_degrees < 270 and characterFacing == "Left":
		$Character.flip_h = true
		$RotationPoint/WeaponSlot.scale = Vector2(1, -1)
		characterFacing = "Right"


func _process(delta):
	RotationPoint.look_at(get_global_mouse_position())
	
	if been_hit:
		randomize()
		hitfx_x_value = rand_range(-3, 3)
		$Character.material.set_shader_param("amount_x", hitfx_x_value)
		
		randomize()
		hitfx_y_value = rand_range(-3, 3)
		$Character.material.set_shader_param("amount_y", hitfx_y_value)
		
		get_node("/root/RoomScene/Camera2D").set_offset(Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount))


func controls_loop():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	var SHOOT = Input.is_action_pressed("fireweapon")
	
	var DROP_ITEM = Input.is_action_just_pressed("drop")
	var PICKUP_ITEM = Input.is_action_just_pressed("pickup")
	
	var INTERACT = Input.is_action_just_pressed("interact")
	
	if DROP_ITEM:
		if get_node("RotationPoint/WeaponSlot").get_child(0) != null and not canPickUp:
			var target
			if get_node("/root/").has_node("Main"):
				target = get_node("/root/Main/WeaponsContainer")
				
			if get_node("/root/").has_node("RoomScene"):
				target = get_node("/root/RoomScene/WeaponsContainer")
				
			var source = get_node("RotationPoint/WeaponSlot").get_child(0)
			var drop_position = self.position
			get_node("RotationPoint/WeaponSlot").remove_child(source)
			target.add_child(source)
			source.set_owner(target)
			source.position = drop_position
			source.set_name(source.item_type)
			canPickUp = true
		
	if PICKUP_ITEM:
#		print(itemToPickUp)
		if itemToPickUp != null and canPickUp:
			var target = get_node("RotationPoint/WeaponSlot")
			var source = itemToPickUp
			itemToPickUp.get_parent().remove_child(itemToPickUp)
			target.add_child(source)
			source.set_owner(target)
			source.position = Vector2(0,0)
			source.set_name(source.item_type)
			canPickUp = false
	
	if INTERACT and interact_with != null:
		match interact_with.tag:
			"EXIT":
				interact_with.exit()

	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)

	if SHOOT:
		shoot()

	if LEFT or RIGHT or UP or DOWN:
		anim_walk = "Move"
#		if LEFT:
#			character.flip_h = true
#
#		if RIGHT:
#			character.flip_h = false

	else:
		anim_walk = "Idle"


func movement_loop():
	var motion = movedir.normalized() * SPEED
	move_and_slide(motion, Vector2(0,0))


func shoot():
	if get_node("RotationPoint/WeaponSlot").get_child(0) != null and get_node("RotationPoint/WeaponSlot").get_child(0).has_method("Shoot"):
		match get_node("RotationPoint/WeaponSlot").get_child(0).ammo_to_use:
			"Bullet":
				if GameInstance.ammo_bullets > 0 and get_node("RotationPoint/WeaponSlot").get_child(0).can_shoot:
					GameInstance.ammo_bullets -= 1
					print(GameInstance.ammo_bullets)
					get_node("RotationPoint/WeaponSlot").get_child(0).Shoot()
			
			"Explosive":
				if GameInstance.ammo_explosion > 0 and get_node("RotationPoint/WeaponSlot").get_child(0).can_shoot:
					GameInstance.ammo_explosion -= 1
					print(GameInstance.ammo_explosion)
					get_node("RotationPoint/WeaponSlot").get_child(0).Shoot()
			
			"Energy":
				if GameInstance.ammo_energy > 0 and get_node("RotationPoint/WeaponSlot").get_child(0).can_shoot:
					GameInstance.ammo_energy -= 1
					print(GameInstance.ammo_energy)
					get_node("RotationPoint/WeaponSlot").get_child(0).Shoot()
			
			"Shell":
				if GameInstance.ammo_shells > 0 and get_node("RotationPoint/WeaponSlot").get_child(0).can_shoot:
					GameInstance.ammo_shells -= 1
					print(GameInstance.ammo_shells)
					get_node("RotationPoint/WeaponSlot").get_child(0).Shoot()


func animateCharacter():
	if anim_walk == "Idle":
		if character.frame < 10:
			character.frame = character.frame + 1
		else:
			character.frame = 7
	
	if anim_walk == "Move":
		if character.frame < 14:
			character.frame = 14
			
		if character.frame < 17:
			character.frame = character.frame + 1
		else:
			character.frame = 14


func _on_ItemDetection_area_entered(area):
	if area.get_parent().get("tag") and area.get_parent().tag == "Item":
		itemToPickUp = area.get_parent()
		
	if area.get_parent().get("tag") and area.get_parent().tag == "Ammo":
		match area.get_parent().type:
			"Bullet":
				GameInstance.ammo_bullets += area.get_parent().amount
				area.get_parent().queue_free()
			
			"Explosive":
				GameInstance.ammo_explosion += area.get_parent().amount
				area.get_parent().queue_free()
			
			"Energy":
				GameInstance.ammo_energy += area.get_parent().amount
				area.get_parent().queue_free()
			
			"Shell":
				GameInstance.ammo_shells += area.get_parent().amount
				area.get_parent().queue_free()
	
#	if area.get_parent().tag == "Item":
#		print(area.get_parent().name)
#		itemToPickUp = area.get_parent()


func _on_ItemDetection_area_exited(area):
	if itemToPickUp != null:
		itemToPickUp = null


func takeDamage(amount):
	been_hit = true
	$Character.material.set_shader_param("apply", true)
	$Timer_HitFX.start()


func _on_Timer_HitFX_timeout():
	$Character.material.set_shader_param("apply", false)
	been_hit = false
