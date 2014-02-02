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
	private void button_hello_click(UiElement element, EventArgs args)
	{
		string[] words     = ["Mary", "had", "a", "little", "lamb"];
		string currentWord = this.button.hello.getText();
		string nextword    = words.cycle.find(currentWord).dropOne.front;

		this.button.hello.setText(nextword);
	}

	private void button_quit_click(UiElement element, EventArgs args)
	{
		this.exit();
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.frame.root   = new Frame();
		this.button.hello = new Button(this.frame.root, "Mary");
		this.button.exit  = new Button(this.frame.root, "Exit");

		this.button.hello.bind("<Button-1>", &this.button_hello_click);
		this.button.hello.addImage(new PngImage("../media/48px/png.png"), ImagePosition.top);
		this.button.hello.underlineChar(0);

		this.button.exit.bind("<Button-1>", &this.button_quit_click);

		this.frame.root.pack();
		this.button.hello.pack();
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
