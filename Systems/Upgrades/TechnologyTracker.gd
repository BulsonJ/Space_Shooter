class_name TechnologyTracker
extends Resource

var unlocked_tech : Array
export (Array, Resource) var tech_list = []

func unlock_tech(tech : int) -> void:
	if unlocked_tech.find(tech_list[tech]) == -1:
		unlocked_tech.append(tech_list[tech])
		print("unlocked tech")

func calculate_rate_of_fire(rate_of_fire : float) -> float:
	var added_rof := 0.0
	for i in unlocked_tech.size():
		added_rof += unlocked_tech[i].rate_of_fire_increase
	if added_rof > 0:
		rate_of_fire = rate_of_fire - (rate_of_fire / added_rof)
	return rate_of_fire
