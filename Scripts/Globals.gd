extends Node

enum level {MIN, SMALL, MEDIUM, HIGH, MAX}

const move_speed = [200, 280, 300, 320, 400]
const rotate_cooldown = [10, 4, 3, 1, 0.2]
const rotate_speed = [1, 1.5, 2, 2.5, 10]
const shoot_cooldown = [4.5, 0.7, 0.4, 0.15, 0.1]    # wartości są troszkę niezgodne z opisem bo shoot coldown small oznacza że powinien często strzelać a strzela wtedy rzadko, jest tak dlatego aby na wykresach postacie z wysoką szybkostrzelnością miały więcej punkcików
const bullet_speed = [1, 1200, 1600, 2000, 2400]
const bullet_damage = [1, 15, 30, 60, 30]
const bullet_range = [1, 500, 1250, 2250, 10000]
const hp = [1, 100, 150, 200, 240] 

const CLASSES_PATH = "res://Entities/Character/Player/Classes/"
var classes = {
	"CloseRifleman": {
		"scene": load(CLASSES_PATH + "CloseRifleman.tscn"),
		"class": load(CLASSES_PATH + "CloseRifleman.gd")
	},
	"HeavyMachinegunner": {
		"scene": load(CLASSES_PATH + "HeavyMachinegunner.tscn"),
		"class": load(CLASSES_PATH + "HeavyMachinegunner.gd")
	},
	"LightAssaulter": {
		"scene": load(CLASSES_PATH + "LightAssaulter.tscn"),
		"class": load(CLASSES_PATH + "LightAssaulter.gd")
	},
	"Sniper": {
		"scene": load(CLASSES_PATH + "Sniper.tscn"),
		"class": load(CLASSES_PATH + "Sniper.gd")
	},
	"Soldier": {
		"scene": load(CLASSES_PATH + "Soldier.tscn"),
		"class": load(CLASSES_PATH + "Soldier.gd")
	},
}
