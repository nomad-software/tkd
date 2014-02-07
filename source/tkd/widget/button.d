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
import tkd.widget.common.command;
import tkd.widget.common.default_;
import tkd.widget.common.invoke;
import tkd.widget.textwidget;
import tkd.widget.widget;

/**
 * Class representing a button widget.
 *
 * Additional_Commands:
 *     $(UL
 *         $(LI $(LINK2 ./common/command.html, command))
 *         $(LI $(LINK2 ./common/default_.html, default))
 *         $(LI $(LINK2 ./common/invoke.html, invoke))
 *     )
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
	mixin default_;
	mixin command;
}
