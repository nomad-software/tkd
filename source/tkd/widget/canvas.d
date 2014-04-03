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
import tkd.widget.color;
import tkd.widget.common.border;
import tkd.widget.common.canvas.anchor;
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
			this._tk.eval("%s configure -background %s", this.id, color);
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
 * See_Also:
 *     $(LINK2 ../element/element.html, tkd.element.element)
 */
private abstract class CanvasItem : Element
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
	 *     This item to aid method chaining.
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
	 *     This item to aid method chaining.
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

	/*
	 * Initialise the item.
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
	private int _startAngle;

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
	public int getStartAngle()
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
	public auto setStartAngle(this T)(int startAngle)
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
	private int[3] _arrowShape;

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
	public int[3] getArrowShape()
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
	public auto setArrowShape(this T)(int[3] arrowshape)
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

