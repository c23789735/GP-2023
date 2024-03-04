
extends Node

var samples:Array
var pads:Dictionary

@export var path_str = "res://samples" 
@export var pad_scene:PackedScene
@export var sample_scene:PackedScene

@export var num_pads = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the path to the folder containing the WAV fes
	var folder_path = "res://sounds/"	
	# make_pads()
	load_samples()
	make_samplees()

func make_pads():
	var w
	var g
	for i in range(num_pads):
		var pad = pad_scene.instantiate()
		var ww:ColorRect = pad.get_node("rect")
		w = ww.get_size().x
		g = w * 0.1
		
		var p = Vector2((i * (w + g)), 0)
		pad.position = p
		add_child(pad)

func button_pressed(i):
	$AudioStreamPlayer.stream = samples[i]
	$AudioStreamPlayer.play()
	print(i)

func play_sample(i):
	
	var p:AudioStreamWAV = samples[i]
	$AudioStreamPlayer.stream = p
	$AudioStreamPlayer.play()

func make_samplees():
	for i in range(samples.size()):
		var sample = sample_scene.instantiate()
		var b:Button = sample.get_node("Button")
		b.pressed.connect(button_pressed.bind(i))
		
		
		# var b = sample.get_node("rect")
		var h = b.get_size().y
		
		var p = Vector2(0, h * i * 1.1)
		sample.position = p
		
		b.set_text(samples[i].resource_name)
		add_child(sample)
		
func load_samples():
	var dir = DirAccess.open(path_str)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			elif file_name.ends_with(".wav"):				
				var stream
				# var file = FileAccess.open(path_str + "/" + file_name, FileAccess.READ)
				# var buffer = file.get_buffer(file.get_length())
				# stream = AudioStreamOggVorbis.load_from_file(path_str + "/" + file_name)
				var audio_loader = AudioLoader.new()
				$AudioStreamPlayer.stream =  audio_loader.loadfile(path_str + "/" + file_name)
				
				# stream.format = AudioStreamWAV.FORMAT_16_BITS		
				# stream = 
				# stream.stereo = true
				# stream.resource_name = file_name
				# file.close() 
				samples.push_back(stream)
				$AudioStreamPlayer.play()
				break
			file_name = dir.get_next()	
