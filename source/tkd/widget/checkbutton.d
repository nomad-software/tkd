/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.checkbutton;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.widget.common.command;
import tkd.widget.common.invoke;
import tkd.widget.textwidget;
import tkd.widget.widget;

/**
 * Class representing a checkbutton widget.
 *
 * Additional_Commands:
 *     These are common commands that can be used with this widget.
 *     $(P
 *         $(LINK2 ./common/command.html, command) $(BR)
 *         $(LINK2 ./common/invoke.html, invoke) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./textwidget.html, tkd.widget.textwidget)
 */
class CheckButton : TextWidget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *     text = The text of the checkbutton.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement)
	 */
	this(UiElement parent = null, string text = null)
	{
		super(parent, text);

		this._elementId = "checkbutton";

		string tkScript = format("ttk::checkbutton %s -textvariable %s", this.id, this._textVariable);

		this._tk.eval(tkScript);
	}

	/**
	 * Mixin common commands.
	 */
	mixin invoke;
	mixin command;
}
