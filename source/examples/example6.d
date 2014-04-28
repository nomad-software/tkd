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
	private Entry _fontEntry;
	private Entry _colorEntry;
	private Entry _directoryEntry;
	private Entry _openFileEntry;
	private Entry _saveFileEntry;
	private Entry _messageEntry;

	/**
	 * Event callbacks.
	 */
	private void fontChooser(CommandArgs args)
	{
		auto dialog = new FontDialog("Choose a font")
			.setCommand(delegate(CommandArgs args){
				this._fontEntry.setValue(args.dialog.font);
			})
			.show();
	}

	private void colorChooser(CommandArgs args)
	{
		auto dialog = new ColorDialog("Choose a color")
			.setInitialColor(Color.beige)
			.show();
		this._colorEntry.setValue(dialog.getResult());
	}

	private void directoryChooser(CommandArgs args)
	{
		auto dialog = new DirectoryDialog("Choose a directory")
			.setDirectoryMustExist(true)
			.show();
		this._directoryEntry.setValue(dialog.getResult());
	}

	private void openFile(CommandArgs args)
	{
		auto dialog = new OpenFileDialog()
			.setMultiSelection(true)
			.setDefaultExtension(".dmo")
			.addFileType("{{All files} {*}}")
			.addFileType("{{D language files} {.d .di}}")
			.addFileType("{{HTML files} {.htm .html}}")
			.addFileType("{{Text files} {.txt}}")
			.setInitialDirectory("~")
			.setInitialFile("file-to-open.dmo")
			.show();
		this._openFileEntry.setValue(dialog.getResult());
	}

	private void saveFile(CommandArgs args)
	{
		auto dialog = new SaveFileDialog()
			.setConfirmOverwrite(true)
			.setDefaultExtension(".dmo")
			.addFileType("{{All files} {*}}")
			.addFileType("{{D language files} {.d .di}}")
			.addFileType("{{HTML files} {.htm .html}}")
			.addFileType("{{Text files} {.txt}}")
			.setInitialDirectory("~")
			.setInitialFile("file-to-save.dmo")
			.show();
		this._saveFileEntry.setValue(dialog.getResult());
	}

	private void message(CommandArgs args)
	{
		auto dialog = new MessageDialog()
			.setMessage("Lorem ipsum dolor sit amet.")
			.setDetailMessage("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc at aliquam arcu. Sed eget tellus ligula. Sed egestas est et tempus cursus. Nunc non congue justo, quis adipiscing enim.")
			.setType(MessageDialogType.okcancel)
			.show();
		this._messageEntry.setValue(dialog.getResult());
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.mainWindow.setTitle("Dialog example");

		auto label = new Label("Various dialog boxes are supported.\nClick on the buttons to see various dialogs.")
			.grid(0, 0, 10, 0, 2, 1, "new");

		auto fontChooserButton = new Button("Font")
			.setCommand(&this.fontChooser)
			.grid(0, 1, 10, 0, 1, 1, "w");

		this._fontEntry = new Entry()
			.setWidth(40)
			.grid(1, 1, 10, 0, 1, 1, "w");

		auto colorChooserButton = new Button("Color")
			.setCommand(&this.colorChooser)
			.grid(0, 2, 10, 0, 1, 1, "w");

		this._colorEntry = new Entry()
			.setWidth(40)
			.grid(1, 2, 10, 0, 1, 1, "w");

		auto directoryChooserButton = new Button("Directory")
			.setCommand(&this.directoryChooser)
			.grid(0, 3, 10, 0, 1, 1, "w");

		this._directoryEntry = new Entry()
			.setWidth(40)
			.grid(1, 3, 10, 0, 1, 1, "w");

		auto fileOpenButton = new Button("Open File")
			.setCommand(&this.openFile)
			.grid(0, 4, 10, 0, 1, 1, "w");

		this._openFileEntry = new Entry()
			.setWidth(40)
			.grid(1, 4, 10, 0, 1, 1, "w");

		auto fileSaveButton = new Button("Save File")
			.setCommand(&this.saveFile)
			.grid(0, 5, 10, 0, 1, 1, "w");

		this._saveFileEntry = new Entry()
			.setWidth(40)
			.grid(1, 5, 10, 0, 1, 1, "w");

		auto messageButton = new Button("Message")
			.setCommand(&this.message)
			.grid(0, 6, 10, 0, 1, 1, "w");

		this._messageEntry = new Entry()
			.setWidth(40)
			.grid(1, 6, 10, 0, 1, 1, "w");

		auto quitButton = new Button("Exit")
			.setCommand(delegate(CommandArgs args){this.exit();})
			.grid(0, 7, 10, 0, 2);
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
