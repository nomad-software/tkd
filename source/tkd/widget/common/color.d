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
	 *     color = The name of the color 'black' or its hex value '#000000' or
	 *     '#000'. For a comprehensive list of color names see the
	 *     tkd.element.color Color enum.
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
	 *     color = The name of the color 'white' or it's hex value '#FFFFFF' or
	 *     '#FFF'. For a comprehensive list of color names see the
	 *     tkd.element.color Color enum.
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
	 *     color = The name of the color 'yellow' or it's hex value '#FFFF00'
	 *     or '#FF0'. For a comprehensive list of color names see the
	 *     tkd.element.color Color enum.
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
