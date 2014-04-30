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
	private ProgressBar _progressBar;
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
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.mainWindow.setTitle("Tkd example");

		auto noteBook = new NoteBook();

			auto widgetPane = new Frame();

				auto entryLabelFrame = new LabelFrame(widgetPane, "Text Entry")
					.pack(10, 0, GeometrySide.top, GeometryFill.both, AnchorPosition.center, true);
					auto entry1 = new Text(entryLabelFrame)
						.setWidth(0)
						.setHeight(5)
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
					this._progressBar = new ProgressBar(rangeLabelFrame)
						.setMaxValue(10)
						.pack(5, 0, GeometrySide.top, GeometryFill.x, AnchorPosition.center, true);
					auto scale = new Scale(rangeLabelFrame)
						.setFromValue(0)
						.setToValue(10)
						.setCommand(delegate(CommandArgs args){
							auto widget = cast(Scale)args.element;
							this._progressBar.setValue(widget.getValue());
						})
						.pack(5, 0, GeometrySide.top, GeometryFill.x, AnchorPosition.center, true);

				auto buttonLabelFrame = new LabelFrame(widgetPane, "Buttons")
					.pack(10, 0, GeometrySide.left, GeometryFill.both, AnchorPosition.center, true);
					auto button1 = new Button(buttonLabelFrame, new Png!("error.png"))
						.pack(5);
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

			auto panedPane  = new Frame();
			auto canvasPane  = new Frame();

		noteBook.addTab("Widgets", widgetPane).setTabImage(0, new Png!("layout_content.png"), ImagePosition.left)
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
// canvas.d
// treeview.d
// panedwindow.d

// menubutton.d
// scrollbar.d
// separator.d
// menus
