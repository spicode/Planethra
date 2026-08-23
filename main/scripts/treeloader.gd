extends Node2D
#TODO WHEN FINDING Gets slow add ids and find by binary search
const NODE = preload("uid://b680gedqhnsbt")
@export var evotreepathlocal : String 
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
	Global.evotreepath = evotreepathlocal
	var file = FileAccess.open(evotreepathlocal,FileAccess.READ_WRITE)
	assert(file.file_exists(evotreepathlocal),"uhh.. where is evotree sure not in given path")
	var json = file.get_as_text()
	var json_object = JSON.new()
	json_object.parse(json)
	printerr(json_object.get_error_message())
	dictevotree = json_object.data
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
	
	if FileAccess.file_exists(evotreepathlocal):
		var file_read = FileAccess.open(evotreepathlocal, FileAccess.READ)
		var json_text = file_read.get_as_text()
		file_read.close()
		
		if json_text.strip_edges() != "":
			var json_object = JSON.new()
			if json_object.parse(json_text) == OK:
				jdata = json_object.data

	jdata[Name] = {
		"name": Name,
		"Parent": Parent,
		"childeren": [],
		"distance_to_parent": 0
	}
	
	if Parent != null and jdata.has(Parent):
		if not jdata[Parent]["childeren"].has(Name):
			jdata[Parent]["childeren"].append(Name)
			
	var file_write = FileAccess.open(evotreepathlocal, FileAccess.WRITE)
	var json_output = JSON.stringify(jdata, "\t")
	file_write.store_string(json_output)
	file_write.close()
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
	var file = FileAccess.open(evotreepathlocal,FileAccess.READ_WRITE)

	assert(file.file_exists(evotreepathlocal),"uhh.. where is evotree sure not in given path")
	var json = file.get_as_text()
	var json_object = JSON.new()
	json_object.parse(json)
	print(json_object.get_error_message())
	var jdata = json_object.data
	if jdata:
		return true
	return false
func saveMousePos(Name,parent):
	var jdata: Dictionary = {}

	if FileAccess.file_exists(evotreepathlocal):
		var file_read = FileAccess.open(evotreepathlocal, FileAccess.READ)
		var json_text = file_read.get_as_text()
		file_read.close()
		
		if json_text.strip_edges() != "":
			var json_object = JSON.new()
			if json_object.parse(json_text) == OK:
				jdata = json_object.data
	if not parent:
		jdata[Name]["distance_to_parent"]= get_node(str(Name)).global_position.y
	else:
		if parent and Name and get_node_or_null(str(Name)) and get_node_or_null(str(parent)):
			
			var dist=get_node(str(Name)).global_position.y-get_node(str(parent)).global_position.y
			jdata[Name]["distance_to_parent"]=dist
	var file_write = FileAccess.open(evotreepathlocal, FileAccess.WRITE)
	var json_output = JSON.stringify(jdata, "\t")
	file_write.store_string(json_output)
	file_write.close()
	for child in jdata[Name]["childeren"]:
		saveMousePos(child,Name)


func _on_editor_pressed() -> void:
	pass # Replace with function body.
