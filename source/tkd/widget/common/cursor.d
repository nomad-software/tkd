/**
 * Cursor module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.cursor;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Cursor()
{
	/**
	 * Set the text cursor just after the character index passed.
	 *
	 * Params:
	 *     charIndex = The index of the character after the cursor.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setCursorPosition(this T)(int charIndex)
	{
		this._tk.eval("%s icursor %s", this.id, charIndex);

		return cast(T) this;
	}
}
