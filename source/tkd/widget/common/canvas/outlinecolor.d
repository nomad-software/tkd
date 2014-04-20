/**
 * Outline color module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.outlinecolor;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template OutlineColor()
{
	/**
	 * The outline color.
	 */
	private string _outlineColor;

	/**
	 * The active outline color.
	 */
	private string _activeOutlineColor;

	/**
	 * The disabled outline color.
	 */
	private string _disabledOutlineColor;

	/**
	 * Get the outline color.
	 *
	 * Returns:
	 *     The outline color;
	 */
	public string getOutlineColor()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -outline", this._parent.id, this.id);
			this._outlineColor = this._tk.getResult!(string);
		}

		return this._outlineColor;
	}

	/**
	 * Set the outline color.
	 * Use colors from the preset color $(LINK2 ../../../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *    color = The outline color.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../element/color.html, tkd.widget.color) $(BR)
	 */
	public auto setOutlineColor(this T)(string color)
	{
		this._outlineColor = color;

		if (this._parent && this._outlineColor.length)
		{
			this._tk.eval("%s itemconfigure %s -outline {%s}", this._parent.id, this.id, this._outlineColor);
		}

		return cast(T) this;
	}

	/**
	 * Get the active outline color.
	 * An item's active state is triggered when the mouse rolls over the item.
	 *
	 * Returns:
	 *     The active outline color;
	 */
	public string getActiveOutlineColor()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -activeoutline", this._parent.id, this.id);
			this._activeOutlineColor = this._tk.getResult!(string);
		}

		return this._activeOutlineColor;
	}

	/**
	 * Set the active outline color.
	 * An item's active state is triggered when the mouse rolls over the item.
	 * Use colors from the preset color $(LINK2 ../../../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *    color = The outline color.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../element/color.html, tkd.widget.color) $(BR)
	 */
	public auto setActiveOutlineColor(this T)(string color)
	{
		this._activeOutlineColor = color;

		if (this._parent && this._activeOutlineColor.length)
		{
			this._tk.eval("%s itemconfigure %s -activeoutline {%s}", this._parent.id, this.id, this._activeOutlineColor);
		}

		return cast(T) this;
	}

	/**
	 * Get the disabled outline color.
	 *
	 * Returns:
	 *     The disabled outline color;
	 */
	public string getDisabledOutlineColor()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -disabledoutline", this._parent.id, this.id);
			this._disabledOutlineColor = this._tk.getResult!(string);
		}

		return this._disabledOutlineColor;
	}

	/**
	 * Set the disabled outline color.
	 * Use colors from the preset color $(LINK2 ../../../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *    color = The outline color.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../element/color.html, tkd.widget.color) $(BR)
	 */
	public auto setDisabledOutlineColor(this T)(string color)
	{
		this._disabledOutlineColor = color;

		if (this._parent && this._disabledOutlineColor.length)
		{
			this._tk.eval("%s itemconfigure %s -disabledoutline {%s}", this._parent.id, this.id, this._disabledOutlineColor);
		}

		return cast(T) this;
	}
}
