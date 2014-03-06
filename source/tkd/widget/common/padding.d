/**
 * Padding module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.padding;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Padding()
{
	/**
	 * Set the amount of padding within the widget.
	 *
	 * Params:
	 *     padding = The desired widget padding.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setPadding(this T)(int padding)
	{
		this._tk.eval("%s configure -padding %s", this.id, padding);

		return cast(T) this;
	}
}
