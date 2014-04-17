/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.widget;

/**
 * Imports.
 */
import std.algorithm;
import std.array;
import std.string;
import tkd.element.element;
import tkd.element.uielement;
import tkd.widget.anchorposition;
import tkd.widget.state;

/**
 * The widget base class.
 *
 * See_Also:
 *     $(LINK2 ../element/uielement.html, tkd.element.uielement)
 */
abstract class Widget : UiElement
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement)
	 */
	public this(UiElement parent = null)
	{
		super(parent);

		this._elementId = "widget";
	}

	/**
	 * Set the widget's state.
	 *
	 * Params:
	 *     state = An array of widget states.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state)
	 */
	public auto setState(this T)(string[] state)
	{
		this._tk.eval("%s state { %s }", this.id, state.join(" "));

		return cast(T) this;
	}

	/**
	 * Get the widget's state.
	 *
	 * Returns:
	 *     An array of widget states.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state)
	 */
	public string[] getState()
	{
		this._tk.eval("%s state", this.id);
		return this._tk.getResult!(string).split();
	}

	/**
	 * Test if a widget is in a particular state.
	 *
	 * Params:
	 *     state = An array of widget states.
	 *
	 * Returns:
	 *     true is the widget is in that state, false if not.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state)
	 */
	public bool inState(string[] state)
	{
		if (state.canFind(State.normal))
		{
			throw new Exception("State.normal is not supported by inState method.");
		}

		this._tk.eval("%s instate { %s }", this.id, state.join(" "));
		return this._tk.getResult!(int) == 1;
	}

	/**
	 * Remove the widget's state.
	 *
	 * Params:
	 *     state = An array of widget states.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state)
	 */
	public auto removeState(this T)(string[] state)
	{
		this._tk.eval("%s state { !%s }", this.id, state.join(" !"));

		return cast(T) this;
	}

	/**
	 * Reset the widget's state to default.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state)
	 */
	public auto resetState(this T)()
	{
		this.removeState(this.getState());

		return cast(T) this;
	}

	/**
	 * Set the widget's style.
	 *
	 * Params:
	 *     style = A widget style.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./style.html, tkd.widget.style)
	 */
	public auto setStyle(this T)(string style)
	{
		this._tk.eval("%s configure -style %s", this.id, style);

		return cast(T) this;
	}

	/**
	 * Get the widget's style.
	 *
	 * Returns:
	 *     The widget's style.
	 *
	 * See_Also:
	 *     $(LINK2 ./style.html, tkd.widget.style)
	 */
	public string getStyle()
	{
		this._tk.eval("%s cget -style", this.id);
		if (this._tk.getResult!(string).empty())
		{
			return this.getClass();
		}
		return this._tk.getResult!(string);
	}

	/**
	 * Set if the widget can recieve focus during keyboard traversal.
	 *
	 * Params:
	 *     focus = A focus setting.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./keyboardfocus.html, tkd.widget.keyboardfocus)
	 */
	public auto setKeyboardFocus(this T)(string focus)
	{
		this._tk.eval("%s configure -takefocus %s", this.id, focus);

		return cast(T) this;
	}

	/**
	 * Get if the widget can recieve focus during keyboard traversal.
	 *
	 * Returns:
	 *     The widget's focus setting.
	 *
	 * See_Also:
	 *     $(LINK2 ./keyboardfocus.html, tkd.widget.keyboardfocus)
	 */
	public string getKeyboardFocus()
	{
		this._tk.eval("%s cget -takefocus", this.id);
		return this._tk.getResult!(string);
	}

	/**
	 * Geometry method for loosely placing this widget inside its parent using 
	 * a web browser model. Widgets flow around each other in the available space.
	 *
	 * Params:
	 *     outerPadding = The amound of padding to add around the widget.
	 *     innerPadding = The amound of padding to add inside the widget.
	 *     side = The side to place the widget inside its parent.
	 *     fill = The space to fill inside its parent.
	 *     anchor = The anchor position of the widget inside its parent.
	 *     expand = Whether or not to expand to fill the entire given space.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html#UiElement.enableGeometryAutoSize, tkd.element.uielement.UiElement.enableGeometryAutoSize) $(BR)
	 *     $(LINK2 ./anchorposition.html, tkd.widget.anchorposition) $(BR)
	 *     $(LINK2 ./widget.html#GeometryFill, tkd.widget.widget.GeometryFill) $(BR)
	 *     $(LINK2 ./widget.html#GeometrySide, tkd.widget.widget.GeometrySide) $(BR)
	 */
	public auto pack(this T)(int outerPadding = 0, int innerPadding = 0, string side = GeometrySide.top, string fill = GeometryFill.none, string anchor = AnchorPosition.center, bool expand = false)
	{
		this._tk.eval("pack %s -padx %s -pady %s -ipadx %s -ipady %s -side {%s} -fill {%s} -anchor {%s} -expand %s", this.id, outerPadding, outerPadding, innerPadding, innerPadding, side, fill, anchor, expand);

		return cast(T) this;
	}

	/**
	 * Geometry method for placing this widget inside its parent using an 
	 * imaginary grid. Somewhat more direct and intuitive than pack. Choose 
	 * grid for tabular layouts, and when there's no good reason to choose 
	 * something else.
	 *
	 * If a widget's cell is larger than its default dimensions, the sticky 
	 * parameter may be used to position (or stretch) the widget within its 
	 * cell. The sticky argument is a string that contains zero or more of the 
	 * characters n, s, e or w. Each letter refers to a side (north, south, 
	 * east, or west) that the widget will 'stick' to. If both n and s (or e 
	 * and w) are specified, the slave will be stretched to fill the entire 
	 * height (or width) of its cell. The sticky parameter subsumes the 
	 * combination of anchor and fill that is used by pack. The default is an 
	 * empty string, which causes the widget to be centered in its cell, at its 
	 * default size. The $(LINK2 ./anchorposition.html, anchorposition) enum 
	 * may be of use here but doesn't provide all combinations.
	 *
	 * Params:
	 *     column = The column in which to place this widget.
	 *     row = The row in which to place this widget.
	 *     outerPadding = The amound of padding to add around the widget.
	 *     innerPadding = The amound of padding to add inside the widget.
	 *     columnSpan = The amount of column this widget should span across.
	 *     rowSpan = The amount of rows this widget should span across.
	 *     sticky = Which edges of the cell the widget should touch. See note above.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * Caveats:
	 *     In order for a gridded UI to be fully dynamic to expand and contract 
	 *     when resizing elements, you must to assign a weight to at least one 
	 *     column and row using $(LINK2 
	 *     ../element/uielement.html#UiElement.configureGeometryColumn, 
	 *     configureGeometryColumn) and $(LINK2 
	 *     ../element/uielement.html#UiElement.configureGeometryRow, 
	 *     configureGeometryRow) respectively.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html#UiElement.configureGeometryColumn, tkd.element.uielement.UiElement.configureGeometryColumn) $(BR)
	 *     $(LINK2 ../element/uielement.html#UiElement.configureGeometryRow, tkd.element.uielement.UiElement.configureGeometryRow) $(BR)
	 *     $(LINK2 ../element/uielement.html#UiElement.enableGeometryAutoSize, tkd.element.uielement.UiElement.enableGeometryAutoSize) $(BR)
	 *     $(LINK2 ./anchorposition.html, tkd.widget.anchorposition) $(BR)
	 */
	public auto grid(this T)(int column, int row, int outerPadding = 0, int innerPadding = 0, int columnSpan = 1, int rowSpan = 1, string sticky = "")
	{
		this._tk.eval("grid %s -column %s -row %s -padx %s -pady %s -ipadx %s -ipady %s -columnspan %s -rowspan %s -sticky {%s}", this.id, column, row, outerPadding, outerPadding, innerPadding, innerPadding, columnSpan, rowSpan, sticky);

		return cast(T) this;
	}

	/**
	 * Geometry method for placing this widget inside its parent using absolute 
	 * positioning.
	 *
	 * Params:
	 *     xPos = The horizontal position of the widget inside its parent.
	 *     yPos = The vertical position of the widget inside its parent.
	 *     width = The width of the widget.
	 *     height = The height of the widget.
	 *     anchor = The anchor position of the widget inside its parent.
	 *     borderMode = How the widget interacts with the parent's border.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./anchorposition.html, tkd.widget.anchorposition) $(BR)
	 *     $(LINK2 ./widget.html#GeometryBorderMode, tkd.widget.widget.GeometryBorderMode) $(BR)
	 */
	public auto place(this T)(int xPos, int yPos, int width, int height, string anchor = AnchorPosition.northWest, string borderMode = GeometryBorderMode.inside)
	{
		this._tk.eval("place %s -x %s -y %s -width %s -height %s -anchor {%s} -bordermode {%s}", this.id, xPos, yPos, width, height, anchor, borderMode);

		return cast(T) this;
	}

	/**
	 * Geometry method for placing this widget inside its parent using relative 
	 * positioning. In this case the position and size is specified as a 
	 * floating-point number between 0.0 and 1.0 relative to the height of the 
	 * parent. 0.5 means the widget will be half as high as the parent and 1.0 
	 * means the widget will have the same height as the parent, and so on.
	 *
	 * Params:
	 *     relativeXPos = The relative horizontal position of the widget inside its parent.
	 *     relativeYPos = The relative vertical position of the widget inside its parent.
	 *     relativeWidth = The relative width of the widget.
	 *     relativeHeight = The relative height of the widget.
	 *     anchor = The anchor position of the widget inside its parent.
	 *     borderMode = How the widget interacts with the parent's border.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./anchorposition.html, tkd.widget.anchorposition) $(BR)
	 *     $(LINK2 ./widget.html#GeometryBorderMode, tkd.widget.widget.GeometryBorderMode) $(BR)
	 */
	public auto place(this T)(double relativeXPos, double relativeYPos, double relativeWidth, double relativeHeight, string anchor = AnchorPosition.northWest, string borderMode = GeometryBorderMode.inside)
	{
		assert(relativeXPos >= 0 && relativeXPos <= 1);
		assert(relativeYPos >= 0 && relativeYPos <= 1);
		assert(relativeWidth >= 0 && relativeWidth <= 1);
		assert(relativeHeight >= 0 && relativeHeight <= 1);

		this._tk.eval("place %s -relx %s -rely %s -relwidth %s -relheight %s -anchor {%s} -bordermode {%s}", this.id, relativeXPos, relativeYPos, relativeWidth, relativeHeight, anchor, borderMode);

		return cast(T) this;
	}
}

/**
 * Side values for widget geometry layout.
 */
enum GeometrySide : string
{
	left   = "left",   /// Set geometry to the left.
	right  = "right",  /// Set geometry to the right.
	top    = "top",    /// Set geometry to the top.
	bottom = "bottom", /// Set geometry to the bottom.
}

/**
 * Fill values for widget geometry layout.
 */
enum GeometryFill : string
{
	none = "none", /// No filling.
	x    = "x",    /// Fill the available horizontal space.
	y    = "y",    /// Fill the available vertical space.
	both = "both", /// Fill all available space.
}

/**
 * Interaction modes for parent borders.
 */
enum GeometryBorderMode : string
{
	inside  = "inside",  /// Take into consideration the border when placing widgets.
	outside = "outside", /// Don't take consideration the border when placing widgets.
	ignore  = "ignore",  /// Ignore borders.
}
