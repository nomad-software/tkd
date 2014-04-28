module main;

/**
 * Imports.
 */
import std.file;
import tkd.tkdapplication;

/**
 * Sample application.
 */
class Application : TkdApplication
{
	/**
	 * The opened file if any.
	 */
	private string _file;

	/**
	 * The save tool button.
	 */
	private Button _saveToolButton;

	/**
	 * The file menu.
	 */
	private Menu _fileMenu;

	/**
	 * The text widget.
	 */
	private Text _text;

	/**
	 * Exit the application.
	 *
	 * Params:
	 *     args = The command arguments.
	 */
	private void exitApplication(CommandArgs args)
	{
		this.exit();
	}

	/**
	 * Open a file.
	 *
	 * Params:
	 *     args = The command arguments.
	 */
	private void openFile(CommandArgs args)
	{
		auto dialog = new OpenFileDialog("Edit File")
			.setDefaultExtension(".txt")
			.show();

		auto result = dialog.getResult();

		if (result)
		{
			this._file = result;
			auto contents = cast(string)read(this._file);
			this._text.clear();
			this._text.appendText(contents);
		}
	}

	/**
	 * Save the file.
	 *
	 * Params:
	 *     args = The command arguments.
	 */
	private void saveFile(CommandArgs args)
	{
		if (this._file)
		{
			this._file.write(this._text.getText());
			this._fileMenu.disableEntry(1);
			this._saveToolButton.setState([State.disabled]);
		}
	}

	/**
	 * Save the file as.
	 *
	 * Params:
	 *     args = The command arguments.
	 */
	private void saveFileAs(CommandArgs args)
	{
		auto dialog = new SaveFileDialog("Save As")
			.setDefaultExtension(".txt")
			.show();

		auto result = dialog.getResult();

		if (result)
		{
			this._file = result;
			this.saveFile(args);
		}
	}

	/**
	 * Show the about box.
	 */
	private void about(CommandArgs args)
	{
		auto dialog = new MessageDialog("About")
			.setMessage("Editor example")
			.setDetailMessage("A simple text editor created using Tkd.")
			.show();
	}

	/**
	 * Read text from a file and populate the text widget.
	 */
	private void readText()
	{
		if (this._file)
		{
			
		}
	}

	/**
	 * Save the text from the text widget into a file.
	 */
	private void saveText()
	{
		if (this._file)
		{
			
		}
	}

	/**
	 * Set up the key bindings for the application.
	 */
	private void setUpKeyBindings()
	{
		this._text.bind("<KeyPress>", delegate(CommandArgs args){
			this._fileMenu.enableEntry(1);
			this._saveToolButton.removeState([State.disabled]);
		});

		this.mainWindow.bind("<Control-o>", &this.openFile);
		this.mainWindow.bind("<Control-s>", &this.saveFile);
		this.mainWindow.bind("<Control-Shift-S>", &this.saveFileAs);
		this.mainWindow.bind("<Control-q>", &this.exitApplication);
		this.mainWindow.bind("<F1>", &this.about);
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.mainWindow.setTitle("Editor example");
		this.mainWindow.setMinSize(400, 350);

		auto menuBar = new MenuBar(this.mainWindow);

		this._fileMenu = new Menu(menuBar, "File", 0)
			.addEntry(new Png!("folder.png"), "Open...", &this.openFile, ImagePosition.left, "Ctrl-O")
			.addEntry(new Png!("disk.png"), "Save", &this.saveFile, ImagePosition.left, "Ctrl-S")
			.addEntry(new Png!("disk_multiple.png"), "Save As...", &this.saveFileAs, ImagePosition.left, "Shift-Ctrl-S")
			.addSeparator()
			.addEntry(new Png!("cancel.png"), "Quit", &this.exitApplication, ImagePosition.left, "Ctrl-Q")
			.disableEntry(1);

		auto helpMenu = new Menu(menuBar, "Help", 0)
			.addEntry(new Png!("help.png"), "About...", &this.about, ImagePosition.left, "F1");

		auto toolBar = new Frame(this.mainWindow, 1, ReliefStyle.raised)
			.pack(0, 2, GeometrySide.top, GeometryFill.x);

		auto openToolButton = new Button(toolBar, new Png!("folder.png"))
			.setStyle(Style.toolbutton)
			.setCommand(&this.openFile)
			.pack(0, 0, GeometrySide.left);

		this._saveToolButton = new Button(toolBar, new Png!("disk.png"))
			.setStyle(Style.toolbutton)
			.setCommand(&this.saveFile)
			.setState([State.disabled])
			.pack(0, 0, GeometrySide.left);

		auto saveAsToolButton = new Button(toolBar, new Png!("disk_multiple.png"))
			.setStyle(Style.toolbutton)
			.setCommand(&this.saveFileAs)
			.pack(0, 0, GeometrySide.left);

		auto separator1 = new Separator(toolBar, Orientation.vertical)
			.pack(2, 0, GeometrySide.left, GeometryFill.y);

		auto quitToolButton = new Button(toolBar, new Png!("cancel.png"))
			.setStyle(Style.toolbutton)
			.setCommand(&this.exitApplication)
			.pack(0, 0, GeometrySide.left);

		auto separator2 = new Separator(toolBar, Orientation.vertical)
			.pack(2, 0, GeometrySide.left, GeometryFill.y);

		auto aboutToolButton = new Button(toolBar, new Png!("help.png"))
			.setStyle(Style.toolbutton)
			.setCommand(&this.about)
			.pack(0, 0, GeometrySide.left);

		this._text = new Text(this.mainWindow)
			.setWidth(0)
			.setHeight(0)
			.pack(0, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.west, true);

		auto sizeGrip = new SizeGrip(this.mainWindow)
			.pack(0, 0, GeometrySide.bottom, GeometryFill.none, AnchorPosition.southEast);

		this.setUpKeyBindings();
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
