/**
 * Text module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.text;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Text()
{
	import std.conv;

	/**
	 * Get the widget text.
	 *
	 * Returns:
	 *     The widget text
	 */
	public string getText()
	{
		this._tk.eval("%s cget -text", this.id);
		return this._tk.getResult!(string);
	}

	/**
	 * Get the index where the insert cursor is.
	 *
	 * Params:
	 *     text = The widget text to set.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setText(this T)(string text)
	{
		// String concatenation is used to build the script here instead of 
		// using format specifiers to enable supporting input which includes 
		// Tcl/Tk reserved characters and elements that could be construed as 
		// format specifiers.
		string script = std.conv.text(this.id, ` configure -text `, `"`, this._tk.escape(text), `"`);
		this._tk.eval(script);

		return cast(T) this;
	}
}
