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
import tkd.element.element;
import tkd.element.uielement;
import tkd.image.image;
import tkd.widget.anchorposition;
import tkd.widget.color;
import tkd.widget.common.border;
import tkd.widget.common.canvas.anchor;
import tkd.widget.common.canvas.bind;
import tkd.widget.common.canvas.fillcolor;
import tkd.widget.common.canvas.outlinecolor;
import tkd.widget.common.canvas.outlinedash;
import tkd.widget.common.canvas.outlinewidth;
import tkd.widget.common.canvas.vertex;
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
	 *     backgroundColor = The background color.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	public this(UiElement parent = null, string backgroundColor = Color.default_)
	{
		super(parent);
		this._elementId = "canvas";

		this._tk.eval("canvas %s", this.id);

		this.setBorderWidth(1);
		this.setRelief(ReliefStyle.sunken);
		this.setBackgroundColor(backgroundColor);
	}

	/**
	 * Set the background color.
	 * Use colors from the preset color $(LINK2 ../../color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     color = The background color.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./color.html, tkd.widget.color) $(BR)
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
	 * Tag an item at coordinates. If more than one item is at the same closest 
	 * distance (e.g. two items overlap the point), then the top-most of these 
	 * items (the last one in the display list) is used. If radius is 
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
	public auto tagItemAt(this T)(string tag, int xPos, int yPos, uint radius = 0)
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
	 *    enclosedFully = Specifies if the item have to be enclosed fully or not.
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
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/canvas/bind.html, Bind) $(BR)
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
	private int[] _coords;

	/**
	 * The state of the item.
	 */
	private string _state;

	/**
	 * The tags associated with this item.
	 */
	private string[] _tags;

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
	 *     This item to aid method chaining.
	 */
	public auto setCoords(this T)(int[] coords)
	{
		assert(coords.length >= 2, "Not enough coordinates specified.");

		this._coords = coords;

		if (this._parent && this._coords.length)
		{
			this._tk.eval("%s coords %s [list %s]", this.parent.id, this.id, this._coords.map!(to!(string)).join(" "));
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
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state) $(BR)
	 */
	public auto setState(this T)(string state)
	{
		this._state = state;

		if (this._parent && this._state.length)
		{
			this._tk.eval("%s itemconfigure %s -state {%s}", this._parent.id, this.id, this._state);
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

		if (this._parent)
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
			this._tk.eval("%s addtag %s withtag %s", this._parent.id, tag, this.id);
			this._tags = this.getTags();
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
			this._tk.eval("%s dtag %s %s", this._parent.id, this.id, tag);
			this._tags = this.getTags();
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
			this._tk.eval("%s delete %s", this.parent.id, this.id);
		}

		super.destroy();
	}

	/**
	 * Mixin common commands.
	 */
	mixin Bind;
}

/**
 * A canvas arc item.
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
class CanvasArc : CanvasItem
{
	/**
	 * The style of the arc.
	 */
	private string _style;

	/**
	 * The extent of the arc.
	 */
	private int _extent;

	/**
	 * The start angle of the arc.
	 */
	private double _startAngle = 0.0;

	/**
	 * Create an arc.
	 * Use colors from the preset color $(LINK2 ../../color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates of the outer elipse.
	 *     style = The style of arc.
	 *     fillColor = The fill color.
	 *     outlineColor = The outline color.
	 *     outlineWidth = The outline width.
	 *
	 * See_Also:
	 *     $(LINK2 ./color.html, tkd.widget.color) $(BR)
	 *     $(LINK2 ./canvas.html#CanvasArcStyle, tkd.widget.canvas.CanvasArcStyle)
	 */
	public this(int[] coords, string style = CanvasArcStyle.pie, string fillColor = Color.default_, string outlineColor = Color.black, int outlineWidth = 1)
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

		this.setFillColor(this._fillColor);
		this.setActiveFillColor(this._activeFillColor);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setOutlineColor(this._outlineColor);
		this.setActiveOutlineColor(this._activeOutlineColor);
		this.setDisabledOutlineColor(this._disabledOutlineColor);
		this.setOutlineDash(this._outlineDash);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);

		this.setStyle(this._style);
		this.setExtent(this._extent);
		this.setStartAngle(this._startAngle);
	}

	/**
	 * Get the style of the arc.
	 *
	 * Returns:
	 *     The style of the arc;
	 */
	public string getStyle()
	{
		return this._style;
	}

	/**
	 * Specifies how to draw the arc. If type is pie (the default) then the 
	 * arc's region is defined by a section of the oval's perimeter plus two 
	 * line segments, one between the center of the oval and each end of the 
	 * perimeter section. If type is chord then the arc's region is defined by 
	 * a section of the oval's perimeter plus a single line segment connecting 
	 * the two end points of the perimeter section. If type is arc then the 
	 * arc's region consists of a section of the perimeter alone. In this last 
	 * case the fill color is ignored.
	 *
	 * Params:
	 *    style = The style of the arc.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setStyle(this T)(string style)
	{
		this._style = style;

		if (this._parent && this._style.length)
		{
			this._tk.eval("%s itemconfigure %s -style {%s}", this._parent.id, this.id, this._style);
		}

		return cast(T) this;
	}

	/**
	 * Get the extent of the arc.
	 *
	 * Returns:
	 *     The extent of the arc;
	 */
	public int getExtent()
	{
		return this._extent;
	}

	/**
	 * Specifies the size of the angular range occupied by the arc. The arc's 
	 * range extends for degrees counter-clockwise from the starting angle. 
	 * Degrees may be negative. If it is greater than 360 or less than -360, 
	 * then degrees modulo 360 is used as the extent.
	 *
	 * Params:
	 *    extent = The extent of the arc.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setExtent(this T)(int extent)
	{
		this._extent = extent;

		if (this._parent && this._extent > 0)
		{
			this._tk.eval("%s itemconfigure %s -extent %s", this._parent.id, this.id, this._extent);
		}

		return cast(T) this;
	}

	/**
	 * Get the start angle of the arc.
	 *
	 * Returns:
	 *     The start angle of the arc;
	 */
	public double getStartAngle()
	{
		return this._startAngle;
	}

	/**
	 * Specifies the beginning of the angular range occupied by the arc. 
	 * Degrees is given in units of degrees measured counter-clockwise from the 
	 * 3-o'clock position; it may be either positive or negative.
	 *
	 * Params:
	 *    startAngle = The start angle of the arc.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setStartAngle(this T)(double startAngle)
	{
		this._startAngle = startAngle;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -start %s", this._parent.id, this.id, this._startAngle);
		}

		return cast(T) this;
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
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasImage : CanvasItem
{
	/**
	 * The image.
	 */
	private Image _image;

	/**
	 * The active image.
	 */
	private Image _activeImage;

	/**
	 * The disabled image.
	 */
	private Image _disabledImage;

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
	public this(int[] coords, Image image, string anchor = AnchorPosition.northWest)
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
	 * Get the image.
	 *
	 * Returns:
	 *     The image;
	 */
	public Image getImage()
	{
		return this._image;
	}

	/**
	 * Set the image.
	 *
	 * Params:
	 *    image = The image.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 */
	public auto setImage(this T)(Image image)
	{
		this._image = image;

		if (this._parent && this._image)
		{
			this._tk.eval("%s itemconfigure %s -image %s", this._parent.id, this.id, this._image.id);
		}

		return cast(T) this;
	}

	/**
	 * Get the active image.
	 *
	 * Returns:
	 *     The active image;
	 */
	public Image getActiveImage()
	{
		return this._activeImage;
	}

	/**
	 * Set the active image.
	 *
	 * Params:
	 *    image = The active image.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 */
	public auto setActiveImage(this T)(Image image)
	{
		this._activeImage = image;

		if (this._parent && this._activeImage)
		{
			this._tk.eval("%s itemconfigure %s -activeimage %s", this._parent.id, this.id, this._activeImage.id);
		}

		return cast(T) this;
	}

	/**
	 * Get the disabled image.
	 *
	 * Returns:
	 *     The disabled image;
	 */
	public Image getDisabledImage()
	{
		return this._disabledImage;
	}

	/**
	 * Set the disabled image.
	 *
	 * Params:
	 *    image = The disabled image.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 */
	public auto setDisabledImage(this T)(Image image)
	{
		this._disabledImage = image;

		if (this._parent && this._disabledImage)
		{
			this._tk.eval("%s itemconfigure %s -disabledimage %s", this._parent.id, this.id, this._disabledImage.id);
		}

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Anchor;
}

/**
 * A canvas line item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/fillcolor.html, FillColor) $(BR)
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
	 * The arrow position on the line.
	 */
	private string _arrowPosition;

	/**
	 * The shape of any arrows used.
	 */
	private uint[3] _arrowShape;

	/**
	 * The style of the end caps.
	 */
	private string _capStyle;

	/**
	 * Create a line from coordinates.
	 * Use colors from the preset color $(LINK2 ../../color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the line.
	 *     fillColor = The color of the line.
	 *     outlineWidth = The outline width.
	 *
	 * See_Also:
	 *     $(LINK2 ./color.html, tkd.widget.color) $(BR)
	 */
	public this(int[] coords, string fillColor = Color.black, int outlineWidth = 1)
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

		this.setFillColor(this._fillColor);
		this.setActiveFillColor(this._activeFillColor);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setOutlineDash(this._outlineDash);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
		this.setJoinStyle(this._joinStyle);
		this.setSmoothMethod(this._smoothMethod);
		this.setSmoothSplineSteps(this._splineSteps);

		this.setArrowPosition(this._arrowPosition);
		this.setArrowShape(this._arrowShape);
		this.setCapStyle(this._capStyle);
	}

	/**
	 * Get the arrow position.
	 *
	 * Returns:
	 *     The arrow position.
	 */
	public string getArrowPosition()
	{
		return this._arrowPosition;
	}

	/**
	 * Indicates whether or not arrowheads are to be drawn at one or both ends 
	 * of the line.
	 *
	 * Params:
	 *    arrowPosition = The position of arrows on the line.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./canvas.html#CanvasLineArrow, tkd.widget.canvas.CanvasLineArrow)
	 */
	public auto setArrowPosition(this T)(string arrowPosition)
	{
		this._arrowPosition = arrowPosition;

		if (this._parent && this._arrowPosition.length)
		{
			this._tk.eval("%s itemconfigure %s -arrow {%s}", this._parent.id, this.id, this._arrowPosition);
		}

		return cast(T) this;
	}

	/**
	 * Get the arrow shape.
	 *
	 * Returns:
	 *     The arrow shape.
	 */
	public uint[3] getArrowShape()
	{
		return this._arrowShape;
	}

	/**
	 * This option indicates how to draw arrowheads. The shape argument must be 
	 * a list with three elements, each specifying a distance. The first 
	 * element of the list gives the distance along the line from the neck of 
	 * the arrowhead to its tip. The second element gives the distance along 
	 * the line from the trailing points of the arrowhead to the tip, and the 
	 * third element gives the distance from the outside edge of the line to 
	 * the trailing points.
	 *
	 * Params:
	 *    arrowshape = The arrow shape.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setArrowShape(this T)(uint[3] arrowshape)
	{
		this._arrowShape = arrowshape;

		if (this._parent && this._arrowShape[].all!("a > 0"))
		{
			this._tk.eval("%s itemconfigure %s -arrowshape [list %s]", this._parent.id, this.id, this._arrowShape[].map!(to!(string)).join(" "));
		}

		return cast(T) this;
	}

	/**
	 * Get the cap style.
	 *
	 * Returns:
	 *     The cap style.
	 */
	public string getCapStyle()
	{
		return this._capStyle;
	}

	/**
	 * Specifies the ways in which caps are to be drawn at the endpoints of the 
	 * line. When arrowheads are drawn the cap style is ignored.
	 *
	 * Params:
	 *    capStyle = The cap style.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./canvas.html#CanvasLineCapStyle, tkd.widget.canvas.CanvasLineCapStyle)
	 */
	public auto setCapStyle(this T)(string capStyle)
	{
		this._capStyle = capStyle;

		if (this._parent && this._capStyle.length)
		{
			this._tk.eval("%s itemconfigure %s -capstyle {%s}", this._parent.id, this.id, this._capStyle);
		}

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin FillColor;
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
	 *     $(LINK2 ./color.html, tkd.widget.color) $(BR)
	 */
	public this(int[] coords, string fillColor = Color.default_, string outlineColor = Color.black, int outlineWidth = 1)
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

		this.setFillColor(this._fillColor);
		this.setActiveFillColor(this._activeFillColor);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setOutlineColor(this._outlineColor);
		this.setActiveOutlineColor(this._activeOutlineColor);
		this.setDisabledOutlineColor(this._disabledOutlineColor);
		this.setOutlineDash(this._outlineDash);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
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
	 * Use colors from the preset color $(LINK2 ../../color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the oval.
	 *     fillColor = The fill color.
	 *     outlineColor = The outline color.
	 *     outlineWidth = The outline width.
	 *
	 * See_Also:
	 *     $(LINK2 ./color.html, tkd.widget.color) $(BR)
	 */
	public this(int[] coords, string fillColor = Color.default_, string outlineColor = Color.black, int outlineWidth = 1)
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

		this.setFillColor(this._fillColor);
		this.setActiveFillColor(this._activeFillColor);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setOutlineColor(this._outlineColor);
		this.setActiveOutlineColor(this._activeOutlineColor);
		this.setDisabledOutlineColor(this._disabledOutlineColor);
		this.setOutlineDash(this._outlineDash);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
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
	 * Use colors from the preset color $(LINK2 ../../color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the polygon.
	 *     fillColor = The fill color.
	 *     outlineColor = The outline color.
	 *     outlineWidth = The outline width.
	 *
	 * See_Also:
	 *     $(LINK2 ./color.html, tkd.widget.color) $(BR)
	 */
	public this(int[] coords, string fillColor = Color.default_, string outlineColor = Color.black, int outlineWidth = 1)
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

		this.setFillColor(this._fillColor);
		this.setActiveFillColor(this._activeFillColor);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setOutlineColor(this._outlineColor);
		this.setActiveOutlineColor(this._activeOutlineColor);
		this.setDisabledOutlineColor(this._disabledOutlineColor);
		this.setOutlineDash(this._outlineDash);
		this.setActiveOutlineDash(this._activeOutlineDash);
		this.setDisabledOutlineDash(this._disabledOutlineDash);
		this.setOutlineDashOffset(this._outlineDashOffset);
		this.setOutlineWidth(this._outlineWidth);
		this.setActiveOutlineWidth(this._activeOutlineWidth);
		this.setDisabledOutlineWidth(this._disabledOutlineWidth);
		this.setJoinStyle(this._joinStyle);
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
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasText : CanvasItem
{
	/**
	 * The angle of the text.
	 */
	private double _angle = 0.0;

	/**
	 * The font.
	 */
	private string _font;

	/**
	 * The alignment.
	 */
	private string _alignment;

	/**
	 * The text.
	 */
	private string _text;

	/**
	 * The maximum line length.
	 */
	private int _maxLineLength;

	/**
	 * Create a text item.
	 * Use colors from the preset color $(LINK2 ../../color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the polygon.
	 *     text = The text.
	 *     fillColor = The fill color.
	 *     anchor = The anchor position of the image.
	 *
	 * See_Also:
	 *     $(LINK2 ./color.html, tkd.widget.color) $(BR)
	 */
	public this(int[] coords, string text, string fillColor = Color.default_, string anchor = AnchorPosition.northWest)
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

		this.setFillColor(this._fillColor);
		this.setActiveFillColor(this._activeFillColor);
		this.setDisabledFillColor(this._disabledFillColor);
		this.setAnchor(this._anchor);

		this.setAngle(this._angle);
		this.setFont(this._font);
		this.setAlignment(this._alignment);
		this.setText(this._text);
		this.setMaxLineLength(this._maxLineLength);
	}

	/**
	 * Get the text angle.
	 *
	 * Returns:
	 *     The text angle.
	 */
	public double getAngle()
	{
		return this._angle;
	}

	/**
	 * Specifies how many degrees to rotate the text anticlockwise about the 
	 * positioning point for the text; it may have any floating-point value 
	 * from 0.0 to 360.0. For example, if rotationDegrees is 90, then the text 
	 * will be drawn vertically from bottom to top. This option defaults to 
	 * 0.0. Degrees is given in units of degrees measured counter-clockwise 
	 * from the 3-o'clock position; it may be either positive or negative.
	 *
	 * Params:
	 *    angle = The text angle.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setAngle(this T)(double angle)
	{
		this._angle = angle;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -angle %s", this._parent.id, this.id, this._angle);
		}

		return cast(T) this;
	}

	/**
	 * Get the font.
	 *
	 * Returns:
	 *     The font.
	 */
	public string getFont()
	{
		return this._font;
	}

	/**
	 * Specifies the font to use for the text item.
	 *
	 * Params:
	 *    font = The font.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setFont(this T)(string font)
	{
		this._font = font;

		if (this._parent && this._font.length)
		{
			this._tk.eval("%s itemconfigure %s -font {%s}", this._parent.id, this.id, this._font);
		}

		return cast(T) this;
	}

	/**
	 * Get the alignment
	 *
	 * Returns:
	 *     The alignment.
	 */
	public string getAlignment()
	{
		return this._alignment;
	}

	/**
	 * Specifies how to justify the text within its bounding region.
	 *
	 * Params:
	 *    alignment = The alignment.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./alignment.html, tkd.widget.alignment)
	 */
	public auto setAlignment(this T)(string alignment)
	{
		this._alignment = alignment;

		if (this._parent && this._alignment.length)
		{
			this._tk.eval("%s itemconfigure %s -justify {%s}", this._parent.id, this.id, this._alignment);
		}

		return cast(T) this;
	}

	/**
	 * Get the text.
	 *
	 * Returns:
	 *     The text.
	 */
	public string getText()
	{
		return this._text;
	}

	/**
	 * Specifies the characters to be displayed in the text item.  Newline 
	 * characters cause line breaks.
	 *
	 * Params:
	 *    text = The text.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setText(this T)(string text)
	{
		this._text = text;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -text {%s}", this._parent.id, this.id, this._text);
		}

		return cast(T) this;
	}

	/**
	 * Get max line length.
	 *
	 * Returns:
	 *     The max line length.
	 */
	public int getMaxLineLength()
	{
		return this._maxLineLength;
	}

	/**
	 * Specifies a maximum line length for the text. If this option is zero 
	 * (the default) the text is broken into lines only at newline characters.  
	 * However, if this option is non-zero then any line that would be longer 
	 * than line length is broken just before a space character to make the 
	 * line shorter than lineLength; the space character is treated as if it 
	 * were a newline character.
	 *
	 * Params:
	 *    maxLineLength = The max line length.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setMaxLineLength(this T)(int maxLineLength)
	{
		this._maxLineLength = maxLineLength;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -width %s", this._parent.id, this.id, this._maxLineLength);
		}

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Anchor;
	mixin FillColor;
}

/**
 * A canvas widget item.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this canvas item.
 *     $(P
 *         $(LINK2 ./common/canvas/anchor.html, Anchor) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./canvas.html#CanvasItem, tkd.widget.canvas.CanvasItem)
 */
class CanvasWidget : CanvasItem
{
	/**
	 * The widget to use.
	 */
	private Widget _widget;

	/**
	 * The widget width.
	 */
	private int _width;

	/**
	 * The widget height.
	 */
	private int _height;

	/**
	 * Create a widget item.
	 *
	 * Params:
	 *     coords = The coordinates where to draw the polygon.
	 *     widget = The widget to use.
	 *     anchor = The anchor position of the image.
	 */
	public this(int[] coords, Widget widget, string anchor = AnchorPosition.northWest)
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

		this.setWidget(this._widget);
		this.setWidth(this._width);
		this.setHeight(this._height);
	}

	/**
	 * Get the widget.
	 *
	 * Returns:
	 *     The widget.
	 */
	public Widget getWidget()
	{
		return this._widget;
	}

	/**
	 * Specifies the widget to associate with this item. The widget specified 
	 * must either be a child of the canvas widget or a child of some ancestor 
	 * of the canvas widget.
	 *
	 * Params:
	 *    widget = The widget.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setWidget(this T)(Widget widget)
	{
		this._widget = widget;

		if (this._parent && this._widget)
		{
			this._tk.eval("%s itemconfigure %s -window %s", this._parent.id, this.id, this._widget.id);
		}

		return cast(T) this;
	}

	/**
	 * Get the widget width.
	 *
	 * Returns:
	 *     The widget width.
	 */
	public int getWidth()
	{
		return this._width;
	}

	/**
	 * Specifies the width to assign to the item's widget. If this option is 
	 * not specified, or if it is specified as zero, then the widget is given 
	 * whatever width it requests internally.
	 *
	 * Params:
	 *    width = The widget width.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setWidth(this T)(int width)
	{
		this._width = width;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -width %s", this._parent.id, this.id, this._width);
		}

		return cast(T) this;
	}

	/**
	 * Get the widget height.
	 *
	 * Returns:
	 *     The widget height.
	 */
	public int getHeight()
	{
		return this._height;
	}

	/**
	 * Specifies the height to assign to the item's widget. If this option is 
	 * not specified, or if it is specified as zero, then the widget is given 
	 * whatever height it requests internally.
	 *
	 * Params:
	 *    height = The widget height.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setHeight(this T)(int height)
	{
		this._height = height;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -height %s", this._parent.id, this.id, this._height);
		}

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Anchor;
}
