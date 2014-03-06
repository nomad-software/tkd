/**
 * Export selection module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.exportselection;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template ExportSelection()
{
	/**
	 * Disable the selection export. This is only applicable to X based 
	 * operating systems.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto disableExportSelection(this T)()
	{
		this._tk.eval("%s configure -exportselection 0", this.id);

		return cast(T) this;
	}
}
