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
	 * Widgets we need access to on the class level.
	 */
	private Entry _fontEntry;
	private Entry _colorEntry;
	private Entry _directoryEntry;
	private Entry _openFileEntry;
	private Entry _saveFileEntry;
	private Entry _messageEntry;
	private Canvas _canvas;

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
		this._openFileEntry.setValue(dialog.getResult());
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
		auto dialog = new MessageDialog()
			.setMessage("Lorem ipsum dolor sit amet.")
			.setDetailMessage("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc at aliquam arcu. Sed eget tellus ligula. Sed egestas est et tempus cursus. Nunc non congue justo, quis adipiscing enim.")
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
	 * Create the widget pane for the note book.
	 *
	 * Returns:
	 *     The widget pane.
	 */
	public Frame createWidgetPane()
	{
		auto widgetPane = new Frame();

		auto entryLabelFrame = new LabelFrame(widgetPane, "Text Entry")
			.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);
			auto entry1 = new Text(entryLabelFrame)
				.setWidth(0)
				.setHeight(3)
				.appendText("Nullam sapien lectus, aliquet sit amet quam et, sagittis porttitor dolor.")
				.pack(5, 0, GeometrySide.bottom, GeometryFill.both, AnchorPosition.northWest, true);
			auto entry2 = new Entry(entryLabelFrame)
				.setValue("Lorem ipsum dolor sit amet.")
				.pack(5, 0, GeometrySide.left, GeometryFill.x, AnchorPosition.northWest, true);
			auto entry3 = new SpinBox(entryLabelFrame)
				.setData(["foo", "bar", "baz", "qux"])
				.setWrap(true)
				.setWidth(5)
				.pack(5, 0, GeometrySide.left);
			auto entry4 = new ComboBox(entryLabelFrame)
				.setData(["Option 1", "Option 2", "Option 3"])
				.setValue("Option 1")
				.pack(5, 0, GeometrySide.left, GeometryFill.x, AnchorPosition.northWest, true);

		auto rangeLabelFrame = new LabelFrame(widgetPane, "Progress & Scale")
			.pack(10, 0, GeometrySide.bottom, GeometryFill.both, AnchorPosition.center);
			auto progressBar = new ProgressBar(rangeLabelFrame)
				.setMaxValue(10)
				.setValue(4)
				.pack(5, 0, GeometrySide.top, GeometryFill.x, AnchorPosition.center, true);
			auto scale = new Scale(rangeLabelFrame)
				.setFromValue(0)
				.setToValue(10)
				.setValue(7)
				.pack(5, 0, GeometrySide.top, GeometryFill.x, AnchorPosition.center, true);

		auto buttonLabelFrame = new LabelFrame(widgetPane, "Buttons")
			.pack(10, 0, GeometrySide.left, GeometryFill.both, AnchorPosition.center, true);
			auto button1 = new Button(buttonLabelFrame, new Png!("thumbnail.png"))
				.pack(5, 0, GeometrySide.left);
			auto button2 = new Button(buttonLabelFrame, "Text button")
				.pack(5);
			auto button3 = new Button(buttonLabelFrame, new Png!("disk.png"), "Image button", ImagePosition.left)
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
	public Frame createPanedPane()
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
					.setTag("computer", new Png!("computer.png"))
					.setTag("folder", new Png!("folder.png"))
					.setTag("file", new Png!("page.png"))
					.setTag("pdf", new Png!("page_white_acrobat.png"))
					.setTag("video", new Png!("film.png"))
					.setTag("image", new Png!("images.png"))
					.setHeading("Directory listing")
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
	public Frame createCanvasPane()
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
					.addItem(new CanvasImage([210, 10], new Png!("thumbnail.png")))
					.addItem(new CanvasImage([260, 10], new Gif!("thumbnail.gif")))
					.addItem(new CanvasLine([120, 110, 200, 110, 200, 160]).setArrowPosition(CanvasLineArrow.last))
					.addItem(new CanvasOval([10, 170, 200, 245], Color.rosyBrown3))
					.addItem(new CanvasPolygon([220, 80, 320, 80, 300, 120, 240, 120], Color.mediumPurple))
					.addItem(new CanvasText([30, 192], "Tkd Canvas", Color.white).setFont("{Arial} 20 bold"))
					.addItem(new CanvasWidget([220, 140], new Button("Embedded\nWidget", new Png!("color_swatch.png"))).setWidth(100).setHeight(100))
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
	public Frame createDialogPane()
	{
		auto dialogPane = new Frame();

			auto modalLabelFrame = new LabelFrame(dialogPane, "Modal")
				.configureGeometryColumn(1, 1)
				.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);

				auto colorButton = new Button(modalLabelFrame, new Png!("color_swatch.png"), "Color", ImagePosition.left)
					.setCommand(&this.openColorDialog)
					.grid(0, 0, 10);

				this._colorEntry = new Entry(modalLabelFrame)
					.grid(1, 0, 10, 0, 1, 1, "ew");

				auto directoryButton = new Button(modalLabelFrame, new Png!("chart_organisation.png"), "Directory", ImagePosition.left)
					.setCommand(&this.openDirectoryDialog)
					.grid(0, 1, 10);

				this._directoryEntry = new Entry(modalLabelFrame, )
					.setWidth(40)
					.grid(1, 1, 10, 0, 1, 1, "ew");

				auto fileOpenButton = new Button(modalLabelFrame, new Png!("folder_page.png"), "Open File", ImagePosition.left)
					.setCommand(&this.openOpenFileDialog)
					.grid(0, 2, 10);

				this._openFileEntry = new Entry(modalLabelFrame, )
					.setWidth(40)
					.grid(1, 2, 10, 0, 1, 1, "ew");

				auto fileSaveButton = new Button(modalLabelFrame, new Png!("disk.png"), "Save File", ImagePosition.left)
					.setCommand(&this.openSaveFileDialog)
					.grid(0, 3, 10);

				this._saveFileEntry = new Entry(modalLabelFrame, )
					.setWidth(40)
					.grid(1, 3, 10, 0, 1, 1, "ew");

				auto messageButton = new Button(modalLabelFrame, new Png!("comment.png"), "Message", ImagePosition.left)
					.setCommand(&this.openMessageDialog)
					.grid(0, 4, 10);

				this._messageEntry = new Entry(modalLabelFrame, )
					.setWidth(40)
					.grid(1, 4, 10, 0, 1, 1, "ew");

			auto nonModalLabelFrame = new LabelFrame(dialogPane, "Non Modal")
				.configureGeometryColumn(1, 1)
				.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);

				auto fontButton = new Button(nonModalLabelFrame, new Png!("style.png"), "Font", ImagePosition.left)
					.setCommand(&this.openFontDialog)
					.grid(0, 0, 10);

				this._fontEntry = new Entry(nonModalLabelFrame, )
					.setWidth(40)
					.grid(1, 0, 10, 0, 1, 1, "ew");

		return dialogPane;
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.mainWindow.setTitle("Tkd example");
		this.mainWindow.setMinSize(550, 560);

		auto noteBook   = new NoteBook();
		auto widgetPane = this.createWidgetPane();
		auto panedPane  = this.createPanedPane();
		auto canvasPane = this.createCanvasPane();
		auto dialogPane = this.createDialogPane();

		noteBook
			.addTab("Widgets", widgetPane).setTabImage(0, new Png!("layout_content.png"), ImagePosition.left)
			.addTab("Panes", panedPane).setTabImage(1, new Png!("application_tile_horizontal.png"), ImagePosition.left)
			.addTab("Canvas", canvasPane).setTabImage(2, new Png!("shape_ungroup.png"), ImagePosition.left)
			.addTab("Dialogs", dialogPane).setTabImage(3, new Png!("application_double.png"), ImagePosition.left)
			.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);

		auto exitButton = new Button("Exit")
			.setCommand(&this.exitApplication)
			.pack(5);

		auto sizeGrip = new SizeGrip(this.mainWindow)
			.pack(0, 0, GeometrySide.bottom, GeometryFill.none, AnchorPosition.southEast);
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

// todo
// menubutton.d
// separator.d
// menus
