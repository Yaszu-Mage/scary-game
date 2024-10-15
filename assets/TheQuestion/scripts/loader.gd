extends AnimatedSprite2D
signal loaded


func loader(scene):
	var initscene = load(scene).instantiate()
	add_sibling(initscene)
