module main;

/**
 * Imports.
 */
import std.algorithm;
import std.range;
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

	private void execute(CommandArgs args)
	{
		// writefln("%s", (cast(UiElement)args.element).getCursorPos());
		writefln("%s, %s", this._canvas.getXPosFromScreen((cast(UiElement)args.element).getCursorXPos()), this._canvas.getYPosFromScreen((cast(UiElement)args.element).getCursorYPos()));
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		auto frame = new Frame(2, ReliefStyle.groove)
			.pack();

		this._canvas = new Canvas(frame)
			.bind("<Button-1>", &this.execute)
			.setScrollRegion(0, 0, 1000, 1000)
			.addItem(new Rectangle([10, 10, 200, 100]).setFillColor("red"))
			.pack();

		auto xscroll = new XScrollBar(frame)
			.attachWidget(this._canvas)
			.pack();

		auto yscroll = new YScrollBar(frame)
			.attachWidget(this._canvas)
			.pack();

		this._canvas
			.attachXScrollBar(xscroll)
			.attachYScrollBar(yscroll);

		auto button = new Button(frame, "Exit")
			.setCommand(&this.exitCommand)
			.pack();
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
