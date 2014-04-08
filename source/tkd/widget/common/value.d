/**
 * Value module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.value;

/**
 * These are common commands that apply to all widgets that have them injected.
 *
 * Params:
 *     valueVariable = The name of the variable that holds the widget's value.
 *     V = The type of the variable to set.
 */
mixin template Value(alias valueVariable, V)
{
	import std.conv;

	/**
	 * Get the value of the widget.
	 *
	 * Params:
	 *     T = The type of the value to return.
	 *
	 * Returns:
	 *     The value of the widget.
	 */
	public T getValue(T = V)()
	{
		return this._tk.getVariable(valueVariable).to!(T);
	}

	/**
	 * Set the string value of the widget.
	 *
	 * Params:
	 *     value = The new widget value.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setValue(this T)(V value)
	{
		this._tk.setVariable(valueVariable, value);

		return cast(T) this;
	}

	/**
	 * Destroy this widget.
	 *
	 * Caveats:
	 *     Once a widget is destroyed it can no longer be referenced in your 
	 *     code or a segmentation fault will occur and potentially crash your 
	 *     program.
	 */
	override public void destroy()
	{
		this._tk.deleteVariable(valueVariable);
		super.destroy();
	}
}
