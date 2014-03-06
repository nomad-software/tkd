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
		this._tk.eval("%s configure -text %s", this.id, text);

		return cast(T) this;
	}
}
