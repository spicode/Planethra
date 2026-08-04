extends Control

var dictevotree
var Name
const MAIN = "res://main/scenes/main.tscn"
var pathToImage
func _enter_tree() -> void:
	Global.activeScene="Editor"
func _ready() -> void:
	get_tree().root.files_dropped.connect(_on_files)	
	var file = FileAccess.open(Global.evotreepath,FileAccess.READ_WRITE)
	assert(file.file_exists(Global.evotreepath),"uhh.. where is evotree sure not in given path")
	var json = file.get_as_text()
	var json_object = JSON.new()
	json_object.parse(json)
	printerr(json_object.get_error_message())
	Name=Global.selectedNode
	if not Name:
		Name="fuca"
	dictevotree = json_object.data
	$LineEdit.text = Name
	if dictevotree[Name].has("discription"):
		$TextEdit.text=dictevotree[Name]["discription"]
	if dictevotree[Name].has("image"):
		var img = Image.new()
		img.load(dictevotree[Name]["image"])
		if img:
			$TextureRect.texture =ImageTexture.new().create_from_image(img)
func _on_button_pressed() -> void:
	var oldName =  Name
	var newName = $LineEdit.text.strip_edges()
	var nodeData: Dictionary = dictevotree[oldName].duplicate()
	nodeData["name"] = newName
	nodeData["discription"] = $TextEdit.text
	nodeData["image"] = pathToImage
	if oldName != newName:
		dictevotree[newName] = nodeData
		dictevotree.erase(oldName)
		
		# update parents children list
		var parentName = nodeData.get("Parent")
		if parentName and dictevotree.has(parentName):
			var idx = dictevotree[parentName]["childeren"].find(oldName)
			if idx != -1: dictevotree[parentName]["childeren"][idx] = newName
				
		# update childrens parent pointers
		for child in nodeData.get("childeren", []):
			if dictevotree.has(child): dictevotree[child]["Parent"] = newName
				
		Name = newName 
	else:
		dictevotree[oldName] = nodeData
	var file_write = FileAccess.open(Global.evotreepath, FileAccess.WRITE)
	var json_output = JSON.stringify(dictevotree, "\t")
	file_write.store_string(json_output)
	file_write.close()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN)


func _on_load_image_pressed() -> void:
	$FileDialog.popup()

func _on_files(files):
	
	#i couldnt get drag and drop to word so this is what im doing
	$Popup/Label.text = "no drag and drop for you but here is you clipboard: \n\n"+files[0]
	$Popup.popup()
	await get_tree().create_timer(5).timeout
	$Popup.visible = false
func _on_file_dialog_file_selected(path: String) -> void:
	
	var image = Image.new()
	image.load(path)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	pathToImage = path
	$TextureRect.texture=texture
	


func _on_delete_pressed() -> void:
	if dictevotree.has(Global.selectedNode):
		deleteChildren(Global.selectedNode)
	get_tree().change_scene_to_file(MAIN)
func deleteChildren(Name):
	for child in dictevotree[Name]["childeren"]:
		deleteChildren(child)
	
	
	# update parents children list
	var parentName =  dictevotree[Name].get("Parent")
	if parentName and dictevotree.has(parentName):
		var cid = dictevotree[parentName]["childeren"].find(Name)
		dictevotree[parentName]["childeren"].remove_at(cid)
	dictevotree.erase(Name)
	var file_write = FileAccess.open(Global.evotreepath, FileAccess.WRITE)
	var json_output = JSON.stringify(dictevotree, "\t")
	file_write.store_string(json_output)
	file_write.close()
