extends Node


func get_percent_of(value, percent):
	# This will return the percentage specified of the given value
	var decimal_percent = percent/100
	return value * decimal_percent

func decimal_to_percent(decimal):
	# This will return a percent of a decimal
	return decimal * 100
