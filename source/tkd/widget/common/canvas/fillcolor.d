/**
 * Fill color module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.fillcolor;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template FillColor()
{
	/**
	 * The fill color.
	 */
	private string _fillColor;

	/**
	 * The active fill color.
	 */
	private string _activeFillColor;

	/**
	 * The disabled fill color.
	 */
	private string _disabledFillColor;

	/**
	 * Get the fill color.
	 *
	 * Returns:
	 *     The fill color;
	 */
	public string getFillColor()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -fill", this._parent.id, this.id);
			this._fillColor = this._tk.getResult!(string);
		}

		return this._fillColor;
	}

	/**
	 * Set the fill color.
	 * Use colors from the preset color $(LINK2 ../../../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *    color = The fill color.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../element/color.html, tkd.widget.color) $(BR)
	 */
	public auto setFillColor(this T)(string color)
	{
		this._fillColor = color;

		if (this._parent && this._fillColor.length)
		{
			this._tk.eval("%s itemconfigure %s -fill {%s}", this._parent.id, this.id, this._fillColor);
		}

		return cast(T) this;
	}

	/**
	 * Get the active fill color.
	 * An item's active state is triggered when the mouse rolls over the item.
	 *
	 * Returns:
	 *     The active fill color;
	 */
	public string getActiveFillColor()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -activefill", this._parent.id, this.id);
			this._activeFillColor = this._tk.getResult!(string);
		}

		return this._activeFillColor;
	}

	/**
	 * Set the active fill color.
	 * An item's active state is triggered when the mouse rolls over the item.
	 * Use colors from the preset color $(LINK2 ../../../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *    color = The fill color.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../element/color.html, tkd.widget.color) $(BR)
	 */
	public auto setActiveFillColor(this T)(string color)
	{
		this._activeFillColor = color;

		if (this._parent && this._activeFillColor.length)
		{
			this._tk.eval("%s itemconfigure %s -activefill {%s}", this._parent.id, this.id, this._activeFillColor);
		}

		return cast(T) this;
	}

	/**
	 * Get the disabled fill color.
	 *
	 * Returns:
	 *     The disabled fill color;
	 */
	public string getDisabledFillColor()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -disabledfill", this._parent.id, this.id);
			this._disabledFillColor = this._tk.getResult!(string);
		}

		return this._disabledFillColor;
	}

	/**
	 * Set the disabled fill color.
	 * Use colors from the preset color $(LINK2 ../../../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *    color = The fill color.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../element/color.html, tkd.widget.color) $(BR)
	 */
	public auto setDisabledFillColor(this T)(string color)
	{
		this._disabledFillColor = color;

		if (this._parent && this._disabledFillColor.length)
		{
			this._tk.eval("%s itemconfigure %s -disabledfill {%s}", this._parent.id, this.id, this._disabledFillColor);
		}

		return cast(T) this;
	}
}
