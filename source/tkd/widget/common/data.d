/**
 * Values module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.data;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Data()
{
	import std.array;
	import std.conv;
	import std.string;

	/**
	 * Get the data values of the widget.
	 *
	 * Returns:
	 *     An array of data values.
	 */
	public string[] getData()
	{
		this._tk.eval("%s cget -values", this.id);
		return this._tk.getResult!(string).replace("\"", "").split();
	}

	/**
	 * Set data values of the widget.
	 *
	 * Params:
	 *     values = The data values.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setData(this T)(string[] values)
	{
		string data = format(`[list "%s"]`, this._tk.escape(values).join(`" "`));

		// String concatenation is used to build the script here instead of 
		// using format specifiers to enable supporting input which includes 
		// Tcl/Tk reserved characters and elements that could be construed as 
		// format specifiers.
		string script = std.conv.text(this.id, ` configure -values `, data);
		this._tk.eval(script);

		return cast(T) this;
	}
}
