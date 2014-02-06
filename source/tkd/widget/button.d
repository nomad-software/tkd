/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.button;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.widget.command.invoke;
import tkd.widget.command.setdefault;
import tkd.widget.textwidget;

/**
 * Class representing a button widget.
 *
 * Common_Commands:
 *     $(LINK2 ./command/invoke.html, invoke())
 *     $(LINK2 ./command/setdefault.html, setDefault())
 */
class Button : TextWidget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *     text = The text of the button.
	 */
	this(UiElement parent = null, string text = null)
	{
		super(parent, text);

		this._elementId = "button";

		string tkScript = format("ttk::button %s -textvariable %s", this.id, this._textVariable);

		this._tk.eval(tkScript);
	}

	/**
	 * Mixin common commands.
	 */
	mixin invoke;
	mixin setDefault;
}
