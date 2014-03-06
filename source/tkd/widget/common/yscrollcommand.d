/**
 * YScroll Command module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.yscrollcommand;

/**
 * Imports.
 */
import tkd.widget.scrollbar;

/**
 * If implemented this widget has a text display that is scrollable vertically.
 */
interface IYScrollable(T)
{
	/**
	 * Attach a vertical scrollbar.
	 *
	 * Params:
	 *     scrollbar = The scrollbar to attach.
	 */
	public T attachYScrollbar(YScrollbar scrollbar);
}

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template YScrollCommand(T)
{
	import tkd.widget.scrollbar;

	/**
	 * Attach a vertical scrollbar.
	 *
	 * Params:
	 *     scrollbar = The scrollbar to attach.
	 */
	public T attachYScrollbar(YScrollbar scrollbar)
	{
		this._tk.eval("%s configure -yscrollcommand [list %s set]", this.id, scrollbar.id);

		return this;
	}
}
