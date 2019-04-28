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
	public auto setFont(this T)(string font)
	{
		this._tk.eval("%s configure -font %s", this.id, font);

		return cast(T) this;
	}
}
