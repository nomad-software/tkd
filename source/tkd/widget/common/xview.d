/**
 * XView module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.xview;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template XView()
{
	import std.algorithm;
	import std.array;
	import std.conv;

	/**
	 * Get floating point values which represent the viewable portion of the 
	 * text. Each element is a real fraction between 0 and 1; together they 
	 * describe the horizontal span that is visible in the window. For example, 
	 * if the first element is .2 and the second element is .6, 20% of the 
	 * entry's text is off-screen to the left, the middle 40% is visible in the 
	 * window, and 40% of the text is off-screen to the right.
	 *
	 * Returns:
	 *     An array containing two floating point values.
	 */
	public double[] getXView()
	{
		this._tk.eval("%s xview", this.id);
		return this._tk.getResult!(string).split().map!(to!(double)).array;
	}

	/**
	 * Adjusts the view in the window so that the position appears at the left 
	 * edge of the window. Position must be a fraction between 0.0 (start of 
	 * the text) and 1.0 (end of the text).
	 *
	 * Params:
	 *     position = The character index to scroll to.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setXView(this T)(double position)
	{
		this._tk.eval("%s xview moveto %s", this.id, position);

		return cast(T) this;
	}

	/**
	 * Adjusts the view in the window so that the character index passed is 
	 * displayed at the left edge of the window.
	 *
	 * Params:
	 *     charIndex = The character index to scroll to.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto scrollToChar(this T)(int charIndex)
	{
		this._tk.eval("%s xview %s", this.id, charIndex);

		return cast(T) this;
	}

	/**
	 * Scroll the text by a specified amount of characters. Positive values 
	 * scroll text to the left, negative values scroll text to the right.
	 *
	 * Params:
	 *     numberOfChars = The number of characters to scroll by.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto scrollChars(this T)(int numberOfChars)
	{
		this._tk.eval("%s xview scroll %s units", this.id, numberOfChars);

		return cast(T) this;
	}

	/**
	 * Scroll the text by a specified amount of pages. Positive values scroll 
	 * text to the left, negative values scroll text to the right.
	 *
	 * Params:
	 *     numberOfPages = The number of characters to scroll by.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto scrollPages(this T)(int numberOfPages)
	{
		this._tk.eval("%s xview scroll %s pages", this.id, numberOfPages);

		return cast(T) this;
	}
}
