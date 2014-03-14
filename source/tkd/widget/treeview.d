/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.treeview;

/**
 * Imports.
 */
import std.algorithm;
import std.string;
import tcltk.tk;
import tkd.element.element;
import tkd.element.uielement;
import tkd.image.image;
import tkd.widget.anchorposition;
import tkd.widget.common.height;
import tkd.widget.common.padding;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.yscrollcommand;
import tkd.widget.widget;

/**
 * The treeview widget displays a hierarchical collection of items. Each item 
 * has a textual label, an optional image, and an optional list of data values. 
 *
 * There are two varieties of columns. The first is the main tree view column 
 * that is present all the time. The second are data columns that can be added 
 * when needed.
 *
 * Each tree item has a list of tags, which can be used to associate event 
 * bindings and control their appearance. Treeview widgets support horizontal 
 * and vertical scrolling with the standard scroll commands.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/padding.html, Padding) $(BR)
 *         $(LINK2 ./common/xscrollcommand.html, XScrollCommand) $(BR)
 *         $(LINK2 ./common/yscrollcommand.html, YScrollCommand) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;&lt;TreeviewClose&gt;&gt;
 *         &lt;&lt;TreeviewOpen&gt;&gt;
 *         &lt;&lt;TreeviewSelect&gt;&gt;
 *         &lt;Alt-Key&gt;,
 *         &lt;B1-Leave&gt;,
 *         &lt;B1-Motion&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;Button-4&gt;,
 *         &lt;Button-5&gt;,
 *         &lt;ButtonRelease-1&gt;,
 *         &lt;Control-Button-1&gt;,
 *         &lt;Double-Button-1&gt;,
 *         &lt;Key-Down&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Left&gt;,
 *         &lt;Key-Next&gt;,
 *         &lt;Key-Prior&gt;,
 *         &lt;Key-Return&gt;,
 *         &lt;Key-Right&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-Up&gt;,
 *         &lt;Key-space&gt;,
 *         &lt;Leave&gt;,
 *         &lt;Motion&gt;,
 *         &lt;Shift-Button-1&gt;,
 *         &lt;Shift-Button-4&gt;,
 *         &lt;Shift-Button-5&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class TreeView : Widget, IXScrollable!(TreeView), IYScrollable!(TreeView)
{
	private TreeViewColumn   _treeColumn;
	private TreeViewColumn[] _dataColumns;

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement) $(BR)
	 */
	this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "treeview";

		this._tk.eval("ttk::treeview %s", this.id);

		this._treeColumn = new TreeViewColumn();
		this._treeColumn._identifier = "#0";
		this._treeColumn.init(this);
	}

	/**
	 * Get the column identifiers of the passed data column indexes.
	 *
	 * Params:
	 *     indexex = The indexes of the data columns.
	 *
	 * Returns:
	 *     A string array containing the columns relating to the indexes.
	 */
	private string[] getColumnIdentifiers(int[] indexes)
	{
		string[] columns;

		for (int x = 0; x < this._dataColumns.length; x++)
		{
			if (indexes.canFind(x))
			{
				columns ~= this._dataColumns[x].id;
			}
		}

		return columns;
	}

	/**
	 * Get all column identifiers.
	 *
	 * Returns:
	 *     A string array containing all column identifiers.
	 */
	private string[] getColumnIdentifiers()
	{
		string[] columns;

		foreach (column; this._dataColumns)
		{
			columns ~= column.id;
		}

		return columns;
	}

	/**
	 * Build the columns found in the data column array.
	 */
	private void buildColumns()
	{
		this._tk.eval("%s configure -columns { \"%s\" }", this.id, this.getColumnIdentifiers().join("\" \""));

		foreach (column; this._dataColumns)
		{
			column.init(this);
		}
	}

	/**
	 * Get the data columns.
	 *
	 * Returns:
	 *     An array containing all the data columns.
	 */
	public @property TreeViewColumn[] dataColumns()
	{
		return this._dataColumns;
	}

	/**
	 * Set the tree view column heading.
	 *
	 * Params:
	 *    title = The title of the column.
	 *    anchor = The anchor position of the text.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./anchorposition.html, tkd.widget.anchorposition) $(BR)
	 */
	public auto setHeading(this T)(string title, string anchor = AnchorPosition.west)
	{
		this._treeColumn.setHeading(title, anchor);

		return cast(T) this;
	}

	/**
	 * Set the tree view column image.
	 *
	 * Params:
	 *    image = The image to use.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setImage(this T)(Image image)
	{
		this._treeColumn.setImage(image);

		return cast(T) this;
	}

	/**
	 * Set the tree view column command to be executed when clicking on the 
	 * heading.
	 *
	 * Params:
	 *    callback = The delegate callback to execute when invoking the command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./treeview.html#ColumnCommandCallback, tkd.widget.ColumnCommandCallback)
	 */
	public auto setCommand(this T)(ColumnCommandCallback callback)
	{
		this._treeColumn.setCommand(callback);

		return cast(T) this;
	}

	/**
	 * Remove the tree view column command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto removeCommand(this T)()
	{
		this._treeColumn.removeCommand();

		return cast(T) this;
	}

	/**
	 * Add a new column to the tree view.
	 *
	 * Params:
	 *     column = The new column to add.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto addColumn(this T)(TreeViewColumn column)
	{
		this._dataColumns ~= column;
		this.buildColumns();

		return cast(T) this;
	}

	/**
	 * Show all data columns in the event some or all are hidden.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto displayAllDataColumns(this T)()
	{
		this._tk.eval("%s configure -displaycolumns #all", this.id);

		return cast(T) this;
	}

	/**
	 * Show the data columns that relate to the indexes passed.
	 *
	 * Params:
	 *     indexes = The indexes of the data columns to show.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto displayDataColumns(this T)(int[] indexes)
	{
		this._tk.eval("%s configure -displaycolumns { \"%s\" }", this.id, this.getColumnIdentifiers(indexes).join("\" \""));

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Height;
	mixin Padding;
	mixin XScrollCommand!(TreeView);
	mixin YScrollCommand!(TreeView);
}

/**
 * A class representing a column in the tree view.
 */
class TreeViewColumn : Element
{
	/**
	 * An optional identifier that overrides the generated id.
	 */
	private string _identifier;

	/**
	 * The parent of this column.
	 */
	private TreeView _parent;

	/**
	 * The title of the heading.
	 */
	private string _title;

	/**
	 * The anchor position of the heading title.
	 */
	private string _anchor;

	/**
	 * The image of the heading.
	 */
	private Image _image;

	/**
	 * The command associated with the heading.
	 */
	private ColumnCommandCallback _commandCallback;

	/**
	 * Construct a new column.
	 *
	 * Params:
	 *     title = The optional title of the heading.
	 *     anchor = The anchor position of the heading title.
	 */
	this(string title = null, string anchor = AnchorPosition.west)
	{
		this._elementId = "column";
		this.setHeading(title, anchor);
	}

	/**
	 * Initialise the column and attach to a parent.
	 *
	 * Params:
	 *     parent = The parent tree view.
	 */
	private void init(TreeView parent)
	{
		this._parent = parent;

		this.setHeading(this._title, this._anchor);
		this.setImage(this._image);
		this.setCommand(this._commandCallback);
	}

	/**
	 * The generated unique id of this element.
	 *
	 * Returns:
	 *     The string id.
	 */
	override public @property string id() nothrow
	{
		if (this._identifier !is null)
		{
			return this._identifier;
		}

		return this._elementId ~ "-" ~ this._hash;
	}

	/**
	 * Set the heading title.
	 *
	 * Params:
	 *    title = The title of the column.
	 *    anchor = The anchor position of the text.
	 *
	 * Returns:
	 *     This column to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./anchorposition.html, tkd.widget.anchorposition) $(BR)
	 */
	public auto setHeading(this T)(string title, string anchor = AnchorPosition.west)
	{
		this._title  = title;
		this._anchor = anchor;

		if (this._parent !is null)
		{
			this._tk.eval("%s heading \"%s\" -text \"%s\" -anchor %s", this._parent.id, this.id, this._title, this._anchor);
		}

		return cast(T) this;
	}

	/**
	 * Set the heading image.
	 *
	 * Params:
	 *    image = The image to use.
	 *
	 * Returns:
	 *     This column to aid method chaining.
	 */
	public auto setImage(this T)(Image image)
	{
		this._image = image;

		if (this._parent !is null && this._image !is null)
		{
			this._tk.eval("%s heading \"%s\" -text \"%s\" -anchor %s -image %s", this._parent.id, this.id, this._title, this._anchor, image.id);
		}

		return cast(T) this;
	}

	/**
	 * Set the column command to be executed when clicking on the heading.
	 *
	 * Params:
	 *    callback = The delegate callback to execute when invoking the command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./treeview.html#ColumnCommandCallback, tkd.widget.ColumnCommandCallback)
	 */
	public auto setCommand(this T)(ColumnCommandCallback callback)
	{
		this._commandCallback = callback;

		if (this._parent !is null && this._commandCallback !is null)
		{
			this.removeCommand();

			Tcl_CmdProc commandCallbackHandler = function(ClientData data, Tcl_Interp* tclInterpreter, int argc, const(char)** argv)
			{
				ColumnArgs args = *cast(ColumnArgs*)data;

				try
				{
					args.callback(args.column, args);
				}
				catch (Throwable ex)
				{
					string error = "Error occurred in column command callback. ";
					error ~= ex.msg ~ "\n";
					error ~= "Column: " ~ args.column.id ~ "\n";

					Tcl_SetResult(tclInterpreter, error.toStringz, TCL_STATIC);
					return TCL_ERROR;
				}

				return TCL_OK;
			};

			Tcl_CmdDeleteProc deleteCallbackHandler = function(ClientData data)
			{
				free(data);
			};

			ColumnArgs* args = cast(ColumnArgs*)malloc(ColumnArgs.sizeof);

			(*args).column   = this;
			(*args).callback = callback;

			string command  = format("command-%s", this.generateHash("command%s%s", this._parent.id, this.id));
			string tkScript = format("%s heading \"%s\" -command %s", this._parent.id, this.id, command);

			this._tk.createCommand(command, commandCallbackHandler, args, deleteCallbackHandler);
			this._tk.eval(tkScript);
		}

		return cast(T) this;
	}

	/**
	 * Remove the column command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto removeCommand(this T)()
	{
		if (this._parent !is null && this._commandCallback !is null)
		{
			string command  = format("command-%s", this.generateHash("command%s%s", this._parent.id, this.id));
			string tkScript = format("%s heading \"%s\" -command { }", this._parent.id, this.id);

			this._tk.deleteCommand(command);
			this._tk.eval(tkScript);
		}

		return cast(T) this;
	}
}

/**
 * Alias representing a column command callback.
 */
alias void delegate(TreeViewColumn column, ColumnArgs args) ColumnCommandCallback;

/**
 * The ColumnArgs struct passed to the ColumnCommandCallback on invocation.
 */
struct ColumnArgs
{
	/**
	 * The widget that issued the command.
	 */
	TreeViewColumn column;

	/**
	 * The callback which was invoked as the command.
	 */
	ColumnCommandCallback callback;
}
