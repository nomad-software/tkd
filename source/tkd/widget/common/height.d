/**
 * Height module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.height;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Height()
{
	/**
	 * Set the height of the widget if the geometry manager allows.
	 *
	 * Params:
	 *     height = The desired widget height.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setHeight(this T)(int height)
	{
		this._tk.eval("%s configure -height %s", this.id, height);

		return cast(T) this;
	}
}
