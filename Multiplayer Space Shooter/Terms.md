# [Multiplayer Terms](https://godot3tutorials.wordpress.com/2018/03/02/part-3-multiplayer-tutorial-godot-main-multiplayer-concepts/)

## Master/Slave

In multiplayer Godot games, every client as a part of its own tree which is identical to the others. In the current state of our game, each client will launch the game and have a Main node which contains a Ship node. However, in our example, each client will be able to control the ship. This is obviously not what we want. To avoid that, there is the concept of master and slave. The master is the client who has authority on a node and the other clients are the slaves. In the case where we have four players A, B, C and D. And four ships SA, SB, SC and SD. The player A is the master of the ship SA and the slave of the ships SB, SC, SD.

## RPC (Remote Procedure Calls)

It can be necessary to call a method on the game instance of another client. For example, if there is an asteroid which is controlled by the server (the server is the master of the asteroid), a client can detect a collision of its missile and inform the server that the asteroid should be destroyed. This is done by calling the method:

```gdscript
asteroid.rpc_id(1, "explode")
```

where asteroid is the node of the touched asteroid, 1 is the id of the server and explode the method that should be called on the asteroid on the server. It is also possible to broadcast an rpc by calling the method “rpc” (without the “_id”).

## RSET (Remote SET)

This method is similar to rpc except that this is used to set the value of a variable remotely.

## Unreliable

Sometimes, the reception of a rpc or a rset is not mandatory. For example, it is not really necessary to have an exact knowledge of the rotation of every players at every milliseconds. Then the rotation of the ships can be set using rset_unreliable.

## Method prefixes (master, slave, sync, remote)

Before any function that will be called using rpc you have to put a specific prefix. The master prefix tells that this function will only be executed by the master of the node. The slave prefix tells that the function will only be executed by the slaves. The sync prefix tells that the function will be executed by everyone. And the remote prefix tells that everyone except the one which has made the call will execute the function.

### Example:

If someone run the code:

```gdscript
obj.rpc("hello")
```

then only the master of the object obj will execute the code:

```gdscript
master func hello():
	print("hello")
```
