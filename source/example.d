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

	private void getSelection(Widget widget, CommandArgs args)
	{
		writefln("%s", this._tree.getSelectedRows());
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
			.addColumn(new TreeViewColumn("Name"))
			.addColumn(new TreeViewColumn("Address"))
			.setTag("folder", new Png!("folder.png"))
			.setTag("file", new Png!("page.png"))
			.pack();

		TreeViewRow[] rows;

		rows ~= new TreeViewRow("Row1", ["Lorem ipsum", "dolor sit"], true, ["folder"]);
		rows[0].children ~= new TreeViewRow("Row2", ["Hello", "World"], true, ["file"]);

		this._tree.addRows(rows);

		auto button1 = new Button(frame, "Get Selection")
			.setCommand(&this.getSelection)
			.pack();

		auto button2 = new Button(frame, "Exit")
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
