/**
 * Insert module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.insert;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Insert()
{
	import std.conv;

	/**
	 * Insert text at an index.
	 *
	 * Params:
	 *     text = The text to insert.
	 *     charIndex = The index to insert the text.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto insertTextAt(this T)(string text, int charIndex)
	{
		// String concatenation is used to build the script here instead of 
		// using format specifiers to enable supporting input which includes 
		// Tcl/Tk reserved characters and elements that could be construed as 
		// format specifiers.
		string script = std.conv.text(this.id, ` insert `, charIndex, ` "`, this._tk.escape(text), `"`);
		this._tk.eval(script);

		return cast(T) this;
	}

	/**
	 * Append text to the end.
	 *
	 * Params:
	 *     text = The text to insert.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto appendText(this T)(string text)
	{
		// String concatenation is used to build the script here instead of 
		// using format specifiers to enable supporting input which includes 
		// Tcl/Tk reserved characters and elements that could be construed as 
		// format specifiers.
		string script = std.conv.text(this.id, ` insert end `, `"`, this._tk.escape(text), `"`);
		this._tk.eval(script);

		return cast(T) this;
	}

	/**
	 * Insert text at the cursor position.
	 *
	 * Params:
	 *     text = The text to insert.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./cursor.html, tkd.widget.common.cursor) $(BR)
	 *     $(LINK2 ./index.html, tkd.widget.common.index) $(BR)
	 */
	public auto insertTextAtCursor(this T)(string text)
	{
		// String concatenation is used to build the script here instead of 
		// using format specifiers to enable supporting input which includes 
		// Tcl/Tk reserved characters and elements that could be construed as 
		// format specifiers.
		string script = std.conv.text(this.id, ` insert insert `, `"`, this._tk.escape(text), `"`);
		this._tk.eval(script);

		return cast(T) this;
	}
}
