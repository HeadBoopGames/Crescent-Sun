extends ViewportContainer

func updateUI():
	$CR_Background/LBL_Variables/LBL_Health.text = str(GameInstance.player_health)
	$CR_Background/LBL_Variables/LBL_Bullets.text = str(GameInstance.ammo_bullets)
	$CR_Background/LBL_Variables/LBL_Shells.text = str(GameInstance.ammo_shells)
	$CR_Background/LBL_Variables/LBL_Energy.text = str(GameInstance.ammo_energy)
	$CR_Background/LBL_Variables/LBL_Explosion.text = str(GameInstance.ammo_explosion)