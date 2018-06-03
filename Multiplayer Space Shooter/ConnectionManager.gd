extends Node

const PORT = 1234
var ship = null
var players = []

func _ready():
	ship = preload("res://Ship.tscn")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("connected_to_server", self, "_connected_ok")

func on_host_game():
	var host = NetworkedMultiplayerENet.new()
	# 4 is the number of maximum clients
	host.create_server(PORT, 4)
	get_tree().set_network_peer(host)

	_connected_ok()

func on_join_game(ip):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, PORT)
	get_tree().set_network_peer(host)

func _connected_ok():
	rpc("register_player", get_tree().get_network_unique_id())
	register_player(get_tree().get_network_unique_id())
	get_tree().get_root().get_node("Lobby").queue_free()

# this function is called when a new player is connected
# note the use of the keyword remote which mean that the code will only be called on the others
remote func register_player(player_id):
	var p = ship.instance()
	p.set_network_master(player_id)
	p.name = str(player_id)
	get_tree().get_root().add_child(p)
	# if I'm the server I inform the new connected player about the others
	if get_tree().get_network_unique_id() == 1:
		if player_id != 1:
			for i in players:
				rpc_id(player_id, "register_player", i)
		players.append(player_id)
