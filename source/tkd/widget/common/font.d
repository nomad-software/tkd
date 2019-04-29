/**
* Font module.
*
* License:
*     MIT. See LICENSE for full details.
*/
module tkd.widget.common.font;

/**
* These are common commands that apply to all widgets that have them injected.
*/
mixin template Font()
{  
	import tkd.element.font;

	/**
	 * Set the font and its options for the widget.
	 *
	 * Params:
	 *     font = The name of the font like 'Arial' or 'arial'.
	 *     size = The size of the font like '12'.
	 *	   weight = The weight of the font like 'bold'.
	 *	   slant = The slant of the font like 'italic'.
	 *     underline = The underline option of the font like 'underline'.
	 *     overstrike = The overstrike option of the font like 'overstrike'.
	 *
	 * 	   For a comprehensive list of fonts and options see the enums in tkd.element.font.
	 *
	 *     Calling setFont() without any parameters will reset the font and its options to the defaults.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setFont(this T)(string font = Font.default_, int size = FontSize.default_, 
								string weight = FontWeight.default_, string slant = FontSlant.default_, 
								string underline = FontUnderline.default_, string overstrike = FontOverstrike.default_)
	{
		this._tk.eval("%s configure -font {{%s} %s %s %s %s %s}", this.id, font, size, weight, slant, underline, overstrike);

		return cast(T) this;
	}
}
