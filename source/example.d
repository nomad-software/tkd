module main;

/**
 * Imports.
 */
import std.stdio;
import tkd.element.widget.button;
import tkd.element.widget.frame;
import tkd.tkapplication;

/**
 * Sample application.
 */
class Application : TkApplication
{
	/**
	 * Event callbacks.
	 */
	private void button_hello_click(Element element, EventArgs args)
	{
		this.button.hello.setText("World");
	}

	private void button_quit_click(Element element, EventArgs args)
	{
		this.exit();
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		this.frame.root   = new Frame();
		this.button.hello = new Button(this.frame.root, "Hello");
		this.button.exit  = new Button(this.frame.root, "Exit");

		// This is not the correct way to add a command to a button
		// as this binding endures after the widget is disabled.
		this.button.hello.bind("<Button-1>", &this.button_hello_click);
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
