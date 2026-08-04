extends Node2D
@export var nameLabel : Label
@export var speciesName := ""
const EDITOR = "res://main/scenes/editor.tscn"
var parent
var parentNode:Node
var treeLoader
var siblingOffset
var childnum
var isDragging
var mouseOffset
var children
func _ready() -> void:
	nameLabel.text = speciesName
	name = speciesName
	siblingOffset = treeLoader.sideOffset
	treeLoader.treeDone.connect(pathMake)
	$Panel.size = $Container.size
	$Panel.position = $Container.position
func _on_add_child_pressed() -> void:
	var le = LineEdit.new()
	le.name = "addChildle"
	$Container.add_child(le)
	$Container/addChild.visible = false
	$Container/addChildle.text_submitted.connect(addChildCool.bind(speciesName))
func addChildCool(new_text: String, parent_name: String) -> void:
	if new_text.strip_edges() == "":
		return
	var siblingNum= get_node("../"+parent_name).childnum
	treeLoader.addChildNode(new_text,parent_name,siblingNum)
	
	if $Container/addChildle:
		$Container/addChildle.queue_free()
		$Container/addChild.visible = true
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :#dragging logic
		if event.pressed and not Global.isDragging and parent and not get_node_or_null("Container/addChildle"):
			if $Container.get_rect().has_point(to_local(event.position)):
				
				isDragging = true
				Global.isDragging = true
				mouseOffset = get_global_mouse_position()-global_position

		else:
			if parent:
				treeLoader.saveMousePos(name,parent)
			isDragging = false
			Global.isDragging = false
			pathMake()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT :#dragging logic
		if event.pressed :
			
			if not get_node_or_null("Container/FlowContainer/addChildle"):
				if $Container.get_rect().has_point(to_local(event.position)):
					OpenEditor()
func _physics_process(_delta):
	$Panel.size = $Container.size
	$Panel.position = $Container.position
	if isDragging:
		global_position.y = get_global_mouse_position().y
func OpenEditor():
	Global.selectedNode=name
	get_tree().change_scene_to_file(EDITOR)
func pathMake():
	for child_line in get_children():
		if child_line is Line2D and child_line.name.begins_with("PathTo_"):
			child_line.queue_free()

	if children == null or children.is_empty():
		return

	for child in children:
		var child_node = treeLoader.get_node_or_null(str(child))
		if not child_node:
			printerr("CANT FIND CHILD NODE: ", child)
			continue
			
		var child_local_pos = to_local(child_node.global_position)
		
		var branch_line = Line2D.new()
		branch_line.name = "PathTo_" + str(child)
		
		branch_line.width = 2.0 
		branch_line.default_color = Color.WHITE 
		
		branch_line.add_point(child_local_pos)
		branch_line.add_point(Vector2(child_local_pos.x, 0))
		branch_line.add_point(Vector2.ZERO)
		
		add_child(branch_line)
		
