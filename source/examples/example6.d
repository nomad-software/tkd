module main;

/**
 * Imports.
 */
import std.algorithm;
import std.range;
import std.stdio;
import tkd.tkdapplication;

class Application : TkdApplication                    // Extend TkdApplication.
{
	private void exitCommand(CommandArgs args)        // Create a callback for the button.
	{
		this.exit();                                  // Exit the application.
	}

	override protected void initInterface()           // Initialise the user interface.
	{
		auto frame = new Frame(2, ReliefStyle.groove) // Create a frame.
			.pack(10);                                // Place the widget with padding.

		auto label = new Label(frame, "Hello World!") // Create a label.
			.pack(10);                                // Place the widget with padding.

		auto exitButton = new Button(frame, "Exit")   // Create a button.
			.setCommand(&this.exitCommand);           // Use the callback when pressed.
			.pack(10);                                // Place the widget with padding.
	}
}

void main(string[] args)
{
	auto app = new Application();                     // Create the application.
	app.run();                                        // Run the application.
}
