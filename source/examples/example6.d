module main;

/**
 * Imports.
 */
import std.algorithm;
import std.range;
import std.stdio;
import tkd.tkdapplication;

class Application : TkdApplication
{
	/**
	 * Callback for the 'Exit' button.
	 */
	private void exitCommand(CommandArgs args)
	{
		this.exit();
	}

	/**
	 * Initialise the GUI.
	 */
	override protected void initInterface()
	{
		// Create a frame to hold the other widgets.
		auto frame = new Frame(2, ReliefStyle.groove).pack(10);

		// Add a label and button to the frame.
		auto label = new Label(frame, "Hello World!").pack(10);
		auto exitButton = new Button(frame, "Exit").pack(10);

		// Make the button use the callback when pressed.
		exitButton.setCommand(&this.exitCommand);
	}
}

/**
 * Start the application.
 */
void main(string[] args)
{
	auto app = new Application();
	app.run();
}
