/**
 * Button module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.widget.button;

/**
 * Imports.
 */
import std.string;
import tkd.element.element;
import tkd.element.widget.labeledwidget;

/**
 * Class representing a button widget.
 */
class Button : LabeledWidget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *     text = The text of the button.
	 */
	this(Element parent = null, string text = null)
	{
		super(parent, text);

		this._elementId = "button";

		string tkScript = format("ttk::button %s -textvariable %s", this.id, this._textVariable);

		this._tk.eval(tkScript);
	}
}
