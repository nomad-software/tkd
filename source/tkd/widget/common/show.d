/**
 * Show module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.show;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Show()
{
	/**
	 * Substitute all characters in the text for the passed character.
	 * This is useful for password entries.
	 *
	 * Params:
	 *     character = The character to use as a substitute.
	 */
	public void showCharsAs(char character)
	{
		this._tk.eval("%s configure -show %s", this.id, character);
	}
}
