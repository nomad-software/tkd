/**
 * Color module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.color;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Color()
{
	/**
	 * Set the foreground color of the widget.
	 *
	 * Params:
	 *     color = The name of the color, e.g. 'black' or a hex value, e.g. '#000000'.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/color.html, tkd.element.color) for standard defined colors.
	 */
	public auto setForegroundColor(this T)(string color)
	{
		this._tk.eval("%s configure -foreground %s", this.id, color);

		return cast(T) this;
	}

	/**
	 * Set the background color of the widget.
	 *
	 * Params:
	 *     color = The name of the color, e.g. 'black' or a hex value, e.g. '#000000'.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/color.html, tkd.element.color) for standard defined colors.
	 */
	public auto setBackgroundColor(this T)(string color)
	{
		this._tk.eval("%s configure -background %s", this.id, color);

		return cast(T) this;
	}

	/**
	 * Set the insert cursor color of the widget.
	 *
	 * Params:
	 *     color = The name of the color, e.g. 'black' or a hex value, e.g. '#000000'.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/color.html, tkd.element.color) for standard defined colors.
	 */
	public auto setInsertColor(this T)(string color)
	{
		this._tk.eval("%s configure -insertbackground %s", this.id, color);

		return cast(T) this;
	}
}
