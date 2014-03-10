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
	private Button _button;
	private Button _exit;
	private CheckButton _checkbox;
	private ComboBox _combobox;
	private Entry _entry;
	private Frame _rootFrame;
	private Label _label;
	private LabelFrame _labelFrame;
	private NoteBook _noteBook;
	private PanedWindow _panedWindow;
	private ProgressBar _progress;

	/**
	 * Event callbacks.
	 */
	private void manipulateText(Widget widget, CommandArgs args)
	{
		string[] words     = ["Lorem", "ipsum", "dolor", "sit", "amet"];
		string currentWord = this._button.getText();
		string nextword    = words.cycle.find(currentWord).dropOne.front;

		this._button.setText(nextword);
		this._entry.appendText(nextword);
	}

	private void exitCommand(Widget widget, CommandArgs args)
	{
		this.exit();
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this._panedWindow = new PanedWindow();
		this._panedWindow
			.addPane(new Button("Foo"))
			.addPane(new Button("Bar"))
			.pack();

		this._noteBook = new NoteBook();
		this._noteBook
			.addTab("Hello", new Button("Lorem"))
			.addTab("World", new Label("content"))
			.pack();

		this._rootFrame = new Frame()
			.pack();

		this._labelFrame = new LabelFrame(this._rootFrame, "Label frame")
			.pack();

		this._button = new Button(this._labelFrame, "Lorem")
			.setImage(new Png!("thumbnail.png"))
			.setImagePosition(ImagePosition.top)
			.setCommand(&this.manipulateText)
			.pack();

		XScrollBar scroll = new XScrollBar(this._labelFrame);

		this._entry = new Entry(this._labelFrame)
			.setValue("Lorem")
			.attachXScrollBar(scroll)
			.pack();

		scroll.attachWidget(this._entry)
			.pack();

		this._label = new Label(this._rootFrame, "Label")
			.setImage(new Gif!("thumbnail.gif"))
			.setImagePosition(ImagePosition.top)
			.pack();

		this._combobox = new ComboBox(this._rootFrame)
			.setValues(["Lorem", "ipsum", "dolor", "sit", "amet"])
			.select(0)
			.pack();

		this._checkbox = new CheckButton(this._rootFrame, "Check button")
			.pack();

		this._progress = new ProgressBar(this._rootFrame)
			.pack();

		this._exit = new Button(this._rootFrame, "Exit")
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
