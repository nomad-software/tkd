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
	 */
	public void setTextAlignment(string alignment)
	{
		this._tk.eval("%s configure -justify %s", this.id, alignment);
	}
}
