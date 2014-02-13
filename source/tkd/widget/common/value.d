/**
 * Value module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.value;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Value()
{
	/**
	 * The name of the variable that contains the widget's value.
	 */
	private string _valueVariable;

	/**
	 * Get the value of the widget.
	 *
	 * Params:
	 *     T = The type of the value to return.
	 *
	 * Returns:
	 *     The value of the widget.
	 */
	public T getValue(T = string)()
	{
		import std.conv : to;
		return this._tk.getVariable(this._valueVariable).to!(T);
	}

	/**
	 * Set the string value of the widget.
	 *
	 * Params:
	 *     value = The new widget value.
	 */
	public void setValue(string value)
	{
		return this._tk.setVariable(this._valueVariable, value);
	}
}
