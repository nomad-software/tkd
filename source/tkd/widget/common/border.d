/**
 * Border module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.border;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template border()
{
	/**
	 * Set the border width of the widget.
	 *
	 * Params:
	 *     width = The desired border width.
	 */
	public void setBorderWidth(int width)
	{
		this._tk.eval("%s configure -borderwidth %s", this.id, width);
	}
}
