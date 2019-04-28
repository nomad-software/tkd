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
	public auto setFont(this T)(string font, int size = 0, string bold = "", string italic = "", string underline = "")
	{
		this._tk.eval("%s configure -font {%s %s %s %s %s}", this.id, font, size, bold, italic, underline);

		return cast(T) this;
	}
}
