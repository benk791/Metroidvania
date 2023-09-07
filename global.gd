extends Node

var PlayerHealth = 10
var maxPlayerHealth = 10

var UpgradeWallJump = false
var UpgradeDoubleJump = false

signal dead
signal PlayerRespawn
signal PlayerDestroy
signal Interact
signal hurt(amount)
signal Refocus(Left, Top, Right, Bottom)
signal NewSafePosition(PositionVector)
