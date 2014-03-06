/**
 * Selection module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.selection;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Selection()
{
	/**
	 * Clear the text selection.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto deselectText(this T)()
	{
		this._tk.eval("%s selection clear", this.id);

		return cast(T) this;
	}

	/**
	 * Check if any text selected.
	 */
	public bool isTextSelected()
	{
		this._tk.eval("%s selection present", this.id);
		return this._tk.getResult!(int) == 1;
	}

	/**
	 * Select the text.
	 *
	 * Params:
	 *     startCharIndex = The index where the selection starts.
	 *     endCharIndex = The index where the selection ends.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto selectText(this T)(int startCharIndex = 0, int endCharIndex = int.max)
	{
		this._tk.eval("%s selection range %s %s", this.id, startCharIndex, endCharIndex);

		return cast(T) this;
	}
}
