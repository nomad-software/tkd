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

	private void createWindow(Widget widget, CommandArgs args)
	{
		this._win = new Window("New window");

		auto label = new Label(this._win, "Close this window to reveal main window again.")
			.setWrapLength(150)
			.pack();

		this._win.addProtocolCommand(WindowProtocol.deleteWindow, delegate(Window window, ProtocolCommandArgs args){
			this._win.destroy();
			this.mainWindow.deiconify();
		});

		this.mainWindow.withdraw();
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		auto frame = new Frame()
			.pack();

		auto button1 = new Button(frame, "Spawn window")
			.setCommand(&this.createWindow)
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
