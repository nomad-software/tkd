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
	private Entry _fontEntry;

	/**
	 * Event callbacks.
	 */
	private void fontChooser(CommandArgs args)
	{
		auto dialog = new FontChooser("Choose a font")
			.setCommand(delegate(CommandArgs args){
				this._fontEntry.setValue(args.dialog.font);
			})
			.show();
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.mainWindow.setTitle("Dialog example");

		auto label = new Label("Various dialog boxes are supported.\nClick on the buttons to see various dialogs.")
			.grid(0, 0, 5, 0, 2, 1, "new");

		auto fontChooserButton = new Button("Font Chooser")
			.setCommand(&this.fontChooser)
			.grid(0, 1, 10);

		this._fontEntry = new Entry()
			.grid(1, 1, 10);

		auto separator = new Separator()
			.grid(0, 2, 10, 0, 2, 1, "ew");

		auto quitButton = new Button("Exit")
			.setCommand(delegate(CommandArgs args){this.exit();})
			.grid(0, 3, 10, 0, 2);
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
