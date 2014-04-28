module main;

/**
 * Imports.
 */
import std.stdio;
import tkd.tkdapplication;

/**
 * Sample application.
 */
class Application : TkdApplication
{
	/**
	 * Wigets.
	 */
	private Canvas _canvas;

	/**
	 * Event callbacks.
	 */
	private void exitCommand(CommandArgs args)
	{
		this.exit();
	}

	private void mark(CommandArgs args)
	{
		this._canvas.setScanMark(args.event.x, args.event.y);
	}

	private void drag(CommandArgs args)
	{
		this._canvas.scanDragTo(args.event.x, args.event.y);
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.mainWindow.setTitle("Canvas example");
		this.mainWindow.configureGeometryColumn(0, 1);
		this.mainWindow.configureGeometryRow(1, 1);

		auto label = new Label("The canvas widget can be used to draw shapes,\nimages and widgets on a user defined area.")
			.grid(0, 0, 10, 0, 1, 1, "new");

		auto frame = new Frame()
			.configureGeometryColumn(0, 1)
			.configureGeometryRow(0, 1)
			.grid(0, 1, 10, 0, 1, 1, "nesw");

		this._canvas = new Canvas(frame)
			.setWidth(330)
			.setHeight(270)
			.setCursor(Cursor.hand1)
			.setScrollRegion(-300, -250, 610, 500)
			.addItem(new CanvasRectangle([10, 10, 200, 100]).addTag("tagged"))
			.addItem(new CanvasArc([10, 110, 110, 210], CanvasArcStyle.pie, Color.white))
			.addItem(new CanvasImage([210, 10], new Png!("thumbnail.png")))
			.addItem(new CanvasImage([260, 10], new Gif!("thumbnail.gif")))
			.addItem(new CanvasLine([120, 110, 200, 110, 200, 160]).setArrowPosition(CanvasLineArrow.last))
			.addItem(new CanvasOval([10, 170, 200, 245], Color.white))
			.addItem(new CanvasPolygon([220, 80, 320, 80, 300, 120, 240, 120], Color.white))
			.addItem(new CanvasText([20, 200], "Lorem ipsum dolor sit amet.").addTag("tagged"))
			.addItem(new CanvasWidget([220, 140], new Button("Embedded\nButton")).setWidth(100).setHeight(100))
			.addTagConfig(new CanvasTagConfig("tagged").setFillColor(Color.red))
			.bind("<ButtonPress-1>", &this.mark)
			.bind("<B1-Motion>", &this.drag);

		auto xscroll = new XScrollBar(frame)
			.attachWidget(this._canvas)
			.grid(0, 1, 0, 0, 1, 1, "esw");

		auto yscroll = new YScrollBar(frame)
			.attachWidget(this._canvas)
			.grid(1, 0, 0, 0, 1, 1, "nes");

		this._canvas
			.attachXScrollBar(xscroll)
			.attachYScrollBar(yscroll)
			.grid(0, 0, 0, 0, 1, 1, "nesw");

		auto button = new Button("Exit")
			.setCommand(&this.exitCommand)
			.grid(0, 2, 10, 0, 1, 1, "s");

		auto sizegrip = new SizeGrip()
			.grid(0, 3, 0, 0, 1, 1, "se");
	}
}

/**
 * Main entry point.
 *
 * Params:
 *     args = An array of command line arguments passed to this program.
 */
void main(string[] args)
{
	auto app = new Application();
	app.run();
}
