/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.canvas;

/**
 * Imports.
 */
import std.algorithm;
import std.array;
import std.conv;
import std.string;
import tkd.element.element;
import tkd.element.uielement;
import tkd.image.image;
import tkd.widget.anchorposition;
import tkd.widget.common.border;
import tkd.widget.common.height;
import tkd.widget.common.relief;
import tkd.widget.common.width;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.xview;
import tkd.widget.common.yscrollcommand;
import tkd.widget.common.yview;
import tkd.widget.reliefstyle;
import tkd.widget.widget;

/**
 * Canvas widgets implement structured graphics. A canvas displays any number 
 * of items, which may be things like rectangles, circles, lines, and text.  
 * Items may be manipulated (e.g. moved or re-colored) and commands may be 
 * associated with items in much the same way that the bind command allows 
 * commands to be bound to widgets.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/border.html, Border) $(BR)
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/relief.html, Relief) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
 *         $(LINK2 ./common/xscrollcommand.html, XScrollCommand) $(BR)
 *         $(LINK2 ./common/xview.html, XView) $(BR)
 *         $(LINK2 ./common/yscrollcommand.html, YScrollCommand) $(BR)
 *         $(LINK2 ./common/yview.html, YView) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class Canvas : Widget, IXScrollable!(Canvas), IYScrollable!(Canvas)
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	public this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "canvas";

		this._tk.eval("canvas %s -highlightthickness 0", this.id);

		this.setBorderWidth(1);
		this.setRelief(ReliefStyle.sunken);
	}

	/**
	 * Specifies a floating-point value indicating how close the mouse cursor 
	 * must be to an item before it is considered to be 'inside' the item and 
	 * able to select it.  Defaults to 1.0.
	 *
	 * Params:
	 *     tolerance = The tolerance of the selection.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setSelectionTolerance(this T)(double tolerance)
	{
		this._tk.eval("%s configure -closeenough %s", this.id, tolerance);

		return cast(T) this;
	}

	/**
	 * Set the scroll region of the canvas. This region can be scrolled using 
	 * scrollbars if it's bigger than the canvas widget itself.
	 *
	 * Params:
	 *     left = The left hand side of the widget.
	 *     top = The top side of the widget.
	 *     right = The right hand side of the widget.
	 *     bottom = The bottom side of the widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setScrollRegion(this T)(double left, double top, double right, double bottom)
	{
		this._tk.eval("%s configure -scrollregion [list %s %s %s %s]", this.id, left, top, right, bottom);

		return cast(T) this;
	}

	/**
	 * Set the scroll increment i.e. how many pixels are scrolled per each 
	 * click on a scrollbar.
	 *
	 * Params:
	 *     increment = The increment to scroll by.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setScrollIncrement(this T)(int increment)
	{
		this._tk.eval("%s configure -xscrollincrement %s -yscrollincrement %s", this.id, increment, increment);

		return cast(T) this;
	}

	/**
	 * Get the horizontal position on the canvas that relates to a particular 
	 * horizontal position on screen.
	 *
	 * Params:
	 *     screenXPos = The horizontal screen position to transpose.
	 *     gridSpacing = The grid spacing to round it to.
	 *
	 * Returns:
	 *     The horizontal canvas position.
	 */
	public int getXPosFromScreen(int screenXPos, int gridSpacing = 1)
	{
		this._tk.eval("%s canvasx %s %s", this.id, screenXPos, gridSpacing);

		return this._tk.getResult!(string).chomp(".0").to!(int) - this.getXPos();
	}

	/**
	 * Get the vertical position on the canvas that relates to a particular 
	 * vertical position on screen.
	 *
	 * Params:
	 *     screenYPos = The vertical screen position to transpose.
	 *     gridSpacing = The grid spacing to round it to.
	 *
	 * Returns:
	 *     The vertical canvas position.
	 */
	public int getYPosFromScreen(int screenYPos, int gridSpacing = 1)
	{
		this._tk.eval("%s canvasy %s %s", this.id, screenYPos, gridSpacing);

		return this._tk.getResult!(string).chomp(".0").to!(int) - this.getYPos();
	}

	/**
	 * Add an item to the canvas.
	 *
	 * Params:
	 *     item = The item to add.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto addItem(this T)(Item item)
	{
		this._tk.eval("%s create %s [list %s]", this.id, item._type, item._coords.map!(to!(string)).join(" "));

		item.overrideGeneratedId(this._tk.getResult!(string));
		item.init(this);

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Border;
	mixin Height;
	mixin Relief;
	mixin Width;
	mixin XScrollCommand!(Canvas);
	mixin XView;
	mixin YScrollCommand!(Canvas);
	mixin YView;
}

/**
 * Abstract base class of all canvas items.
 */
private abstract class Item : Element
{
	/**
	 * The type of the item.
	 */
	protected string _type;

	/**
	 * The coordinates where to draw the item.
	 */
	protected int[] _coords;

	/**
	 * The state of the item.
	 */
	protected string _state;

	/**
	 * The tags associated with this item.
	 */
	protected string[] _tags;

	/**
	 * Get the coords of this item.
	 *
	 * Returns:
	 *     An array of coords of this item.
	 */
	public int[] getCoords()
	{
		return this._coords;
	}

	/**
	 * Set the coordinates used to draw this item.
	 *
	 * Params:
	 *    coords = The coords used for this item.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setCoords(this T)(int[] coords)
	{
		assert(coords.length > 0, "No coordinates specified.");

		this._coords = coords;

		if (this._parent && this._coords.length)
		{
			this._tk.eval("%s create %s [list %s]", this.parent.id, this.id, this._coords.map!(to!(string)).join(" "));
		}

		return cast(T) this;
	}

	/**
	 * Get the state of this item.
	 *
	 * Returns:
	 *     The state of this item.
	 */
	public string getState()
	{
		return this._state;
	}

	/**
	 * Set the item state. The only valid states are normal, disabled or 
	 * hidden.
	 *
	 * Params:
	 *    state = The state to set.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state) $(BR)
	 */
	public auto setState(this T)(string state)
	{
		this._state = state;

		if (this._parent && this._state.length)
		{
			this._tk.eval("%s itemconfigure %s -state %s", this._parent.id, this.id, this._state);
		}

		return cast(T) this;
	}

	/**
	 * Get the tags associated with this item.
	 *
	 * Returns:
	 *     An array of tags associated with this item.
	 */
	public string[] getTags()
	{
		return this._tags;
	}

	/**
	 * Set tags associated with this item.
	 *
	 * Params:
	 *    tags = The tags to associated with this item.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setTags(this T)(string[] tags)
	{
		this._tags = tags;

		if (this._parent && this._tags.length)
		{
			this._tk.eval("%s itemconfigure %s -tags {%s}", this._parent.id, this.id, this._tags.join(" "));
		}

		return cast(T) this;
	}

	/**
	 * Initialise the widget.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	protected void init(Canvas parent)
	{
		this._parent = parent;

		this.setState(this._state);
		this.setTags(this._tags);
	}
}

/**
 * A rectangle canvas item.
 */
class Rectangle : Item
{
	/**
	 * Create a rectangle from four coordinates.
	 *
	 * Params:
	 *     coords = The coordinated where to draw the rectangle.
	 */
	public this(int[] coords)
	{
		assert(coords.length == 4, "Four coordinates are needed to draw a rectangle.");

		this._type = "rectangle";
		this._coords = coords;
	}

	/**
	 * Initialise the widget.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	override protected void init(Canvas parent)
	{
		super.init(parent);
	}
}

// Common options to implement.
// -dash
// -activedash
// -disableddash
// -dashoffset
// -fill
// -activefill
// -disabledfill
// -outline
// -activeoutline
// -disabledoutline
// -outlineoffset
// -width
// -activewidth
// -disabledwidth

/**
 * These are common commands that apply to all items that have them injected.
 */
private mixin template Anchor()
{
	/**
	 * The anchor position.
	 */
	protected string _anchor;

	/**
	 * Set the anchor position.
	 *
	 * Params:
	 *    anchor = The anchor position of the text.
	 *
	 * See_Also:
	 *     $(LINK2 ./anchorposition.html, tkd.widget.anchorposition) $(BR)
	 */
	public auto setAnchor(this T)(string anchor)
	{
		this._anchor = anchor;

		if (this._parent && this._anchor.length)
		{
			this._tk.eval("%s itemconfigure %s -anchor %s", this._parent.id, this.id, this._anchor);
		}

		return cast(T) this;
	}
}
