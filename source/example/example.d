module main;

/**
 * Imports.
 */
import std.algorithm;
import std.array;
import std.datetime;
import std.file;
import tkd.tkdapplication;

/**
 * Sample application.
 */
class Application : TkdApplication
{
	/**
	 * Widgets we need access to on the class level.
	 */
	private Entry _entry;
	private ProgressBar _progressBar;
	private Canvas _canvas;
	private Entry _fontEntry;
	private Entry _colorEntry;
	private Entry _directoryEntry;
	private Entry _openFileEntry;
	private Entry _saveFileEntry;
	private Entry _messageEntry;

	/**
	 * Open the font dialog.
	 *
	 * Params:
	 *     args = The callback args.
	 */
	private void openFontDialog(CommandArgs args)
	{
		auto dialog = new FontDialog("Choose a font")
			.setCommand(delegate(CommandArgs args){
				this._fontEntry.setValue(args.dialog.font);
			})
			.show();
	}

	/**
	 * Open the color dialog.
	 *
	 * Params:
	 *     args = The callback args.
	 */
	private void openColorDialog(CommandArgs args)
	{
		auto dialog = new ColorDialog("Choose a color")
			.setInitialColor(Color.beige)
			.show();
		this._colorEntry.setValue(dialog.getResult());
	}

	/**
	 * Open the directory dialog.
	 *
	 * Params:
	 *     args = The callback args.
	 */
	private void openDirectoryDialog(CommandArgs args)
	{
		auto dialog = new DirectoryDialog("Choose a directory")
			.setDirectoryMustExist(true)
			.show();
		this._directoryEntry.setValue(dialog.getResult());
	}

	/**
	 * Open the open file dialog.
	 *
	 * Params:
	 *     args = The callback args.
	 */
	private void openOpenFileDialog(CommandArgs args)
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
		this._openFileEntry.setValue(dialog.getResults().join(" "));
	}

	/**
	 * Open the save file dialog.
	 *
	 * Params:
	 *     args = The callback args.
	 */
	private void openSaveFileDialog(CommandArgs args)
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

	/**
	 * Open the message dialog.
	 *
	 * Params:
	 *     args = The callback args.
	 */
	private void openMessageDialog(CommandArgs args)
	{
		auto dialog = new MessageDialog(this.mainWindow)
			.setMessage("Lorem ipsum dolor sit amet.")
			.setDetailMessage("Nunc at aliquam arcu. Sed eget tellus ligula.\nSed egestas est et tempus cursus.")
			.setType(MessageDialogType.okcancel)
			.show();
		this._messageEntry.setValue(dialog.getResult());
	}

	/**
	 * Mark a point in the canvas to drag from.
	 *
	 * Params:
	 *     args = The callback args.
	 */
	private void mark(CommandArgs args)
	{
		this._canvas.setScanMark(args.event.x, args.event.y);
	}

	/**
	 * Drag the canvas to reposition the contents.
	 *
	 * Params:
	 *     args = The callback args.
	 */
	private void drag(CommandArgs args)
	{
		this._canvas.scanDragTo(args.event.x, args.event.y);
	}

	/**
	 * Show the about box.
	 */
	private void showAbout(CommandArgs args)
	{
		auto dialog = new MessageDialog(this.mainWindow, "About")
			.setMessage("Tkd Showcase")
			.setDetailMessage("A showcase Tkd application demonstrating menus, widgets and dialogs.\n\nThe possiblities are endless.")
			.show();
	}

	/**
	 * Create the menu.
	 */
	private void createMenu()
	{
		auto menuBar = new MenuBar(this.mainWindow);

		auto checkButtonSubMenu = new Menu()
			.addCheckButtonEntry("Option 1", delegate(CommandArgs args){})
			.addCheckButtonEntry("Option 2", delegate(CommandArgs args){})
			.addCheckButtonEntry("Option 3", delegate(CommandArgs args){});

		auto radioButtonSubMenu = new Menu()
			.addRadioButtonEntry("Option 1", delegate(CommandArgs args){})
			.addRadioButtonEntry("Option 2", delegate(CommandArgs args){})
			.addRadioButtonEntry("Option 3", delegate(CommandArgs args){});

		auto fileMenu = new Menu(menuBar, "File", 0)
			.addMenuEntry("Checkbutton submenu", checkButtonSubMenu)
			.addMenuEntry("Radiobutton submenu", radioButtonSubMenu)
			.addSeparator()
			.addEntry(new EmbeddedPng!("cancel.png"), "Quit", &this.exitApplication, ImagePosition.left, "Ctrl-Q");

		auto helpMenu = new Menu(menuBar, "Help", 0)
			.addEntry(new EmbeddedPng!("help.png"), "About...", &this.showAbout, ImagePosition.left, "F1");
	}

	/**
	 * Create the widget pane for the note book.
	 *
	 * Returns:
	 *     The widget pane.
	 */
	private Frame createWidgetPane()
	{
		auto widgetPane = new Frame();

		auto entryLabelFrame = new LabelFrame(widgetPane, "Text Entry")
			.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);
			auto entry1 = new Text(entryLabelFrame)
				.setWidth(0)
				.setHeight(3)
				.appendText("import std.stdio;\n\nvoid main(string[] args)\n{\n\twriteln(\"Hello World!\");\n}")
				.pack(5, 0, GeometrySide.bottom, GeometryFill.both, AnchorPosition.northWest, true);
			this._entry = new Entry(entryLabelFrame)
				.pack(5, 0, GeometrySide.left, GeometryFill.x, AnchorPosition.northWest, true);
			auto entry3 = new SpinBox(entryLabelFrame)
				.setData(["$foo", "[bar]", "\"baz\"", "{qux}"])
				.setWrap(true)
				.setWidth(5)
				.pack(5, 0, GeometrySide.left);
			auto entry4 = new ComboBox(entryLabelFrame)
				.setData(["Option 1", "Option 2", "Option 3"])
				.setValue("Option 1")
				.pack(5, 0, GeometrySide.left, GeometryFill.x, AnchorPosition.northWest, true);

		auto rangeLabelFrame = new LabelFrame(widgetPane, "Progress & Scale")
			.pack(10, 0, GeometrySide.bottom, GeometryFill.both, AnchorPosition.center);
			this._progressBar = new ProgressBar(rangeLabelFrame)
				.setMaxValue(10)
				.setValue(4)
				.pack(5, 0, GeometrySide.top, GeometryFill.x, AnchorPosition.center, true);
			auto scale = new Scale(rangeLabelFrame)
				.setFromValue(10)
				.setToValue(0)
				.setCommand(delegate(CommandArgs args){
					auto scale = cast(Scale)args.element;
					this._progressBar.setValue(scale.getValue());
				})
				.setValue(4)
				.pack(5, 0, GeometrySide.top, GeometryFill.x, AnchorPosition.center, true);

		auto buttonLabelFrame = new LabelFrame(widgetPane, "Buttons")
			.pack(10, 0, GeometrySide.left, GeometryFill.both, AnchorPosition.center, true);
			auto button1 = new Button(buttonLabelFrame, "Text button")
				.pack(5);
			auto button2 = new Button(buttonLabelFrame, new EmbeddedPng!("thumbnail.png"), "Image button", ImagePosition.left)
				.pack(5);
			auto buttonMenu = new Menu()
				.addEntry("Option 1", delegate(CommandArgs args){})
				.addEntry("Option 2", delegate(CommandArgs args){})
				.addEntry("Option 3", delegate(CommandArgs args){});
			auto button3 = new MenuButton(buttonLabelFrame, "Menu button", buttonMenu)
				.pack(5);

		auto checkBoxLabelFrame = new LabelFrame(widgetPane, "Check buttons")
			.pack(10, 0, GeometrySide.left, GeometryFill.both, AnchorPosition.center, true);
			auto checkButton1 = new CheckButton(checkBoxLabelFrame, "Option 1")
				.check()
				.pack(5);
			auto checkButton2 = new CheckButton(checkBoxLabelFrame, "Option 2")
				.pack(5);
			auto checkButton3 = new CheckButton(checkBoxLabelFrame, "Option 3")
				.pack(5);

		auto radioLabelFrame = new LabelFrame(widgetPane, "Radio buttons")
			.pack(10, 0, GeometrySide.left, GeometryFill.both, AnchorPosition.center, true);
			auto radioButton1 = new RadioButton(radioLabelFrame, "Option 1")
				.setSelectedValue("1")
				.select()
				.pack(5);
			auto radioButton2 = new RadioButton(radioLabelFrame, "Option 2")
				.setSelectedValue("2")
				.pack(5);
			auto radioButton3 = new RadioButton(radioLabelFrame, "Option 3")
				.setSelectedValue("3")
				.pack(5);

		return widgetPane;
	}

	/**
	 * Create the paned pane for the note book.
	 *
	 * Returns:
	 *     The paned pane.
	 */
	private Frame createPanedPane()
	{
		auto panedPane = new Frame();

			auto panedWindow = new PanedWindow(panedPane);

				auto rows = new TreeViewRow(["Computer"], true, ["computer"]);
				rows.children ~= new TreeViewRow(["Documents"], true, ["folder"]);
					rows.children[0].children ~= new TreeViewRow(["Important notes.txt"], true, ["file"]);
					rows.children[0].children ~= new TreeViewRow(["The D Programming Language.pdf"], true, ["pdf"]);
				rows.children ~= new TreeViewRow(["Pictures"], true, ["folder"]);
					rows.children[1].children ~= new TreeViewRow(["Gary and Tessa.jpg"], true, ["image"]);
				rows.children ~= new TreeViewRow(["Videos"], true, ["folder"]);
					rows.children[2].children ~= new TreeViewRow(["Carlito's Way (1993).mpg"], true, ["video"]);
					rows.children[2].children ~= new TreeViewRow(["Aliens (1986).mpg"], true, ["video"]);

				auto tree1 = new TreeView(panedWindow)
					.setHeading("Directory listing")
					.setTag("computer", new EmbeddedPng!("computer.png"))
					.setTag("folder", new EmbeddedPng!("folder.png"))
					.setTag("file", new EmbeddedPng!("page.png"))
					.setTag("pdf", new EmbeddedPng!("page_white_acrobat.png"))
					.setTag("video", new EmbeddedPng!("film.png"))
					.setTag("image", new EmbeddedPng!("images.png"))
					.addRow(rows);

				auto tree2 = new TreeView(panedWindow)
					.setHeading("Film")
					.setWidth(250)
					.addColumn(new TreeViewColumn("Year").setWidth(20))
					.addColumn(new TreeViewColumn("IMDB ranking").setWidth(50))
					.addRow(new TreeViewRow(["The Shawshank Redemption", "1994", "1"]))
					.addRow(new TreeViewRow(["The Godfather", "1972", "2"]))
					.addRow(new TreeViewRow(["The Godfather: Part II", "1974", "3"]))
					.addRow(new TreeViewRow(["The Dark Knight", "2008", "4"]))
					.addRow(new TreeViewRow(["Pulp Fiction", "1994", "5"]))
					.addRow(new TreeViewRow(["The Good, the Bad and the Ugly", "1966", "6"]))
					.addRow(new TreeViewRow(["Schindler's List", "1993", "7"]))
					.addRow(new TreeViewRow(["Angry Men", "1957", "8"]))
					.addRow(new TreeViewRow(["The Lord of the Rings: The Return of the King", "2003", "9"]))
					.addRow(new TreeViewRow(["Fight Club", "1999", "10"]));

		panedWindow
			.addPane(tree1).setPaneWeight(0, 1)
			.addPane(tree2).setPaneWeight(1, 1)
			.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);

		return panedPane;
	}

	/**
	 * Create the canvas pane for the note book.
	 *
	 * Returns:
	 *     The canvas pane.
	 */
	private Frame createCanvasPane()
	{
		auto canvasPane = new Frame();

			auto container = new Frame(canvasPane)
				.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);

			container.configureGeometryColumn(0, 1);
			container.configureGeometryRow(0, 1);

				this._canvas = new Canvas(container, Color.bisque)
					.setCursor(Cursor.hand1)
					.setScrollRegion(-300, -250, 610, 500)
					.addItem(new CanvasRectangle([10, 10, 200, 100]).addTag("tagged"))
					.addItem(new CanvasArc([10, 110, 110, 210], CanvasArcStyle.pie, Color.paleGreen))
					.addItem(new CanvasImage([210, 10], new EmbeddedPng!("thumbnail.png")))
					.addItem(new CanvasImage([260, 10], new EmbeddedGif!("thumbnail.gif")))
					.addItem(new CanvasLine([120, 110, 200, 110, 200, 160]).setArrowPosition(CanvasLineArrow.last))
					.addItem(new CanvasOval([10, 170, 200, 245], Color.rosyBrown3))
					.addItem(new CanvasPolygon([220, 80, 320, 80, 300, 120, 240, 120], Color.mediumPurple))
					.addItem(new CanvasText([30, 192], "Tkd Canvas", Color.white).setFont("{Times New Roman} 22 bold"))
					.addItem(new CanvasWidget([220, 140], new Button("Embedded\nWidget", new EmbeddedPng!("error.png"))).setWidth(100).setHeight(100))
					.addTagConfig(new CanvasTagConfig("tagged").setFillColor(Color.salmon))
					.setXView(0.25)
					.setYView(0.24)
					.bind("<ButtonPress-1>", &this.mark)
					.bind("<B1-Motion>", &this.drag);

				auto xscroll = new XScrollBar(container)
					.attachWidget(this._canvas)
					.grid(0, 1, 0, 0, 1, 1, "esw");

				auto yscroll = new YScrollBar(container)
					.attachWidget(this._canvas)
					.grid(1, 0, 0, 0, 1, 1, "nes");

				this._canvas
					.attachXScrollBar(xscroll)
					.attachYScrollBar(yscroll)
					.grid(0, 0, 0, 0, 1, 1, "nesw");

		return canvasPane;
	}

	/**
	 * Create the dialog pane for the note book.
	 *
	 * Returns:
	 *     The dialog pane.
	 */
	private Frame createDialogPane()
	{
		auto dialogPane = new Frame();

			auto modalLabelFrame = new LabelFrame(dialogPane, "Modal")
				.configureGeometryColumn(1, 1)
				.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);

				auto colorButton = new Button(modalLabelFrame, new EmbeddedPng!("color_swatch.png"), "Color", ImagePosition.left)
					.setCommand(&this.openColorDialog)
					.grid(0, 0, 10);

				this._colorEntry = new Entry(modalLabelFrame)
					.grid(1, 0, 10, 0, 1, 1, "ew");

				auto directoryButton = new Button(modalLabelFrame, new EmbeddedPng!("chart_organisation.png"), "Directory", ImagePosition.left)
					.setCommand(&this.openDirectoryDialog)
					.grid(0, 1, 10);

				this._directoryEntry = new Entry(modalLabelFrame)
					.setWidth(40)
					.grid(1, 1, 10, 0, 1, 1, "ew");

				auto fileOpenButton = new Button(modalLabelFrame, new EmbeddedPng!("folder_page.png"), "Open File", ImagePosition.left)
					.setCommand(&this.openOpenFileDialog)
					.grid(0, 2, 10);

				this._openFileEntry = new Entry(modalLabelFrame)
					.setWidth(40)
					.grid(1, 2, 10, 0, 1, 1, "ew");

				auto fileSaveButton = new Button(modalLabelFrame, new EmbeddedPng!("disk.png"), "Save File", ImagePosition.left)
					.setCommand(&this.openSaveFileDialog)
					.grid(0, 3, 10);

				this._saveFileEntry = new Entry(modalLabelFrame)
					.setWidth(40)
					.grid(1, 3, 10, 0, 1, 1, "ew");

				auto messageButton = new Button(modalLabelFrame, new EmbeddedPng!("comment.png"), "Message", ImagePosition.left)
					.setCommand(&this.openMessageDialog)
					.grid(0, 4, 10);

				this._messageEntry = new Entry(modalLabelFrame)
					.setWidth(40)
					.grid(1, 4, 10, 0, 1, 1, "ew");

			auto nonModalLabelFrame = new LabelFrame(dialogPane, "Non Modal")
				.configureGeometryColumn(1, 1)
				.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);

				auto fontButton = new Button(nonModalLabelFrame, new EmbeddedPng!("style.png"), "Font", ImagePosition.left)
					.setCommand(&this.openFontDialog)
					.grid(0, 0, 10);

				this._fontEntry = new Entry(nonModalLabelFrame)
					.setWidth(40)
					.grid(1, 0, 10, 0, 1, 1, "ew");

		return dialogPane;
	}

	/**
	 * Set up the key bindings for the application.
	 */
	private void setUpKeyBindings()
	{
		this.mainWindow.bind("<F1>", &this.showAbout);
		this.mainWindow.bind("<Control-q>", &this.exitApplication);
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.mainWindow.setTitle("Tkd Showcase");
		this.mainWindow.setMinSize(550, 560);
		this.mainWindow.setDefaultIcon([new EmbeddedPng!("tkicon.png")]);

		this.mainWindow.setProtocolCommand(WindowProtocol.deleteWindow, delegate(CommandArgs args){
			this.showAbout(args);
			this.exitApplication(args);
		});

		this.mainWindow.setIdleCommand(delegate(CommandArgs args){
			this._entry.setValue(Clock.currTime().toLocalTime().toSimpleString().findSplitBefore(".")[0]);
			this.mainWindow.setIdleCommand(args.callback, 1000);
		});

		this.createMenu();

		auto noteBook   = new NoteBook();
		auto widgetPane = this.createWidgetPane();
		auto panedPane  = this.createPanedPane();
		auto canvasPane = this.createCanvasPane();
		auto dialogPane = this.createDialogPane();

		noteBook
			.addTab("Widgets", widgetPane).setTabImage(0, new EmbeddedPng!("layout_content.png"), ImagePosition.left)
			.addTab("Panes", panedPane).setTabImage(1, new EmbeddedPng!("application_tile_horizontal.png"), ImagePosition.left)
			.addTab("Canvas", canvasPane).setTabImage(2, new EmbeddedPng!("shape_ungroup.png"), ImagePosition.left)
			.addTab("Dialogs", dialogPane).setTabImage(3, new EmbeddedPng!("application_double.png"), ImagePosition.left)
			.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);

		auto exitButton = new Button("Exit")
			.setCommand(&this.exitApplication)
			.pack(5);

		auto sizeGrip = new SizeGrip(this.mainWindow)
			.pack(0, 0, GeometrySide.bottom, GeometryFill.none, AnchorPosition.southEast);

		this.setUpKeyBindings();
	}

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
