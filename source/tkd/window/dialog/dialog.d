/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.window.dialog.dialog;

/**
 * Imports.
 */
import std.regex;
import tkd.element.element;
import tkd.window.window;

/**
 * Abstract base class for all dialog boxes.
 *
 * See_Also:
 *     $(LINK2 ../../element/element.html, tkd.element.element) $(BR)
 */
abstract class Dialog : Element
{
	/*
	 * The parent window of the dialog.
	 */
	protected Window _parent;

	/*
	 * The title of the dialog.
	 */
	protected string _title;

	/*
	 * The result of the dialog.
	 */
	protected string[] _results;

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
	 * Get the dialog result. This varies on the type of dialog used and will 
	 * reflect the overall result expected of each dialog.
	 *
	 * Returns:
	 *     The result of the dialog or an empty string.
	 */
	public string getResult()
	{
		return this._results.length ? this._results[0] : "";
	}

	/**
	 * Remove any leading or trailing braces.
	 */
	protected void removeBracesFromResults()
	{
		foreach (ref result; this._results)
		{
			result = result.replace(regex(r"^\{"), "");
			result = result.replace(regex(r"\}$"), "");
		}
	}

	/**
	 * Show the dialog.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	abstract public auto show(this T)();
}
