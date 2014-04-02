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
import std.array;
import std.regex;
import std.string;
import tkd.element.element;
import tkd.element.uielement;
import tkd.image.image;
import tkd.widget.anchorposition;
import tkd.widget.color;
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
	/**
	 * An array containing all the columns.
	 */
	private TreeViewColumn[] _columns;

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

		this._tk.eval("ttk::treeview %s -selectmode browse", this.id);

		// Add the treeview column to the column collection.
		this._columns ~= new TreeViewColumn();
		this._columns[0].init(this);
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
	private string[] getDataColumnIdentifiers(int[] indexes)
	{
		string[] columns;

		for (int x = 1; x < this._columns.length; x++)
		{
			if (indexes.canFind(x))
			{
				columns ~= this._columns[x].id;
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
	private string[] getDataColumnIdentifiers()
	{
		string[] columns;

		for (int x = 1; x < this._columns.length; x++)
		{
			columns ~= this._columns[x].id;
		}

		return columns;
	}

	/**
	 * Get the tree view elements that are currently being shown.
	 *
	 * Returns:
	 *     An array cotaining all shown elements.
	 */
	private string[] getShownElements()
	{
		this._tk.eval("%s cget -show", this.id);
		return this._tk.getResult!(string).split();
	}

	/**
	 * Build the columns found in the column array. This is needed because the 
	 * data columns always seem to forget setting if configured piece-meal.
	 */
	private void buildColumns()
	{
		this._tk.eval("%s configure -columns { \"%s\" }", this.id, this.getDataColumnIdentifiers().join("\" \""));

		for (int x = 1; x < this._columns.length; x++)
		{
			this.columns[x].init(this);
		}
	}

	/**
	 * Convenience method to set the tree column heading text.
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
		this._columns[0].setHeading(title, anchor);

		return cast(T) this;
	}

	/**
	 * Convenience method to set the tree column heading image.
	 *
	 * Params:
	 *    image = The image to use.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setHeadingImage(this T)(Image image)
	{
		this._columns[0].setHeadingImage(image);

		return cast(T) this;
	}

	/**
	 * Convenience method to set the tree column command to be executed when 
	 * clicking on the heading.
	 *
	 * Params:
	 *    callback = The delegate callback to execute when invoking the command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/element.html#CommandCallback, tkd.element.element.CommandCallback)
	 */
	public auto setHeadingCommand(this T)(CommandCallback callback)
	{
		this._columns[0].setHeadingCommand(callback);

		return cast(T) this;
	}

	/**
	 * Convenience method to remove the tree view column command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto removeHeadingCommand(this T)()
	{
		this._columns[0].removeHeadingCommand();

		return cast(T) this;
	}

	/**
	 * Convenience method to set the minium width of the tree column.
	 *
	 * Params:
	 *     minWidth = The minimum width in pixels.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setMinWidth(this T)(int minWidth)
	{
		this._columns[0].setMinWidth(minWidth);

		return cast(T) this;
	}

	/**
	 * Convenience method to enable or disable stretching for the tree column. 
	 * This controls how this column react when other columns or the parent 
	 * widget is resized.
	 *
	 * Params:
	 *     stretch = true for enabling stretching, false to disable.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setStretch(this T)(bool stretch)
	{
		this._columns[0].setStretch(stretch);

		return cast(T) this;
	}

	/**
	 * Convenience method to set the width of the tree column.
	 *
	 * Params:
	 *     width = The width in pixels.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setWidth(this T)(int width)
	{
		this._columns[0].setWidth(width);

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
		this._columns ~= column;
		this.buildColumns();

		return cast(T) this;
	}

	/**
	 * Add a row to the tree view.
	 *
	 * Params:
	 *     row = The row to add.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto addRow(this T)(TreeViewRow row)
	{
		this.appendRows("{}", [row]);

		return cast(T) this;
	}

	/**
	 * Add an array of rowr to the tree view.
	 *
	 * Params:
	 *     rows = The rows to add.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto addRows(this T)(TreeViewRow[] rows)
	{
		this.appendRows("{}", rows);

		return cast(T) this;
	}

	/**
	 * This method does the actualy work of adding rows to the tree view.
	 * All children are recursed and add too.
	 *
	 * Params:
	 *     parentRow = The id of the parent row. Use '{}' for the top level.
	 *     rows = The rows to add to the tree view.
	 */
	private void appendRows(string parentRow, TreeViewRow[] rows)
	{
		string dataValues;
		string tags;

		foreach (row; rows)
		{
			if (row.values.length > 1)
			{
				dataValues = format("\"%s\"", row.values[1 .. $].join("\" \""));
			}

			if (row.tags.length)
			{
				tags = format("\"%s\"", row.tags.join("\" \""));
			}

			this._tk.eval("%s insert %s end -text {%s} -values {%s} -open %s -tags {%s}", this.id, parentRow, row.values[0], dataValues, row.isOpen, tags);

			if (row.children.length)
			{
				this.appendRows(this._tk.getResult!(string), row.children);
			}
		}
	}

	/**
	 * Set image and colors for a specific tag. Colors can be from the preset 
	 * list or a web style hex color.
	 *
	 * Params:
	 *     name = The name of the tag.
	 *     image = The image to associate to the tag.
	 *     foreground = The forground color.
	 *     background = The background color.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./color.html, tkd.widget.color) $(BR)
	 */
	public auto setTag(this T)(string name, Image image, string foreground = Color.default_, string background = Color.default_)
	{
		this._tk.eval("%s tag configure %s -image %s -foreground {%s} -background {%s}", this.id, name, image.id, foreground, background);

		return cast(T) this;
	}

	/**
	 * Get the columns.
	 *
	 * Returns:
	 *     An array containing all the data columns.
	 */
	public @property TreeViewColumn[] columns()
	{
		return this._columns;
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
		this._tk.eval("%s configure -displaycolumns {\"%s\"}", this.id, this.getDataColumnIdentifiers(indexes).join("\" \""));

		return cast(T) this;
	}

	/**
	 * Set the selection mode.
	 *
	 * Params:
	 *     mode = The mode of the selection.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./treeview.html#TreeViewSelectionMode, tkd.widget.treeview.TreeViewSelectionMode) $(BR)
	 */
	public auto setSelectionMode(this T)(string mode)
	{
		this._tk.eval("%s configure -selectmode %s", this.id, mode);

		return cast(T) this;
	}

	/**
	 * Hide the headings from all columns.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto hideHeadings(this T)()
	{
		this._tk.eval("%s configure -show { %s }", this.id, this.getShownElements()
			.remove!(x => x == "headings")
			.join(" ")
		);

		return cast(T) this;
	}

	/**
	 * Show the headings for all columns.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto showHeadings(this T)()
	{
		string[] elements = this.getShownElements();
		elements ~= "headings";

		this._tk.eval("%s configure -show { %s }", this.id, elements.join(" "));

		return cast(T) this;
	}

	/**
	 * Hide the tree view column.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto hideTreeColumn(this T)()
	{
		this._tk.eval("%s configure -show { %s }", this.id, this.getShownElements()
			.remove!(x => x == "tree")
			.join(" ")
		);

		return cast(T) this;
	}

	/**
	 * Show the tree view column.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto showTreeColumn(this T)()
	{
		string[] elements = this.getShownElements();
		elements ~= "tree";

		this._tk.eval("%s configure -show { %s }", this.id, elements.join(" "));

		return cast(T) this;
	}

	/**
	 * Construct a row object from a row id.
	 *
	 * Params:
	 *     rowId = The id of the row to construct.
	 *
	 * Returns:
	 *     A tree view row.
	 */
	private TreeViewRow getRowFromId(string rowId)
	{
		auto row = new TreeViewRow();

		this._tk.eval("%s item %s -text", this.id, rowId);
		row._values ~= this._tk.getResult!(string);

		this._tk.eval("%s item %s -values", this.id, rowId);
		auto results = matchAll(this._tk.getResult!(string), "\"(.*?)\"");
		foreach (result; results)
		{
			row._values ~= result.captures[1];
		}

		this._tk.eval("%s item %s -open", this.id, rowId);
		row._isOpen = this._tk.getResult!(bool);

		this._tk.eval("%s item %s -tags", this.id, rowId);
		results = matchAll(this._tk.getResult!(string), "\"(.*?)\"");
		foreach (result; results)
		{
			row._tags ~= result.captures[1];
		}

		return row;
	}

	/**
	 * Populate row objects and return them.
	 *
	 * Params:
	 *     rows = An array to append the rows to.
	 *     includeChildren = Specifies whether or not to include the children.
	 *
	 * Returns:
	 *     AN array of tree view rows.
	 */
	private TreeViewRow[] populateRows(string[] rowIds, bool includeChildren)
	{
		TreeViewRow[] rows;
		TreeViewRow currentRow;

		foreach (rowId; rowIds)
		{
			currentRow = this.getRowFromId(rowId);

			if (includeChildren)
			{
				this._tk.eval("%s children %s", this.id, rowId);
				currentRow.children = this.populateRows(this._tk.getResult!(string).split(), includeChildren);
			}

			rows ~= currentRow;
		}

		return rows;
	}

	/**
	 * Get the row(s) selected in the tree view.
	 *
	 * Params:
	 *     includeChildren = Specifies whether or not to include the children.
	 *
	 * Returns:
	 *     An array containing the selected rows.
	 */
	public TreeViewRow[] getSelectedRows(bool includeChildren = false)
	{
		this._tk.eval("%s selection", this.id);
		string[] rowIds = this._tk.getResult!(string).split();

		return this.populateRows(rowIds, includeChildren);
	}

	/**
	 * Delete all rows in the widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto deleteRows()
	{
		this._tk.eval("%s children {}", this.id);
		this._tk.eval("%s delete {%s}", this.id, this._tk.getResult!(string));
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
	private string _anchor = AnchorPosition.west;

	/**
	 * The image of the heading.
	 */
	private Image _image;

	/**
	 * The minimum width of the column.
	 */
	private int _minWidth = 20;

	/**
	 * Whether to alter the size of the column when the widget is resized.
	 */
	private bool _stretch = true;

	/**
	 * Width of the column.
	 */
	private int _width = 200;

	/**
	 * The command associated with the heading.
	 */
	private CommandCallback _commandCallback;

	/**
	 * Construct a new column to add the treeview column to the column 
	 * collection.
	 *
	 * '#0' is the built-in Tcl/Tk display id of the tree view column.
	 * This allows access to this column even if it wasn't created by us.
	 */
	private this()
	{
		super();
		this.overrideGeneratedId("#0");
	}

	/**
	 * Construct a new column.
	 *
	 * Params:
	 *     title = The optional title of the heading.
	 *     anchor = The anchor position of the heading title.
	 */
	public this(string title = null, string anchor = AnchorPosition.west)
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
		this.setHeadingImage(this._image);
		this.setHeadingCommand(this._commandCallback);
		this.setMinWidth(this._minWidth);
		this.setStretch(this._stretch);
		this.setWidth(this._width);
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

		if (this._parent)
		{
			this._tk.eval("%s heading %s -text {%s} -anchor %s", this._parent.id, this.id, this._title, this._anchor);
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
	public auto setHeadingImage(this T)(Image image)
	{
		this._image = image;

		if (this._parent && this._image)
		{
			this._tk.eval("%s heading %s -text {%s} -anchor %s -image %s", this._parent.id, this.id, this._title, this._anchor, image.id);
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
	 *     $(LINK2 ../element/element.html#CommandCallback, tkd.element.element.CommandCallback)
	 */
	public auto setHeadingCommand(this T)(CommandCallback callback)
	{
		this._commandCallback = callback;

		if (this._parent && this._commandCallback)
		{
			string command = this.createCommand(callback, this._parent.id);
			this._tk.eval("%s heading %s -command %s", this._parent.id, this.id, command);
		}

		return cast(T) this;
	}

	/**
	 * Remove the column command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto removeHeadingCommand(this T)()
	{
		if (this._parent && this._commandCallback)
		{
			this._tk.deleteCommand(this.getCommandName(this._parent.id));
			this._tk.eval("%s heading %s -command {}", this._parent.id, this.id);
		}

		return cast(T) this;
	}

	/**
	 * Set the minium width of the column.
	 *
	 * Params:
	 *     minWidth = The minimum width in pixels.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setMinWidth(this T)(int minWidth)
	{
		this._minWidth = minWidth;

		if (this._parent)
		{
			this._tk.eval("%s column %s -minwidth %s", this._parent.id, this.id, this._minWidth);
		}

		return cast(T) this;
	}

	/**
	 * Enable or disable stretching for the column. This controls how this 
	 * column react when other columns or the parent widget is resized.
	 *
	 * Params:
	 *     stretch = true for enabling stretching, false to disable.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setStretch(this T)(bool stretch)
	{
		this._stretch = stretch;

		if (this._parent)
		{
			this._tk.eval("%s column %s -stretch %s", this._parent.id, this.id, this._stretch);
		}

		return cast(T) this;
	}

	/**
	 * Set the width of the column.
	 *
	 * Params:
	 *     width = The width in pixels.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setWidth(this T)(int width)
	{
		this._width = width;

		if (this._parent)
		{
			this._tk.eval("%s column %s -width %s", this._parent.id, this.id, this._width);
		}

		return cast(T) this;
	}
}

/**
 * A class representing a row in the tree view.
 */
class TreeViewRow
{
	/**
	 * An array containing the column values.
	 */
	private string[] _values;

	/**
	 * Boolean representing if the row was set to be open when created.
	 */
	private bool _isOpen;

	/**
	 * An array containing the tags.
	 */
	private string[] _tags;

	/**
	 * An array containing the child rows.
	 */
	public TreeViewRow[] children;

	/**
	 * Constructor.
	 */
	private this()
	{
	}

	/**
	 * Constructor.
	 *
	 * Params:
	 *     values = The values of the columns.
	 *     isOpen = Whether or not to display the row open.
	 *     tags = The tags to associate to this row.
	 */
	public this(string[] values, bool isOpen = false, string[] tags = [])
	{
		assert(values.length, "There must be at least 1 value in the row.");

		this._values = values;
		this._isOpen = isOpen;
		this._tags   = tags;
	}

	/**
	 * Get the data column values.
	 *
	 * Returns:
	 *     An array containing the data values.
	 */
	public @property string[] values()
	{
		return this._values;
	}

	/**
	 * Get if the row was open.
	 *
	 * Returns:
	 *     true if the row was set to be open, false if not.
	 */
	public @property bool isOpen()
	{
		return this._isOpen;
	}

	/**
	 * Get the tags.
	 *
	 * Returns:
	 *     An array of tags assocaited to this row.
	 */
	public @property string[] tags()
	{
		return this._tags;
	}

	/**
	 * String representation.
	 */
	debug override public string toString()
	{
		return format("Values: %s, isOpen: %s, Tags: %s, Children: %s", this.values, this.isOpen, this.tags, this.children);
	}
}

/**
 * Tree view selection modes.
 */
enum TreeViewSelectionMode : string
{
	browse   = "browse",   /// The default mode, allows one selection only.
	extended = "extended", /// Allows multiple selections to be made.
	none     = "none",     /// Disabled all selection.
}
