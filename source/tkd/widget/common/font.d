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
	import tkd.element.fontweight;
	import tkd.element.fontstyle;

	/**
	 * Set the font and style for the widget.
	 *
	 * Params:
	 *     font = The name of the font like 'Arial' or 'arial'.
	 *     size = The size of the font like '12'.
	 *	   weight = The weight of the font like 'bold'.
	 *	   slant = The slant of the font like 'italic'.
	 *     underline = The underline option of the font like 'underline'.
	 *     overstrike = The overstrike option of the font like 'overstrike'.
	 *
	 * 	   For all the font weight options see the 
	 *     tkd.element.fontweight FontWeight enum.
	 *
	 *     For all the font style options see the 
	 *     tkd.element.fontstyle FontStyle enum.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setFont(this T)(string font, int size, 
								string weight = FontWeight.normal, string slant = FontStyle.normal, 
								string underline = FontStyle.normal, string overstrike = FontStyle.normal)
	{
		this._tk.eval("%s configure -font {{%s} %s %s %s %s %s}", this.id, font, size, weight, slant, underline, overstrike);

		return cast(T) this;
	}
}
