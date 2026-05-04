extends Control

@onready var chart: Chart = $VBoxContainer/Chart

# This Chart will plot 3 different functions
var f1: Function
var total_points: int = 4

func _ready():
	# Let's create our @x values
	var x: Array = ["Level 1", "Level 2", "Level 3", "Level 4"]
	
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	var y: Array = [20, 10, 50, 0]
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.y_scale = 10
	cp.x_scale = 1
	cp.max_samples = 999999999999
	cp.draw_origin = true
	cp.draw_bounding_box = false
	cp.draw_vertical_grid = false
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	# Let's add values to our functions
	f1 = Function.new(
		x, y, "Money Made", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		{
			type = Function.Type.BAR,
			bar_size = 200 / total_points
		}
	)
	
	# Now let's plot our data
	chart.plot([f1], cp)
	
	# Uncommenting this line will show how real time data plotting works
	set_process(false)


var new_val: float = 5

func _process(delta: float):
	# This function updates the values of a function and then updates the plot
	new_val += 5
	#cp.bar_size = 200 / total_points
	# we can use the `Function.add_point(x, y)` method to update a function
	f1.add_point(new_val, new_val + 1)
	total_points += 1
	#f1.remove_point(1)
	chart.queue_redraw() # This will force the Chart to be updated


func _on_CheckButton_pressed():
	set_process(not is_processing())
