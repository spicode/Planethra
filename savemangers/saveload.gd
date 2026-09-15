extends Node
var saveName:String = ""
var saveid:int = -1
var savenameSet:=false
@export var saveloacation:="res://saves/"

func set_savename(save_name:String):
	saveid = get_save_id(save_name)
	saveName = str(save_name, "_", saveid)
	savenameSet = true
	_saveToPage()

func get_base_savename():
	if savenameSet:
		return saveName.split("_")[0]
	return ""

func get_full_savename(_saveid:int = saveid) -> String:
	if not savenameSet:
		return ""
	if saveid != _saveid:
		var allSaves:Dictionary = _loadPage()
		if allSaves.has(str(_saveid)):
			return allSaves[str(_saveid)]["Name"]
		return ""
	return saveName

func get_save_id(_saveName:String = saveName) -> int:
	if saveid > 0:
		return saveid
	if _saveName == "":
		return 0
	var allSaves:Dictionary = _loadPage()
	if not allSaves:
		return 0
	for sav in allSaves.keys(): # keys are Strings, e.g. "0","1"
		if allSaves[sav]["Name"] == _saveName:
			return int(sav)
	return 0

func save(Data:Dictionary):
	if not saveName:
		printerr("no save Name must set save name before saving")
		return
	var file_write = FileAccess.open(getLocalPath(saveName), FileAccess.WRITE)
	file_write.store_string(JSON.stringify(Data, "\t"))
	file_write.close()

func loadData(localpath:String = "", _saveid:int = saveid, _fullname:String = ""):
	if localpath == "":
		localpath = getLocalPath(get_full_savename(_saveid))
	if _fullname == "":
		_fullname = get_full_savename(_saveid)

	var jdata: Dictionary = {}
	if FileAccess.file_exists(localpath):
		var file_read = FileAccess.open(localpath, FileAccess.READ)
		var json_text = file_read.get_as_text()
		file_read.close()
		if json_text.strip_edges() != "":
			var json_object = JSON.new()
			if json_object.parse(json_text) == OK:
				jdata = json_object.data
	return jdata

func getLocalPath(fileName:String) -> String:
	return str(saveloacation, fileName, ".json")

func getUidPath(path):
	if ResourceUID.path_to_uid(path) == path:
		var UID = ResourceUID.create_id_for_path(path)
		ResourceUID.add_id(UID, path)
	return ResourceUID.path_to_uid(path)

func _loadPage():
	var jdata: Dictionary = {}
	if FileAccess.file_exists(Consts.PageFilePath):
		var file_read = FileAccess.open(Consts.PageFilePath, FileAccess.READ)
		var json_text = file_read.get_as_text()
		file_read.close()
		if json_text.strip_edges() != "":
			var json_object = JSON.new()
			if json_object.parse(json_text) == OK:
				jdata = json_object.data
	return jdata

func _saveToPage():
	var allSaves = _loadPage()
	var id = get_save_id()
	allSaves[str(id)] = {
		"Name": saveName,
		"ID": id,
		"LocalPath": getLocalPath(saveName),
		"UIDPath": getUidPath(getLocalPath(saveName))
	}
	var file_write = FileAccess.open(Consts.PageFilePath, FileAccess.WRITE)
	file_write.store_string(JSON.stringify(allSaves, "\t"))
	file_write.close()
