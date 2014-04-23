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
	private void exitCommand(CommandArgs args)
	{
		this.exit();
	}

	override protected void initInterface()
	{
		auto frame = new Frame(2, ReliefStyle.groove)
			.pack(10);

		auto label = new Label(frame, "Hello World!")
			.pack(10);

		auto exitButton = new Button(frame, "Exit")
			.setCommand(&this.exitCommand)
			.pack(10);
	}
}

void main(string[] args)
{
	auto app = new Application();
	app.run();
}
