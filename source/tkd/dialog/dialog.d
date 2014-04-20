/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.dialog.dialog;

/**
 * Imports.
 */
import tkd.element.element;
import tkd.tkdapplication : Window;

/**
 * Abstract base class for all dialog boxes.
 *
 * See_Also:
 *     $(LINK2 ../element/element.html, tkd.element.element) $(BR)
 */
abstract class Dialog : Element
{
	/**
	 * The parent window of the dialog.
	 */
	protected Window _parent;

	/**
	 * The title of the dialog.
	 */
	protected string _title;

	/**
	 * The result of the dialog.
	 */
	protected string _result;

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     parent = The parent window of the dialog.
	 *     title = The title of the dialog.
	 */
	this(Window parent, string title)
	{
		this._elementId = "dialog";
		this._parent    = parent;
		this._title     = title;
	}

	/**
	 * Get the dialog result.
	 */
	public string getResult()
	{
		return this._result;
	}

	/**
	 * Show the dialog.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	abstract public auto show(this T)();
}
