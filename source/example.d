module main;

/**
 * Imports.
 */
import std.stdio;
import tkd.tkapplication;

/**
 * Sample application.
 */
class Application : TkApplication
{
	private void button_hello_click(Widget widget, EventArgs args)
	{
		writefln("Hello from %s", widget.id);
	}

	private void button_quit_click(Widget widget, EventArgs args)
	{
		this.exit();
	}

	override protected void initWidgets()
	{
		this.root         = new Frame();
		this.button_hello = new Button(this.root, "Hello");
		this.button_exit  = new Button(this.root, "Exit");

		this.button_hello.bind("<Button-1>", &this.button_hello_click);
		this.button_exit.bind("<Button-1>", &this.button_quit_click);

		this.root.pack();
		this.button_hello.pack();
		this.button_exit.pack();
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
