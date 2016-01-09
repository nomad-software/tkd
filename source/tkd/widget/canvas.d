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
import std.uni;
import tkd.element.color;
import tkd.element.element;
import tkd.element.uielement;
import tkd.image.image;
import tkd.widget.anchorposition;
import tkd.widget.common.border;
import tkd.widget.common.canvas.anchor;
import tkd.widget.common.canvas.arcspecific;
import tkd.widget.common.canvas.bind;
import tkd.widget.common.canvas.fillcolor;
import tkd.widget.common.canvas.imagespecific;
import tkd.widget.common.canvas.linespecific;
import tkd.widget.common.canvas.outlinecolor;
import tkd.widget.common.canvas.outlinedash;
import tkd.widget.common.canvas.outlinewidth;
import tkd.widget.common.canvas.state;
import tkd.widget.common.canvas.textspecific;
import tkd.widget.common.canvas.vertex;
import tkd.widget.common.canvas.widgetspecific;
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
 * Example:
 * ---
 * auto canvas = new Canvas(Color.white)
 * 	.setWidth(350)
 * 	.setHeight(250)
 * 	.addItem(new CanvasRectangle([10, 10, 200, 100]))
 * 	.bind("<ButtonPress-1>", delegate(CommandArgs args){ ... })
 * 	.pack();
 * ---
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
	 *     backgroundColor = The background color.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	public this(UiElement parent, string backgroundColor = Color.default_)
	{
		super(parent);
		this._elementId = "canvas";

		this._tk.eval("canvas %s", this.id);

		this.setBorderWidth(1);
		this.setRelief(ReliefStyle.sunken);
		this.setBackgroundColor(backgroundColor);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     backgroundColor = The background color.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	public this(string backgroundColor = Color.default_)
	{
		this(null, backgroundColor);
	}

	/**
	 * Set the background color.
	 * Use colors from the preset color $(LINK2 ../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     color = The background color.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/color.html, tkd.widget.color) $(BR)
	 */
	public auto setBackgroundColor(this T)(string color)
	{
		if (color.length)
		{
			this._tk.eval("%s configure -background {%s}", this.id, color);
		}

		return cast(T) this;
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
	 * Tag an item nearest to coordinates. If more than one item is at the same 
	 * closest distance (e.g. two items overlap the point), then the top-most 
	 * of these items (the last one in the display list) is used. If radius is 
	 * specified, then it must be a non-negative value. Any item closer than 
	 * halo to the point is considered to overlap it.
	 *
	 * Params:
	 *    tag = The tag to add.
	 *    xPos = The horizontal position.
	 *    yPos = The vertical position.
	 *    radius = The radius around the point.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto tagItemNear(this T)(string tag, int xPos, int yPos, uint radius = 0)
	{
		if (tag.length)
		{
			this._tk.eval("%s addtag %s closest %s %s %s", this.id, tag, xPos, yPos, radius);
		}

		return cast(T) this;
	}

	/**
	 * Tag items within a selection region.
	 *
	 * Params:
	 *    tag = The tag to add.
	 *    x1 = The left edge of the selection region.
	 *    y1 = The top edge of the selection region.
	 *    x2 = The right edge of the selection region.
	 *    y2 = The bottom edge of the selection region.
	 *    enclosedFully = Specifies if the items have to be enclosed fully or not.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto tagItemIn(this T)(string tag, int x1, int y1, int x2, int y2, bool enclosedFully = false)
	{
		assert(x1 <= x2, "x1 must not be greater than x2.");
		assert(y1 <= y2, "y1 must not be greater than y2.");

		if (tag.length)
		{
			if (enclosedFully)
			{
				this._tk.eval("%s addtag %s enclosed %s %s %s %s", this.id, tag, x1, y1, x2, y2);
			}
			else
			{
				this._tk.eval("%s addtag %s overlapping %s %s %s %s", this.id, tag, x1, y1, x2, y2);
			}
		}

		return cast(T) this;
	}

	/**
	 * Tag items that are already tagged with another tag.
	 *
	 * Params:
	 *    tag = The tag to add.
	 *    searchTag = The tag to select items to tag.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto tagItemWithTag(this T)(string tag, string searchTag)
	{
		if (tag.length && searchTag.length)
		{
			this._tk.eval("%s addtag %s withtag %s", this.id, tag, searchTag);
		}

		return cast(T) this;
	}

	/**
	 * Get an item id nearest to coordinates. If more than one item is at the 
	 * same closest distance (e.g. two items overlap the point), then the 
	 * top-most of these items (the last one in the display list) is used. If 
	 * radius is specified, then it must be a non-negative value. Any item 
	 * closer than halo to the point is considered to overlap it.
	 *
	 * Params:
	 *    xPos = The horizontal position.
	 *    yPos = The vertical position.
	 *    radius = The radius around the point.
	 *
	 * Returns:
	 *     The item found.
	 */
	public int getItemIdNear(int xPos, int yPos, uint radius = 0)
	{
		this._tk.eval("%s find closest %s %s %s", this.id, xPos, yPos, radius);

		return this._tk.getResult!(int);
	}

	/**
	 * Get items within a selection region.
	 *
	 * Params:
	 *    x1 = The left edge of the selection region.
	 *    y1 = The top edge of the selection region.
	 *    x2 = The right edge of the selection region.
	 *    y2 = The bottom edge of the selection region.
	 *    enclosedFully = Specifies if the items have to be enclosed fully or not.
	 *
	 * Returns:
	 *     An array of found items.
	 */
	public int[] getItemIdsIn(int x1, int y1, int x2, int y2, bool enclosedFully = false)
	{
		assert(x1 <= x2, "x1 must not be greater than x2.");
		assert(y1 <= y2, "y1 must not be greater than y2.");

		if (enclosedFully)
		{
			this._tk.eval("%s find enclosed %s %s %s %s", this.id, x1, y1, x2, y2);
		}
		else
		{
			this._tk.eval("%s find overlapping %s %s %s %s", this.id, x1, y1, x2, y2);
		}

		return this._tk.getResult!(string).split().map!(to!(int)).array;
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
	public auto addItem(this T)(CanvasItem item)
	{
		this._tk.eval("%s create %s [list %s]", this.id, item._type, item._coords.map!(to!(string)).join(" "));

		item.overrideGeneratedId(this._tk.getResult!(string));
		item.init(this);

		return cast(T) this;
	}

	/**
	 * Add a tag configuration to the canvas. These can apply options to a tag 
	 * which can then be applied to any item.
	 *
	 * Params:
	 *     tagConfig = The configuration to add.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto addTagConfig(this T)(CanvasTagConfig tagConfig)
	{
		tagConfig.init(this);

		return cast(T) this;
	}

	/**
	 * This command is used to implement scanning on canvases. Records x and y 
	 * positions and the canvas's current view. This is used in conjunction 
	 * with later scanDragTo commands.
	 *
	 * Params:
	 *     xPos = The marked horizontal starting point of a scan.
	 *     yPos = The marked vertical starting point of a scan.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./canvas.html#Canvas.scanDragTo, tkd.widget.canvas.Canvas.scanDragTo)
	 */
	public auto setScanMark(this T)(double xPos, double yPos)
	{
		this._tk.eval("%s scan mark %s %s", this.id, xPos, yPos);

		return cast(T) this;
	}

	/**
	 * This command is used to implement scanning on canvases. This command 
	 * computes the difference between its xPos and yPos arguments (which are 
	 * typically mouse coordinates) and the xPos and yPos arguments to the last 
	 * setScanMark command for the widget. It then adjusts the view by gain 
	 * times the difference in coordinates, where gain defaults to 1. This 
	 * command is typically associated with mouse motion events in the widget, 
	 * to produce the effect of dragging the canvas at high speed through its 
	 * window.
	 *
	 * Params:
	 *     xPos = The marked horizontal starting point of a scan.
	 *     yPos = The marked vertical starting point of a scan.
	 *     gain = The adjustment in the drag amount.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./canvas.html#Canvas.setScanMark, tkd.widget.canvas.Canvas.setScanMark)
	 */
	public auto scanDragTo(this T)(double xPos, double yPos, int gain = 1)
	{
		this._tk.eval("%s scan dragto %s %s %s", this.id, xPos, yPos, gain);

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
 * Class representing a tag configuration. Tags can be applied to numerous 
 * items on the canvas but keep in mind the tag options set in the 
 * configuration must be compatible for all items the tag is assigned to or an 
 * error will occur. Tags must be applied to items before they can be 
 * configured.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/canvas/anchor.html, Anchor) $(BR)
 *         $(LINK2 ./common/canvas/arcspecific.html, ArcSpecific) $(BR)
 *         $(LINK2 ./common/canvas/bind.html, Bind) $(BR)
 *         $(LINK2 ./common/canvas/fillcolor.html, FillColor) $(BR)
 *         $(LINK2 ./common/canvas/imagespecific.html, ImageSpecific) $(BR)
 *         $(LINK2 ./common/canvas/linespecific.html, LineSpecific) $(BR)
 *         $(LINK2 ./common/canvas/outlinecolor.html, OutlineColor) $(BR)
 *         $(LINK2 ./common/canvas/outlinedash.html, OutlineDash) $(BR)
 *         $(LINK2 ./common/canvas/outlinewidth.html, OutlineWidth) $(BR)
 *         $(LINK2 ./common/canvas/state.html, State) $(BR)
 *         $(LINK2 ./common/canvas/textspecific.html, TextSpecific) $(BR)
 *         $(LINK2 ./common/canvas/vertex.html, Vertex) $(BR)
 *         $(LINK2 ./common/canvas/widgetspecific.html, WidgetSpecific) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ../element/element.html, tkd.element.element)
 */
class CanvasTagConfig : Element
{
	/**
	 * Constructor.
	 *
	 * Params:
	 *     tagName = The name of the tag to configure.
	 */
	this(string tagName)
	{
		this.overrideGeneratedId(tagName);
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	protected void init(Canvas parent)
	{
		this._parent = parent;

		foreach (binding, callback; this._bindings)
		{
			this.bind(binding, callback);
		}

		this.setActiveFillColor(this._activeFillColor);
		this.setActiveImage(this._activeImage);
		this.setActiveOutlineColor(this._activeOutlineColor);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setAlignment(this._alignment);
		this.setAnchor(this._anchor);
		this.setAngle(this._angle);
		this.setArrowPosition(this._arrowPosition);
		this.setArrowShape(this._arrowShape);
		this.setCapStyle(this._capStyle);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setDisabledImage(this._disabledImage);
		this.setDisabledOutlineColor(this._disabledOutlineColor);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
		this.setExtent(this._extent);
		this.setFillColor(this._fillColor);
		this.setFont(this._font);
		this.setHeight(this._height);
		this.setImage(this._image);
		this.setJoinStyle(this._joinStyle);
		this.setMaxLineLength(this._maxLineLength);
		this.setOutlineColor(this._outlineColor);
		this.setOutlineDash(this._outlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
		this.setSmoothMethod(this._smoothMethod);
		this.setSmoothSplineSteps(this._splineSteps);
		this.setStartAngle(this._startAngle);
		this.setState(this._state);
		this.setStyle(this._style);
		this.setText(this._text);
		this.setWidget(this._widget);
		this.setWidth(this._width);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Anchor;
	mixin ArcSpecific;
	mixin Bind;
	mixin FillColor;
	mixin ImageSpecific;
	mixin LineSpecific;
	mixin OutlineColor;
	mixin OutlineDash;
	mixin OutlineWidth;
	mixin State;
	mixin TextSpecific;
	mixin Vertex;
	mixin WidgetSpecific;
}

/**
 * Abstract base class of all canvas items.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/canvas/bind.html, Bind) $(BR)
 *         $(LINK2 ./common/canvas/state.html, State) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ../element/element.html, tkd.element.element)
 */
protected abstract class CanvasItem : Element
{
	/**
	 * The type of the item.
	 */
	private string _type;

	/**
	 * The coordinates where to draw the item.
	 */
	private double[] _coords;

	/**
	 * The tags associated with this item.
	 */
	private string[] _tags;

	/**
	 * Get the type of canvas item.
	 *
	 * Returns:
	 *     The type of canvas item.
	 */
	public @property string type()
	{
		return this._type;
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	protected void init(Canvas parent)
	{
		this._parent = parent;

		foreach (binding, callback; this._bindings)
		{
			this.bind(binding, callback);
		}

		this.setState(this._state);

		this.setTags(this._tags);
	}

	/**
	 * Get the coords of this item.
	 *
	 * Returns:
	 *     An array of coords of this item.
	 */
	public double[] getCoords()
	{
		if (this._parent)
		{
			this._tk.eval("%s coords %s", this._parent.id, this.id);
			this._coords = this._tk.getResult!(string).split().map!(to!(double)).array;
		}

		return this._coords;
	}

	/**
	 * Set the coordinates used to draw this item.
	 *
	 * Params:
	 *    coords = The coords used for this item.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setCoords(this T)(double[] coords)
	{
		assert(coords.length >= 2, "Not enough coordinates specified.");

		this._coords = coords;

		if (this._parent)
		{
			this._tk.eval("%s coords %s [list %s]", this._parent.id, this.id, this._coords.map!(to!(string)).join(" "));
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
		if (this._parent)
		{
			this._tk.eval("%s gettags %s", this._parent.id, this.id);
			this._tags = this._tk.getResult!(string).split();
		}

		return this._tags;
	}

	/**
	 * Set tags associated with this item.
	 *
	 * Params:
	 *    tags = The tags to associated with this item.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setTags(this T)(string[] tags)
	{
		foreach (tag; tags)
		{
			assert(!tag.all!(isNumber), "Tags must not be entirely composed of numbers.");
		}

		this._tags = tags;

		if (this._parent && this._tags.length)
		{
			this._tk.eval("%s itemconfigure %s -tags {%s}", this._parent.id, this.id, this._tags.join(" "));
		}

		return cast(T) this;
	}

	/**
	 * Add a specific tag to this item.
	 *
	 * Params:
	 *    tag = The tags to add.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto addTag(this T)(string tag)
	{
		assert(!tag.all!(isNumber), "Tags must not be entirely composed of numbers.");

		this._tags = (this._tags ~= tag).uniq().array();

		if (this._parent && tag.length)
		{
			this._tk.eval("%s addtag {%s} withtag %s", this._parent.id, tag, this.id);
		}

		return cast(T) this;
	}

	/**
	 * Delete a specific tag associated to this item.
	 *
	 * Params:
	 *    tag = The tags to delete.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto deleteTag(this T)(string tag)
	{
		if (this._tags.canFind(tag))
		{
			this._tags = std.algorithm.remove(this._tags, this._tags.countUntil(tag));
		}

		if (this._parent && tag.length)
		{
			this._tk.eval("%s dtag %s {%s}", this._parent.id, this.id, tag);
		}

		return cast(T) this;
	}

	/**
	 * Delete all tags associated to this item.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto clearTags(this T)()
	{
		this._tags = [];

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -tags {}", this._parent.id, this.id);
		}

		return cast(T) this;
	}

	/**
	 * Destroy this item and remove it from the canvas.
	 *
	 * Caveats:
	 *     Once an item is destroyed it can no longer be referenced in your 
	 *     code or a segmentation fault will occur and potentially crash your 
	 *     program.
	 */
	public void destroy()
	{
		if (this._parent)
		{
			this._tk.eval("%s delete %s", this._parent.id, this.id);
		}

		super.destroy();
	}

	/**
	 * Set the keyboard focus to this item in the canvas.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto focus(this T)()
	{
		if (this._parent)
		{
			this._tk.eval("%s focus %s", this._parent.id, this.id);
		}

		return cast(T) this;
	}

	/**
	 * Lower an item in the drawing order.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto lower(this T)()
	{
		if (this._parent)
		{
			this._tk.eval("%s lower %s", this._parent.id, this.id);
		}

		return cast(T) this;
	}

	/**
	 * Raise an item in the drawing order.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto raise(this T)()
	{
		if (this._parent)
		{
			this._tk.eval("%s raise %s", this._parent.id, this.id);
		}

		return cast(T) this;
	}

	/**
	 * Move an item on the canvas by an amount.
	 *
	 * Params:
	 *     xAmount = The amount to move the item horizontally.
	 *     yAmount = The amount to move the item vertically.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto moveBy(this T)(int xAmount, int yAmount)
	{
		if (this._parent)
		{
			this._tk.eval("%s move %s %s %s", this._parent.id, this.id, xAmount, yAmount);
		}

		return cast(T) this;
	}

	/**
	 * Move an item on the canvas to a position.
	 *
	 * Params:
	 *     xPos = The new horizontal position.
	 *     yPos = The new vertical position.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto moveTo(this T)(int xPos, int yPos)
	{
		if (this._parent)
		{
			this._tk.eval("%s moveto %s %s %s", this._parent.id, this.id, xPos, yPos);
		}

		return cast(T) this;
	}

	/**
	 * Scale an item on the canvas. Note that some items have only a single 
	 * pair of coordinates (e.g., text, images and widgets) and so scaling of 
	 * them by this command can only move them around.
	 *
	 * Params:
	 *     xOrigin = The horizontal origin from which to perform the scale.
	 *     yOrigin = The vertical origin from which to perform the scale.
	 *     xPercent = The amount to scale horizontally.
	 *     yPercent = The amount to scale vertically.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto scale(this T)(double xOrigin, double yOrigin, double xPercent, double yPercent)
	{
		if (this._parent)
		{
			this._tk.eval("%s scale %s %s %s %s %s", this._parent.id, this.id, xOrigin, yOrigin, xPercent / 100, yPercent / 100);
		}

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Bind;
	mixin State;
}

/**
 * A canvas arc item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/arcspecific.html, ArcSpecific) $(BR)
 *         $(LINK2 ./common/canvas/fillcolor.html, FillColor) $(BR)
 *         $(LINK2 ./common/canvas/outlinecolor.html, OutlineColor) $(BR)
 *         $(LINK2 ./common/canvas/outlinedash.html, OutlineDash) $(BR)
 *         $(LINK2 ./common/canvas/outlinewidth.html, OutlineWidth) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasArc : CanvasItem
{
	/**
	 * Create an arc.
	 * Use colors from the preset color $(LINK2 ../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates of the outer elipse.
	 *     style = The style of arc.
	 *     fillColor = The fill color.
	 *     outlineColor = The outline color.
	 *     outlineWidth = The outline width.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/color.html, tkd.widget.color) $(BR)
	 *     $(LINK2 ./canvas.html#CanvasArcStyle, tkd.widget.canvas.CanvasArcStyle)
	 */
	public this(double[] coords, string style = CanvasArcStyle.pie, string fillColor = Color.default_, string outlineColor = Color.black, int outlineWidth = 1)
	{
		assert(coords.length == 4, "Four coordinates are needed to draw an arc.");

		this._type         = "arc";
		this._coords       = coords;
		this._style        = style;
		this._fillColor    = fillColor;
		this._outlineColor = outlineColor;
		this._outlineWidth = outlineWidth;
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	override protected void init(Canvas parent)
	{
		super.init(parent);

		this.setActiveFillColor(this._activeFillColor);
		this.setActiveOutlineColor(this._activeOutlineColor);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setDisabledOutlineColor(this._disabledOutlineColor);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
		this.setExtent(this._extent);
		this.setFillColor(this._fillColor);
		this.setOutlineColor(this._outlineColor);
		this.setOutlineDash(this._outlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
		this.setStartAngle(this._startAngle);
		this.setStyle(this._style);
	}

	/**
	 * Mixin common commands.
	 */
	mixin ArcSpecific;
	mixin FillColor;
	mixin OutlineColor;
	mixin OutlineDash;
	mixin OutlineWidth;
}

/**
 * Styles of arcs
 */
enum CanvasArcStyle : string
{
	arc   = "arc",      /// Arc is drawn as an arc only.
	chord = "chord",    /// Arc is drawn as a chord.
	pie   = "pieslice", /// Arc is drawn as a pie chart.
}

/**
 * An canvas image item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/anchor.html, Anchor) $(BR)
 *         $(LINK2 ./common/canvas/imagespecific.html, ImageSpecific) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasImage : CanvasItem
{
	/**
	 * Create an image.
	 *
	 * Params:
	 *     coords = The coordinates where to position the image.
	 *     image = The image to draw.
	 *     anchor = The anchor position of the image.
	 *
	 * See_Also:
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 *     $(LINK2 ./anchorposition.html, tkd.widget.anchorposition) $(BR)
	 */
	public this(double[] coords, Image image, string anchor = AnchorPosition.northWest)
	{
		assert(coords.length == 2, "Two coordinates are needed to position an image.");

		this._type   = "image";
		this._coords = coords;
		this._image  = image;
		this._anchor = anchor;
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	override protected void init(Canvas parent)
	{
		super.init(parent);

		this.setAnchor(this._anchor);
		this.setImage(this._image);
		this.setActiveImage(this._activeImage);
		this.setDisabledImage(this._disabledImage);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Anchor;
	mixin ImageSpecific;
}

/**
 * A canvas line item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/fillcolor.html, FillColor) $(BR)
 *         $(LINK2 ./common/canvas/linespecific.html, LineSpecific) $(BR)
 *         $(LINK2 ./common/canvas/outlinedash.html, OutlineDash) $(BR)
 *         $(LINK2 ./common/canvas/outlinewidth.html, OutlineWidth) $(BR)
 *         $(LINK2 ./common/canvas/vertex.html, Vertex) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasLine : CanvasItem
{
	/**
	 * Create a line from coordinates.
	 * Use colors from the preset color $(LINK2 ../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the line.
	 *     fillColor = The color of the line.
	 *     outlineWidth = The outline width.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/color.html, tkd.widget.color) $(BR)
	 */
	public this(double[] coords, string fillColor = Color.black, int outlineWidth = 1)
	{
		assert(coords.length >= 4, "Four or more coordinates are needed to draw a line.");

		this._type         = "line";
		this._coords       = coords;
		this._fillColor    = fillColor;
		this._outlineWidth = outlineWidth;
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	override protected void init(Canvas parent)
	{
		super.init(parent);

		this.setActiveFillColor(this._activeFillColor);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setArrowPosition(this._arrowPosition);
		this.setArrowShape(this._arrowShape);
		this.setCapStyle(this._capStyle);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
		this.setFillColor(this._fillColor);
		this.setJoinStyle(this._joinStyle);
		this.setOutlineDash(this._outlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
		this.setSmoothMethod(this._smoothMethod);
		this.setSmoothSplineSteps(this._splineSteps);
	}

	/**
	 * Mixin common commands.
	 */
	mixin FillColor;
	mixin LineSpecific;
	mixin OutlineDash;
	mixin OutlineWidth;
	mixin Vertex;
}

/**
 * Arrow positions on a canvas line.
 */
enum CanvasLineArrow : string
{
	none  = "none",  /// No arrows.
	first = "first", /// Arrows on the first coordinate.
	last  = "last",  /// Arrow on the last coordinate.
	both  = "both",  /// Arrows on both ends.
}

/**
 * The cap styles of a canvas line.
 */
enum CanvasLineCapStyle : string
{
	butt       = "butt",       /// The cap is just a butt.
	projecting = "projecting", /// The cap projects beyond the line.
	round      = "round",      /// The cap is rounded.
}

/**
 * The join styles of a canvas line.
 */
enum CanvasLineJoinStyle : string
{
	bevel = "bevel", /// The join is bevelled.
	mitre = "miter", /// The join is mitred.
	round = "round", /// The join is round.
}

/**
 * The join styles of a canvas line.
 */
enum CanvasLineSmoothMethod : string
{
	none   = "",       /// No smoothing.
	bezier = "bezier", /// Draw the line using the bezier smooth method.
	raw    = "raw",    /// Draw the line using the raw smooth method.
}

/**
 * A canvas rectangle item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/fillcolor.html, FillColor) $(BR)
 *         $(LINK2 ./common/canvas/outlinecolor.html, OutlineColor) $(BR)
 *         $(LINK2 ./common/canvas/outlinedash.html, OutlineDash) $(BR)
 *         $(LINK2 ./common/canvas/outlinewidth.html, OutlineWidth) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasRectangle : CanvasItem
{
	/**
	 * Create a rectangle from four coordinates.
	 * Use colors from the preset color $(LINK2 ../../color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the rectangle.
	 *     fillColor = The fill color.
	 *     outlineColor = The outline color.
	 *     outlineWidth = The outline width.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/color.html, tkd.widget.color) $(BR)
	 */
	public this(double[] coords, string fillColor = Color.default_, string outlineColor = Color.black, int outlineWidth = 1)
	{
		assert(coords.length == 4, "Four coordinates are needed to draw a rectangle.");

		this._type         = "rectangle";
		this._coords       = coords;
		this._fillColor    = fillColor;
		this._outlineColor = outlineColor;
		this._outlineWidth = outlineWidth;
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	override protected void init(Canvas parent)
	{
		super.init(parent);

		this.setActiveFillColor(this._activeFillColor);
		this.setActiveOutlineColor(this._activeOutlineColor);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setDisabledOutlineColor(this._disabledOutlineColor);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
		this.setFillColor(this._fillColor);
		this.setOutlineColor(this._outlineColor);
		this.setOutlineDash(this._outlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
	}

	/**
	 * Mixin common commands.
	 */
	mixin FillColor;
	mixin OutlineColor;
	mixin OutlineDash;
	mixin OutlineWidth;
}

/**
 * A canvas oval item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/fillcolor.html, FillColor) $(BR)
 *         $(LINK2 ./common/canvas/outlinecolor.html, OutlineColor) $(BR)
 *         $(LINK2 ./common/canvas/outlinedash.html, OutlineDash) $(BR)
 *         $(LINK2 ./common/canvas/outlinewidth.html, OutlineWidth) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasOval : CanvasItem
{
	/**
	 * Create an oval from four coordinates.
	 * Use colors from the preset color $(LINK2 ../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the oval.
	 *     fillColor = The fill color.
	 *     outlineColor = The outline color.
	 *     outlineWidth = The outline width.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/color.html, tkd.widget.color) $(BR)
	 */
	public this(double[] coords, string fillColor = Color.default_, string outlineColor = Color.black, int outlineWidth = 1)
	{
		assert(coords.length == 4, "Four coordinates are needed to draw an oval.");

		this._type         = "oval";
		this._coords       = coords;
		this._fillColor    = fillColor;
		this._outlineColor = outlineColor;
		this._outlineWidth = outlineWidth;
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	override protected void init(Canvas parent)
	{
		super.init(parent);

		this.setActiveFillColor(this._activeFillColor);
		this.setActiveOutlineColor(this._activeOutlineColor);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setDisabledOutlineColor(this._disabledOutlineColor);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
		this.setFillColor(this._fillColor);
		this.setOutlineColor(this._outlineColor);
		this.setOutlineDash(this._outlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
	}

	/**
	 * Mixin common commands.
	 */
	mixin FillColor;
	mixin OutlineColor;
	mixin OutlineDash;
	mixin OutlineWidth;
}

/**
 * A canvas polygon item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/fillcolor.html, FillColor) $(BR)
 *         $(LINK2 ./common/canvas/outlinecolor.html, OutlineColor) $(BR)
 *         $(LINK2 ./common/canvas/outlinedash.html, OutlineDash) $(BR)
 *         $(LINK2 ./common/canvas/outlinewidth.html, OutlineWidth) $(BR)
 *         $(LINK2 ./common/canvas/vertex.html, Vertex) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasPolygon : CanvasItem
{
	/**
	 * Create a polygon from coordinates.
	 * Use colors from the preset color $(LINK2 ../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the polygon.
	 *     fillColor = The fill color.
	 *     outlineColor = The outline color.
	 *     outlineWidth = The outline width.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/color.html, tkd.widget.color) $(BR)
	 */
	public this(double[] coords, string fillColor = Color.default_, string outlineColor = Color.black, int outlineWidth = 1)
	{
		assert(coords.length >= 3, "Three or more coordinates are needed to draw a polygon.");

		this._type         = "polygon";
		this._coords       = coords;
		this._fillColor    = fillColor;
		this._outlineColor = outlineColor;
		this._outlineWidth = outlineWidth;
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	override protected void init(Canvas parent)
	{
		super.init(parent);

		this.setActiveFillColor(this._activeFillColor);
		this.setActiveOutlineColor(this._activeOutlineColor);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setDisabledOutlineColor(this._disabledOutlineColor);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
		this.setFillColor(this._fillColor);
		this.setJoinStyle(this._joinStyle);
		this.setOutlineColor(this._outlineColor);
		this.setOutlineDash(this._outlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
		this.setSmoothMethod(this._smoothMethod);
		this.setSmoothSplineSteps(this._splineSteps);
	}

	/**
	 * Mixin common commands.
	 */
	mixin FillColor;
	mixin OutlineColor;
	mixin OutlineDash;
	mixin OutlineWidth;
	mixin Vertex;
}

/**
 * A canvas text item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/anchor.html, Anchor) $(BR)
 *         $(LINK2 ./common/canvas/fillcolor.html, FillColor) $(BR)
 *         $(LINK2 ./common/canvas/textspecific.html, TextSpecific) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasText : CanvasItem
{
	/**
	 * Create a text item.
	 * Use colors from the preset color $(LINK2 ../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the polygon.
	 *     text = The text.
	 *     fillColor = The fill color.
	 *     anchor = The anchor position of the image.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/color.html, tkd.widget.color) $(BR)
	 */
	public this(double[] coords, string text, string fillColor = Color.default_, string anchor = AnchorPosition.northWest)
	{
		assert(coords.length == 2, "Two coordinates are needed to position text.");

		this._type      = "text";
		this._coords    = coords;
		this._text      = text;
		this._fillColor = fillColor;
		this._anchor    = anchor;
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	override protected void init(Canvas parent)
	{
		super.init(parent);

		this.setActiveFillColor(this._activeFillColor);
		this.setAlignment(this._alignment);
		this.setAnchor(this._anchor);
		this.setAngle(this._angle);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setFillColor(this._fillColor);
		this.setFont(this._font);
		this.setMaxLineLength(this._maxLineLength);
		this.setText(this._text);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Anchor;
	mixin FillColor;
	mixin TextSpecific;
}

/**
 * A canvas widget item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/anchor.html, Anchor) $(BR)
 *         $(LINK2 ./common/canvas/widgetspecific.html, WidgetSpecific) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasWidget : CanvasItem
{
	/**
	 * Create a widget item.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the polygon.
	 *     widget = The widget to use.
	 *     anchor = The anchor position of the image.
	 */
	public this(double[] coords, Widget widget, string anchor = AnchorPosition.northWest)
	{
		assert(coords.length == 2, "Two coordinates are needed to position a widget.");

		this._type   = "window";
		this._coords = coords;
		this._widget = widget;
		this._anchor = anchor;
	}

	/*
	 * Initialise the item.
	 *
	 * Params:
	 *     parent = The parent canvas to initialise against.
	 */
	override protected void init(Canvas parent)
	{
		super.init(parent);

		this.setAnchor(this._anchor);
		this.setHeight(this._height);
		this.setWidget(this._widget);
		this.setWidth(this._width);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Anchor;
	mixin WidgetSpecific;
}
