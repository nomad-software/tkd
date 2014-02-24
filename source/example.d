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
	 * Event callbacks.
	 */
	private void button_hello_command(Widget widget, CommandArgs args)
	{
		string[] words     = ["Lorem", "ipsum", "dolor", "sit", "amet"];
		string currentWord = this.button.hello.getText();
		string nextword    = words.cycle.find(currentWord).dropOne.front;

		this.button.hello.setText(nextword);
		this.entry.text.appendText(nextword);
	}

	private void button_quit_command(Widget widget, CommandArgs args)
	{
		this.exit();
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.frame.root = new Frame();

		this.button.hello = new Button(this.frame.root, "Lorem", new Png!("thumbnail.png"));
		this.button.hello.setCommand(&this.button_hello_command);

		this.button.exit = new Button(this.frame.root, "Exit");
		this.button.exit.setCommand(&this.button_quit_command);

		this.label.text = new Label(this.frame.root, "Lorem ipsum dolor sit amet.");
		this.label.text.setImage(new Gif!("thumbnail.gif"), ImagePosition.top);

		this.entry.text = new Entry(this.frame.root);
		this.entry.text.setValue("Lorem");

		this.combobox.select = new ComboBox(this.frame.root);
		this.combobox.select.setValues(["Lorem", "ipsum", "dolor", "sit", "amet"]);
		this.combobox.select.select(0);

		this.checkbutton.check = new CheckButton(this.frame.root, "Check");

		this.frame.root.pack();
		this.button.hello.pack();
		this.label.text.pack();
		this.entry.text.pack();
		this.checkbutton.check.pack();
		this.combobox.select.pack();
		this.button.exit.pack();
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
