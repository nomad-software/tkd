/**
 * Range module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.range;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Range()
{
	/**
	 * Set the 'from' value of the range.
	 *
	 * Params:
	 *     value = The 'from' value of the range.
	 */
	public auto setFromValue(this T)(double value)
	{
		this._tk.eval("%s configure -from %s", this.id, value);

		return cast(T) this;
	}

	/**
	 * Set the 'to' value of the range.
	 *
	 * Params:
	 *     value = The 'to' value of the range.
	 */
	public auto setToValue(this T)(double value)
	{
		this._tk.eval("%s configure -to %s", this.id, value);

		return cast(T) this;
	}
}
