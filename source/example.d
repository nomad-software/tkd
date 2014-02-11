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
		string[] words     = ["Mary", "had", "a", "little", "lamb"];
		string currentWord = this.button.hello.getText();
		string nextword    = words.cycle.find(currentWord).dropOne.front;

		this.button.hello.setText(nextword);
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
		this.frame.root        = new Frame();
		this.button.hello      = new Button(this.frame.root, "Mary", new Png!("thumbnail.png"));
		this.button.exit       = new Button(this.frame.root, "Exit");
		this.checkbutton.check = new CheckButton(this.frame.root, "Check");

		this.button.hello.setCommand(&this.button_hello_command);
		this.button.exit.setCommand(&this.button_quit_command);

		this.frame.root.pack();
		this.button.hello.pack();
		this.button.exit.pack();
		this.checkbutton.check.pack();
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
