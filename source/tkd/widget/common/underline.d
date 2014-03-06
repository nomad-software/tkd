/**
 * Underline module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.underline;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Underline()
{
	/**
	 * Underline one of the characters in the widget text.
	 *
	 * Params:
	 *     index = The index of the character to underline.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto underlineChar(this T)(int index)
	{
		this._tk.eval("%s configure -underline %s", this.id, index);

		return cast(T) this;
	}
}
