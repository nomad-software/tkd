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
	override protected void initWidgets()
	{
		this.root         = new Frame();
		this.button_hello = new Button(this.root, "Hello");
		this.button_exit  = new Button(this.root, "Exit");

		this.button_hello.bind("<Button-1>", delegate(Widget widget, EventArgs args){
			writefln("Hello from %s", widget.id);
		});

		this.button_exit.bind("<Button-1>", delegate(Widget widget, EventArgs args){
			this.exit();
		});

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
