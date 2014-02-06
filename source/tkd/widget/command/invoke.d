/**
 * Invoke module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.command.invoke;

mixin template invoke()
{
	/**
	 * Invoke the command associated with the widget.
	 */
	public void invoke()
	{
		this._tk.eval("%s invoke", this.id);
	}
}
