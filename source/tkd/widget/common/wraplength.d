/**
 * Wrap Length module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.wraplength;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template WrapLength()
{
	/**
	 * Specifies the maximum line length (in pixels). If this option is less 
	 * than or equal to zero, then automatic wrapping is not performed; 
	 * otherwise the text is split into lines such that no line is longer than 
	 * the specified value.
	 *
	 * Params:
	 *     pixels = The maximum width in pixels.
	 */
	public void setWrapLength(int pixels)
	{
		this._tk.eval("%s configure -wraplength %s", this.id, pixels);
	}
}
