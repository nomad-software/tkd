/**
 * Index module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.index;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Index()
{
	/**
	 * Get the length of the text.
	 *
	 * Returns:
	 *     The length of the text.
	 */
	public int getTextLength()
	{
		this._tk.eval("%s index end", this.id);
		return this._tk.getResult!(int);
	}

	/**
	 * Get the index where the insert cursor is.
	 *
	 * Returns:
	 *     An int of the index where the insert cursor is.
	 */
	public int getCursorIndex()
	{
		this._tk.eval("%s index insert", this.id);
		return this._tk.getResult!(int);
	}

	/**
	 * Get the start and end indexes of the text selection if there is one.
	 *
	 * Returns:
	 *     An array holding the start and end indexes of a text selection.
	 */
	public int[] getSelectedTextIndices()
	{
		int[] result;

		this._tk.eval("%s index sel.first", this.id);
		result ~= this._tk.getResult!(int);

		this._tk.eval("%s index sel.last", this.id);
		result ~= this._tk.getResult!(int);

		return result;
	}

}
