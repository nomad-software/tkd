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
	private Window _win;

	/**
	 * Event callbacks.
	 */
	private void exitCommand(Widget widget, CommandArgs args)
	{
		this.exit();
	}

	private void execute(Widget widget, CommandArgs args)
	{
		writefln("Screen: %sx%spx", (cast(Button)widget).getScreenWidth(), (cast(Button)widget).getScreenHeight());
		writefln("Widget: %sx%spx", (cast(Button)widget).getXPos(), (cast(Button)widget).getYPos());
		writefln("Widget: %sx%spx", (cast(Button)widget).getXPos(true), (cast(Button)widget).getYPos(true));
		writefln("Cursor: %s", (cast(Button)widget).getCursorPos());
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		auto frame = new Frame()
			.pack();

		auto button1 = new Button(frame, "Execute")
			.setCommand(&this.execute)
			.pack();

		auto button2 = new Button(frame, "Exit")
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
