extends RigidBody2D


var counter = 0
var mutex: Mutex
var semaphore: Semaphore
var thread: Thread = Thread.new()
var exit_thread: bool = false


func _ready():
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	exit_thread = false
	
	thread.start(self, "_thread_function")

func call_by_thread(thread: Thread, target_obj: Object, method: String, datas = null):
	var err = thread.start(target_obj, method, datas)
	if err == OK:
		return thread.wait_to_finish()
	elif err == ERR_CANT_CREATE:
		print("Can't create a new thread, possibly working with something else")

func _physics_process(delta):
	if Input.is_action_just_pressed("left"):
		increment_counter()
	if Input.is_action_just_pressed("down"):
		call_by_thread(thread, self, "two_p_two")

func puny_function(userdata):
	return (1 + 1)

func one_p_one(data):
	print(1+1)

func two_p_two(data):
	print(2 + 2)

func _thread_function(userdata):
	semaphore.wait()
	
	mutex.lock()
	var should_exit = exit_thread
	mutex.unlock()
	#"
	#if should_exit:
	#	break"
		
	mutex.lock()
	counter += 1
	mutex.unlock()
	
	print(counter)
	

func increment_counter():
	print("Increment called")
	semaphore.post()


func get_counter():
	mutex.lock()
	var counter_value = counter
	mutex.unlock()
	return counter_value
	

func _exit_tree():
	mutex.lock()
	exit_thread = true
	mutex.unlock()
	
	semaphore.post()
	
	thread.wait_to_finish()
	
	print("Counter is: ", counter)
