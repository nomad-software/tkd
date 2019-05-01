/**
* Font module.
*
* License:
*     MIT. See LICENSE for full details.
*/
module tkd.widget.common.font;

/**
* These are common commands that apply to all widgets that have them injected.
*
 * Example:
 * ---
 * widget.setFont("PragmataPro", 10, FontStyle.bold, FontStyle.italic);
 * ---
*/
mixin template Font()
{
	import std.array : join;
	import std.conv : to;
	import tkd.element.fontstyle;

	/**
	 * Set the font and style for the widget.
	 *
	 * Params:
	 *     font   = The name of the font like 'Arial' or 'arial'.
	 *     size   = The size of the font like '12'.
	 *     styles = The different font styles.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/fontstyle.html, tkd.element.fontstyle) for font styles.
	 */
	public auto setFont(this T)(string font, int size, FontStyle[] styles...)
	{
		this._tk.eval("%s configure -font {{%s} %s %s}", this.id, font, size, styles.to!(string[]).join(" "));

		return cast(T) this;
	}
}
