/**
 * Relief module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.relief;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template relief()
{
	/**
	 * Set the relief type of the widget.
	 *
	 * Params:
	 *     relief = The relief type of the widget.
	 */
	public void setRelief(string relief)
	{
		this._tk.eval("%s configure -relief %s", this.id, relief);
	}
}
