/**
 * Justify module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.justify;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Justify()
{
	/**
	 * Set the alignment of the widget text.
	 *
	 * Params:
	 *     alignment = The alignment of the text.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../alignment.html, tkd.widget.alignment)
	 */
	public auto setTextAlignment(string alignment)
	{
		this._tk.eval("%s configure -justify %s", this.id, alignment);
		return this;
	}
}
