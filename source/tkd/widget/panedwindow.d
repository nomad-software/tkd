/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.panedwindow;

/**
 * Imports.
 */
import std.array;
import tkd.element.uielement;
import tkd.widget.common.height;
import tkd.widget.common.width;
import tkd.widget.orientation;
import tkd.widget.widget;

/**
 * A paned window widget displays a number of subwindows, stacked either 
 * vertically or horizontally. The user may adjust the relative sizes of the 
 * subwindows by dragging the sash between panes.
 *
 * Example:
 * ---
 * // The paned window must be created first.
 * // See the constructor notes in the documentation.
 * auto panedWindow = new PanedWindow();
 *
 * // The pane's widgets are contained within the frames.
 * auto left = new Frame(panedWindow);
 * auto right = new Frame(panedWindow);
 *
 * panedwindow.addPane(left)
 * 	.addPane(right)
 * 	.pack();
 * ---
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;EnteredChild&gt;&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;B1-Motion&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;ButtonRelease-1&gt;,
 *         &lt;Enter&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Leave&gt;,
 *         &lt;Motion&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class PanedWindow : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     orientation = The orientation of the widget.
	 *
	 * Bugs:
	 *     Because this widget contains and handles other widget's geometry, it 
	 *     must be created before the child panes and not chained with methods 
	 *     that add new tabs. If it is chained, tabs will not be handled 
	 *     correctly and might not show at all. This seems to be a limitation 
	 *     with Tcl/Tk.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 *     $(LINK2 ./orientation.html, tkd.widget.orientation) for orientations.
	 */
	public this(UiElement parent, string orientation = Orientation.vertical)
	{
		super(parent);
		this._elementId = "panedwindow";

		this._tk.eval("ttk::panedwindow %s -orient %s", this.id, orientation);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     orientation = The orientation of the widget.
	 *
	 * Bugs:
	 *     Because this widget contains and handles other widget's geometry, it 
	 *     must be created before the child panes and not chained with methods 
	 *     that add new tabs. If it is chained, tabs will not be handled 
	 *     correctly and might not show at all. This seems to be a limitation 
	 *     with Tcl/Tk.
	 *
	 * See_Also:
	 *     $(LINK2 ./orientation.html, tkd.widget.orientation) for orientations.
	 */
	public this(string orientation = Orientation.vertical)
	{
		this(null, orientation);
	}

	/**
	 * Add a pane to the paned window. When adding a pane to the paned window 
	 * the pane gains an id that is equal to the passed widget's id and can be 
	 * used later to refer to the new pane.
	 *
	 * Params:
	 *     widget = The widget to add as the pane.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto addPane(this T)(Widget widget)
	{
		this.insertPane("end", widget);

		return cast(T) this;
	}

	/**
	 * Insert a pane into the paned window at a specified zero based index or 
	 * before another pane id. When adding a pane to the paned window for the 
	 * first time the pane gains an id that is equal to the passed widget's id 
	 * and can be used later to refer to the new pane. If the id of the widget 
	 * passed is already used as a pane id then that existing one will be moved 
	 * to the new position.
	 *
	 * Params:
	 *     paneIdentifier = The zero based index or string id of the pane.
	 *     widget = The widget to add as the pane.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto insertPane(this T, I)(I paneIdentifier, Widget widget) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s insert %s %s", this.id, paneIdentifier, widget.id);

		return cast(T) this;
	}

	/**
	 * Remove a pane from the paned window.
	 *
	 * Params:
	 *     paneIdentifier = The zero based index or string id of the pane.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto removePane(this T, I)(I paneIdentifier) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s forget %s", this.id, paneIdentifier);

		return cast(T) this;
	}

	/**
	 * Set the pane weight. Weight is an integer specifying the relative 
	 * stretchability of the pane. When the paned window is resized, the extra 
	 * space is added or subtracted to each pane proportionally to its weight.
	 *
	 * Params:
	 *     paneIdentifier = The zero based index or string id of the pane.
	 *     weight = The new weight of the pane.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setPaneWeight(this T, I)(I paneIdentifier, int weight)
	{
		this._tk.eval("%s pane %s -weight %s", this.id, paneIdentifier, weight);

		return cast(T) this;
	}

	/**
	 * Get an array of all the current pane id's.
	 *
	 * Returns:
	 *     An array containing all the pane id's.
	 */
	public string[] getPaneIds()
	{
		this._tk.eval("%s panes", this.id);
		return this._tk.getResult!(string).split();
	}

	/**
	 * Sets the position of a sash. May adjust the positions of adjacent sashes 
	 * to ensure that positions are monotonically increasing.  Sash positions 
	 * are further constrained to be between 0 and the total size of the 
	 * widget. Must be called after the UI has been drawn.
	 *
	 * Params:
	 *     sashIndex = The index of the sash.
	 *     position = The new position of the sash.
	 */
	public auto setSashPosition(this T)(int sashIndex, int position)
	{
		this._tk.eval("%s sashpos %s %s", this.id, sashIndex, position);

		return cast(T) this;
	}

	/**
	 * Get the position of a sash. Must be called after the UI has been drawn.
	 *
	 * Params:
	 *     sashIndex = The index of the sash.
	 */
	public int getSashPosition(this T)(int sashIndex)
	{
		this._tk.eval("%s sashpos %s", this.id, sashIndex);
		return this._tk.getResult!(int);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Height;
	mixin Width;
}
