extends Control

@onready var chart: Chart = $Chart

var function := Function.new(
	[0, 1, 2, 3, 4, 5, 6],  # The function's X-values
	[4, 8, 2, 9, 7, 8, 12], # The function's Y-values
	"Money Made",       # The function's name
	{
	type = Function.Type.LINE,       # The function's type
	marker = Function.Marker.SQUARE, # Some function types have additional configuraiton
	color = Color("#36a2eb"),        # The color of the drawn function
	}
	)

var chart_properties := ChartProperties.new()


func _ready() -> void:
	
	chart_properties.x_label = "Level"
	chart_properties.y_label = "Money"
	chart_properties.title = "Money Made"
	chart_properties.show_legend = true
	
	chart.plot([function], chart_properties)
