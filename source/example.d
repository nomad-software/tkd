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
	private void exitCommand(CommandArgs args)
	{
		this.exit();
	}

	private void execute(CommandArgs args)
	{
		writeln("Menu item selected.");
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.mainWindow.bind("<Control-o>", &this.execute);
		this.mainWindow.bind("<Control-q>", &this.exitCommand);

		auto menubar = new MenuBar(this.mainWindow);

		auto fileMenu = new Menu(menubar, "File", 0)
			.addEntry("Open...", &this.execute, "Ctrl+O")
			.addEntry("Save...", &this.execute)
			.addSeparator()
			.addCheckButtonEntry("Check", &this.execute)
			.addSeparator()
			.addRadioButtonEntry("Option 1", &this.execute)
			.addRadioButtonEntry("Option 2", &this.execute)
			.addRadioButtonEntry("Option 3", &this.execute)
			.addSeparator()
			.addEntry("Quit...", &this.exitCommand, "Ctrl-Q");

		auto frame = new Frame()
			.pack();

		auto button = new Button(frame, "Exit")
			.setCommand(&this.exitCommand)
			.bind("<Enter>", &this.exitCommand)
			.unbind("<Enter>")
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
