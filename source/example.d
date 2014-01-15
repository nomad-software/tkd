module main;

/**
 * Imports.
 */
import std.stdio;
import tkd.tkapplication;
import tkd.element.widget.cursor;

/**
 * Sample application.
 */
class Application : TkApplication
{
	/**
	 * Interface members.
	 */
	private Frame  root;
	private Button button_hello;
	private Button button_exit;

	/**
	 * Event callbacks.
	 */
	private void button_hello_click(Element element, EventArgs args)
	{
		writefln("Hello from %s", element.id);
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
		this.root         = new Frame();
		this.button_hello = new Button(this.root, "Hello");
		this.button_exit  = new Button(this.root, "Exit");

		this.button_hello.bind("<Button-1>", &this.button_hello_click);
		this.button_exit.bind("<Button-1>", &this.button_quit_click);

		this.root.pack();
		this.button_hello.pack();
		this.button_exit.pack();

import std.stdio;
writefln("%s", this.button_hello.getClass());
writefln("%s", this.button_hello.getCursor());
writefln("%s", this.button_hello.canFocus());
writefln("%s", this.button_hello.getStyle());

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
