class_name Utils
extends Node

static func round_step(number: float, increment : float, offset = .0) -> float:
	return ceil((number - offset) / increment) * increment + offset

static func compare_floats(a : float, b : float, epsilon := 0.001) -> bool:
	return abs(a - b) <= epsilon
