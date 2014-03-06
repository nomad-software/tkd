/**
 * Default module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.default_;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Default_()
{
	/**
	 * Make the widget the default one on the interface.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setDefault(this T)()
	{
		this._tk.eval("%s configure -default active", this.id);

		return cast(T) this;
	}
}
