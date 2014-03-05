/**
 * Width module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.width;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Width()
{
	/**
	 * Set the width of the widget if the geometry manager allows.
	 *
	 * Params:
	 *     width = The desired widget width.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setWidth(int width)
	{
		this._tk.eval("%s configure -width %s", this.id, width);
		return this;
	}
}
