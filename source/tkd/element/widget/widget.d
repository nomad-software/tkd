/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.widget.widget;

/**
 * Imports.
 */
import std.array;
import std.string;
import tkd.element.element;

/**
 * The widget base class.
 */
abstract class Widget : Element
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 */
	this(Element parent = null)
	{
		super(parent);
	}

	/**
	 * Set the widget's state.
	 *
	 * Params:
	 *     state = A valid widget state.
	 */
	public void setState(string state)
	{
		this._tk.eval(format("%s configure -state %s", this.id, state));
	}

	/**
	 * Get the widget's state.
	 *
	 * Returns:
	 *     The widget's state.
	 */
	public string getState()
	{
		this._tk.eval(format("%s cget -state", this.id));
		return this._tk.getResult();
	}

	/**
	 * Set the widget's style.
	 *
	 * Params:
	 *     style = A valid widget style.
	 */
	public void setStyle(string style)
	{
		this._tk.eval(format("%s configure -style %s", this.id, style));
	}

	/**
	 * Get the widget's style.
	 *
	 * Returns:
	 *     The widget's style.
	 */
	public string getStyle()
	{
		this._tk.eval(format("%s cget -style", this.id));
		if (this._tk.getResult().empty())
		{
			return this.getClass();
		}
		return this._tk.getResult();
	}

	/**
	 * Set if the widget can recieve focus during keyboard traversal.
	 *
	 * Params:
	 *     style = A valid focus setting.
	 */
	public void setFocus(string focus)
	{
		this._tk.eval(format("%s configure -takefocus %s", this.id, focus));
	}

	/**
	 * Get if the widget can recieve focus during keyboard traversal.
	 *
	 * Returns:
	 *     The widget's focus setting.
	 */
	public string getFocus()
	{
		this._tk.eval(format("%s cget -takefocus", this.id));
		return this._tk.getResult();
	}

	/**
	 * Geometry method for placing the widget onto the interface.
	 */
	public void pack()
	{
		string tkScript = format("pack %s -padx 10 -pady 10", this.id);

import std.stdio;
writefln("Geometry: %s", tkScript);

		this._tk.eval(tkScript);
	}
}
