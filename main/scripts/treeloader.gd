#main.gd
extends Node2D
#TODO WHEN FINDING Gets slow add ids and find by binary search
#TODO Current task save load system
const NODE = preload("uid://b680gedqhnsbt")
@export var baseTreePath : String 
@export var rootPosition : Vector2
@export_group("sibling offset")
@export var sideOffset := 50.0
@export_group("child offset")
@export var defualtDownOffset := 100.0
signal treeDone
var loadedNodes = []
var dictevotree
func _enter_tree() -> void:
	Global.activeScene="Evolution tree"
func _ready() -> void:
	Global.selectedNode=null
	Saveload.set_savename("evotree")
	Global.saveloadMain=Saveload
	Global.fullSaveName=Saveload.get_save_id()
	loadTree()
	emit_signal("treeDone")
func loadTree():
	for node in loadedNodes:
		if node:
			node.queue_free()
		loadedNodes.erase(node)
	if treeHasRoot() and get_node_or_null("createRoot")!=null:
		$createRoot.queue_free()
	elif not treeHasRoot():
		return
	
	dictevotree = Saveload.loadData()
	loadChildNodes("fuca",null)
func loadChildNodes(Name:String,Parent):

	var newNode := NODE.instantiate()
	if Parent:
		var parentNode = get_node_or_null(Parent)
		if parentNode==null:
			printerr("orphan node: "+Name+" ,parent name: "+Parent)
			print_tree_pretty()
		else:
			var down = dictevotree[Name]["distance_to_parent"]
			var side = dictevotree[Parent]["childeren"].find(Name)*sideOffset-sideOffset/2
			newNode.global_position =  Vector2(parentNode.global_position.x+(side),parentNode.global_position.y+down) 
	else:
		var down = float(dictevotree[Name]["distance_to_parent"])
		newNode.global_position = Vector2(rootPosition.x,rootPosition.y+down)
	newNode.add_to_group("nodes")
	newNode.speciesName = Name
	newNode.parent= Parent
	newNode.childnum = dictevotree[Name]["childeren"].size()
	newNode.treeLoader = $"."
	newNode.children=dictevotree[Name]["childeren"]
	add_child(newNode)
	loadedNodes.append(get_node(Name))
	for child:String in dictevotree[Name]["childeren"]:
		loadChildNodes(child,Name)
func genRoot():
	var newNode := NODE.instantiate()
	newNode.global_position = rootPosition
	newNode.add_to_group("nodes")
	newNode.speciesName = "fuca"
	newNode.parent= null
	newNode.treeLoader = $"."
	add_child(newNode)
	loadedNodes.append($fuca)
	addNodeToJson("fuca",null)
	loadTree()
func _on_create_root_pressed() -> void:
	genRoot()
	print("root created")
	$createRoot.queue_free()
func addNodeToJson(Name: String, Parent) -> void:
	var jdata: Dictionary = {}
	
	jdata =getSaveData()

	jdata[Name] = {
		"name": Name,
		"Parent": Parent,
		"childeren": [],
		"distance_to_parent": 0
	}
	
	if Parent != null and jdata.has(Parent):
		if not jdata[Parent]["childeren"].has(Name):
			jdata[Parent]["childeren"].append(Name)
			
	Saveload.save(jdata)
func addChildNode(_Name: String, parent:String,siblingNum):
	var newNode := NODE.instantiate()
	newNode.global_position = Vector2(get_node(parent).global_position.x+(sideOffset*siblingNum),get_node(parent).global_position.y+defualtDownOffset) 
	newNode.add_to_group("nodes")
	newNode.speciesName = _Name
	newNode.parent= parent
	newNode.name = _Name
	newNode.treeLoader = $"."
	addNodeToJson(_Name,parent)
	add_child(newNode)
	loadedNodes.append(get_node(_Name))
	get_tree().reload_current_scene()
func treeHasRoot()->bool:

	var jdata = getSaveData()
	if jdata:
		return true
	return false
func saveMousePos(Name,parent):
	var jdata: Dictionary = getSaveData()
	if not parent:
		jdata[Name]["distance_to_parent"]= get_node(str(Name)).global_position.y
	else:
		if parent and Name and get_node_or_null(str(Name)) and get_node_or_null(str(parent)):
			var dist=get_node(str(Name)).global_position.y-get_node(str(parent)).global_position.y
			jdata[Name]["distance_to_parent"]=dist
	Saveload.save(jdata)
	for child in jdata[Name]["childeren"]:
		saveMousePos(child,Name)
func getSaveData():
	return Saveload.loadData(Saveload.getLocalPath(Saveload.get_full_savename()))

func _on_editor_pressed() -> void:
	pass # Replace with function body.
