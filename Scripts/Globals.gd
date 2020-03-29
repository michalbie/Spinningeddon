extends Node

enum level {MIN, SMALL, MEDIUM, HIGH, MAX}

const move_speed = [1, 100, 150, 200, 1000] # was 300
const rotate_cooldown = [1, 1, 3, 5, 10] # was 3
const rotate_speed = [1, 3, 5, 7, 10] # was 2
const shoot_cooldown = [0.1, 0.25, 1.5, 3, 10]
const bullet_speed = [1, 300, 600, 900, 1000] # was 600
const bullet_damage = [1, 15, 30, 60, 100] # was 50
const bullet_range = [1, 500, 1250, 2000, 10000] # was 800
const hp = [1, 100, 150, 200, 1000] # was 100
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
