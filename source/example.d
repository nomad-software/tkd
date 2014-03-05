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
		this._noteBook = new NoteBook();

		auto x = new Label("content");
		this._noteBook
			.addTab("Hello", new Button("Lorem"))
			.addTab("World", x)
			.pack();

		// this._rootFrame = new Frame();

		// 	this._labelFrame = new LabelFrame(this._rootFrame, "Label frame");

		// 		this._button = new Button(this._labelFrame, "Lorem", new Png!("thumbnail.png"));
		// 		this._button.setCommand(&this.manipulateText);
		// 		this._button.pack();

		// 		this._entry = new Entry(this._labelFrame);
		// 		this._entry.setValue("Lorem");
		// 		this._entry.pack();

		// 	this._labelFrame.pack();

		// 	this._label = new Label(this._rootFrame, "Label");
		// 	this._label.setImage(new Gif!("thumbnail.gif"), ImagePosition.top);
		// 	this._label.pack();

		// 	this._combobox = new ComboBox(this._rootFrame);
		// 	this._combobox.setValues(["Lorem", "ipsum", "dolor", "sit", "amet"]);
		// 	this._combobox.select(0);
		// 	this._combobox.pack();

		// 	this._checkbox = new CheckButton(this._rootFrame, "Check button");
		// 	this._checkbox.pack();

		// 	this._exit = new Button(this._rootFrame, "Exit");
		// 	this._exit.setCommand(&this.exitCommand);
		// 	this._exit.pack();

		// this._rootFrame.pack();
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
