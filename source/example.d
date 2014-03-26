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
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		auto menubar = new MenuBar(this.mainWindow);

		auto fileMenu = new Menu(menubar, "File")
			.addItem("Open...")
			.addItem("Save...")
			.addSeparator()
			.addItem("Quit...");

		auto helpMenu = new Menu(menubar, "Help");

		auto frame = new Frame()
			.pack();

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
