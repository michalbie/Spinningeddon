extends Node

enum level {MIN, SMALL, MEDIUM, HIGH, MAX}

const move_speed = [1, 200, 300, 400, 1000] # was 300
const rotate_cooldown = [10, 5, 3, 2, 1] # was 3
const rotate_speed = [1, 2, 3, 4, 10] # was 2
const shoot_cooldown = [2, 0.7, 0.4, 0.15, 0.1]
const bullet_speed = [1, 800, 1600, 2400, 3500] # was 600
const bullet_damage = [1, 15, 30, 60, 100] # was 50
const bullet_range = [1, 200, 1250, 2500, 10000] # was 800
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
