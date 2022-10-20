#I think we should make face_to method to properly face the ship on our will

extends ShipClass


func _ready():
	$Body/InteriorArea.connect("body_entered", self, "body_entered")
	$Body/InteriorArea.connect("body_exited", self, "body_exited")
	$Body/PassengerArea.connect("body_entered", self, "add_passenger")
	$Body/PassengerArea.connect("body_exited", self, "remove_passenger")
	deploy_landing_gear()

func body_entered(body):
	if body == Globals.player:
		set_animation("exterior_fade_out")
		return
	
func body_exited(body):
	if body == Globals.player:
		set_animation("exterior_fade_in")
		return

func add_passenger(body):
	if body in passengers:
		return
	body.ship = self
	passengers.append(body)
	
func remove_passenger(body):
	if body in passengers:
		passengers.erase(body)
		if body.ship == self:
			body.ship = null
		body.ship_relative_position = Vector2.ZERO
