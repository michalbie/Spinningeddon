extends TextureButton

export (String) var label_text

func _ready():
	$Label.text = label_text


