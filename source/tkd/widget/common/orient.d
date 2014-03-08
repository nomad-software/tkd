/**
 * Orient module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.orient;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Orient()
{
	/**
	 * Set the orientation of the widget.
	 *
	 * Params:
	 *     orientation = The orientation of the widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../orientation.html, tkd.widget.orientation) for orientations.
	 */
	public auto setOrientation(this T)(string orientation)
	{
		this._tk.eval("%s configure -orient %s", this.id, orientation);

		return cast(T) this;
	}
}
