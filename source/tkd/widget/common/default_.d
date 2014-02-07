/**
 * Default module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.default_;

mixin template default_()
{
	/**
	 * Make the widget the default one on the interface.
	 */
	public void setDefault()
	{
		this._tk.eval("%s configure -default active", this.id);
	}
}
