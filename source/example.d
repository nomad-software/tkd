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
	 * Wigets.
	 */
	private TreeView _tree;

	/**
	 * Event callbacks.
	 */
	private void exitCommand(Widget widget, CommandArgs args)
	{
		this.exit();
	}

	private void columnCommand(TreeViewColumn column, ColumnArgs args)
	{
		writefln("Column: %s", column.id);
	}

	/**
	 * Initialise the user interface.
	 */
	override protected void initInterface()
	{
		auto frame = new Frame()
			.pack();

		this._tree = new TreeView(frame)
			.setTreeHeading("Treeview")
			.setTreeHeadingImage(new Png!("thumbnail.png"))
			.setTreeMinimumWidth(125)
			.setTreeStretch(false)
			.setTreeWidth(300)
			.setSelectionMode(TreeViewSelectionMode.none)

			.addColumn(new TreeViewColumn("Name"))
			.addColumn(new TreeViewColumn("Address"))
			.pack();


		auto button = new Button(frame, "Exit")
			.setCommand(&this.exitCommand)
			.pack();
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
