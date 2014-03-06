/**
 * Values module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.values;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Values()
{
	import std.array;

	/**
	 * Get the values of the widget.
	 *
	 * Returns:
	 *     An array of the values.
	 */
	public string[] getValues()
	{
		this._tk.eval("%s cget -values", this.id);
		return this._tk.getResult!(string).replace("\"", "").split();
	}

	/**
	 * Set the values of the widget.
	 *
	 * Params:
	 *     values = The widget values.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setValues(this T)(string[] values)
	{
		this._tk.eval("%s configure -values { \"%s\" }", this.id, values.join("\" \""));

		return cast(T) this;
	}
}
