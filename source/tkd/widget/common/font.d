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
 * Examples:
 * ---
 * widget.setFont("Gothic");
 * ---
 * widget.setFont("Arial 10");
 * ---
 * widget.setFont("{Comic Sans MS} 12 bold italic underline overstrike");
 * ---
*/
mixin template Font()
{  
	/**
	 * Set the font and style for the widget.
	 *
	 * Params:
	 *     font   = The string containing all the specified font options.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/fontstyle.html, tkd.element.fontstyle) for font styles.
	 */
	public auto setFont(this T)(string font)
	{
		this._tk.eval("%s configure -font {%s}", this.id, font);

		return cast(T) this;
	}
}
