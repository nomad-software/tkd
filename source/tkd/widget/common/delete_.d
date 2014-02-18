/**
 * Delete module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.delete_;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Delete_()
{
	/**
	 * Delete the text.
	 *
	 * Params:
	 *     startCharIndex = The index where the deletion starts.
	 *     endCharIndex = The index where the deletion ends.
	 */
	public void deleteText(int startCharIndex = 0, int endCharIndex = int.max)
	{
		this._tk.eval("%s delete %s %s", this.id, startCharIndex, endCharIndex);
	}
}
