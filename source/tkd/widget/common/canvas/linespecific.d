/**
 * Line specific module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.linespecific;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template LineSpecific()
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
	 * Get the arrow position.
	 *
	 * Returns:
	 *     The arrow position.
	 */
	public string getArrowPosition()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -arrow", this._parent.id, this.id);
			this._arrowPosition = this._tk.getResult!(string);
		}

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
	 *     $(LINK2 ../../canvas.html#CanvasLineArrow, tkd.widget.canvas.CanvasLineArrow)
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
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -arrowshape", this._parent.id, this.id);
			this._arrowShape = this._tk.getResult!(string).map!(to!(uint)).array;
		}

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
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -capstyle", this._parent.id, this.id);
			this._capStyle = this._tk.getResult!(string);
		}

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
	 *     $(LINK2 ../../canvas.html#CanvasLineCapStyle, tkd.widget.canvas.CanvasLineCapStyle)
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
}
