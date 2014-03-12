/**
 * Length module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.length;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Length()
{
	/**
	 * Set the length of the widget.
	 *
	 * Params:
	 *     length = The length of the widget in pixels.
	 */
	public auto setLength(this T)(int length)
	{
		this._tk.eval("%s configure -length %s", this.id, length);

		return cast(T) this;
	}
}
