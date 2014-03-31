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
	private Menu _fileMenu;

	/**
	 * Event callbacks.
	 */
	private void exitCommand(CommandArgs args)
	{
		this.exit();
	}

	private void popupMenu(CommandArgs args)
	{
		this._fileMenu.popup((cast(UiElement)args.element).getCursorXPos(), (cast(UiElement)args.element).getCursorYPos());
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
		this.mainWindow.bind("<Button-3>", &this.popupMenu);

		auto menubar = new MenuBar(this.mainWindow);

		auto cascadeMenu = new Menu()
			.addEntry("Cascade entry 1", &this.execute)
			.addEntry("Cascade entry 2", &this.execute)
			.addEntry("Cascade entry 3", &this.execute);

		this._fileMenu = new Menu(menubar, "File", 0)
			.addEntry("Open...", &this.execute, "Ctrl+O")
			.addEntry("Save...", &this.execute)
			.addSeparator()
			.addCheckButtonEntry("Check", &this.execute)
			.addSeparator()
			.addRadioButtonEntry("Option 1", &this.execute)
			.addRadioButtonEntry("Option 2", &this.execute)
			.addRadioButtonEntry("Option 3", &this.execute)
			.addSeparator()
			.addMenuEntry("Cascade menu", cascadeMenu)
			.addSeparator()
			.addEntry("Quit", &this.exitCommand, "Ctrl-Q");

		auto helpMenu = new Menu(menubar, "Help", 0)
			.addEntry("About...", &this.execute)
			.addMenuEntry("Cascade menu", this._fileMenu);

		auto frame = new Frame(2, ReliefStyle.groove)
			.pack();

		auto menubutton = new MenuButton(frame, "Menu button", this._fileMenu)
			.setImage(new Png!("page.png"), ImagePosition.left)
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
