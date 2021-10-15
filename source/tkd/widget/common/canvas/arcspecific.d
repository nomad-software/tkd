/**
 * Arc specific module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.arcspecific;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template ArcSpecific()
{
	import std.typecons : Nullable;

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
	private Nullable!(double) _startAngle;

	/**
	 * Get the style of the arc.
	 *
	 * Returns:
	 *     The style of the arc;
	 */
	public string getStyle()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -style", this._parent.id, this.id);
			this._style = this._tk.getResult!(string);
		}

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
	 *
	 * See_Also:
	 *     $(LINK2 ../../canvas.html#CanvasArcStyle, tkd.widget.canvas.CanvasArcStyle)
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
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -extent", this._parent.id, this.id);
			this._extent = this._tk.getResult!(int);
		}

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
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -start", this._parent.id, this.id);
			this._startAngle = this._tk.getResult!(double);
		}

		return this._startAngle.isNull ? 0.0 : this._startAngle.get;
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
	public auto setStartAngle(this T, A)(A startAngle) if (is(A == double) || is(A == Nullable!(double)))
	{
		static if (is(A == Nullable!(double)))
		{
			if (startAngle.isNull)
			{
				return cast(T) this;
			}
		}

		this._startAngle = startAngle;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -start %s", this._parent.id, this.id, this._startAngle);
		}

		return cast(T) this;
	}
}
