/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.toolbutton;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.image.image;
import tkd.image.imageposition;
import tkd.widget.common.command;
import tkd.widget.common.default_;
import tkd.widget.common.invoke;
import tkd.widget.style;
import tkd.widget.textwidget;
import tkd.widget.widget;

/**
 * Class representing a tool button widget.
 * These are useful for creating application toolbars.
 *
 * Additional_Commands:
 *     These are common commands that can be used with this widget.
 *     $(P
 *         $(LINK2 ./common/command.html, command) $(BR)
 *         $(LINK2 ./common/default_.html, default) $(BR)
 *         $(LINK2 ./common/invoke.html, invoke) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./textwidget.html, tkd.widget.textwidget)
 */
class ToolButton : TextWidget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *     image = The tool button image.
	 *     text = The text of the button.
	 *     imagePosition = The position of the image in relation to the text.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/imageposition.html, tkd.image.imageposition) $(BR)
	 */
	this(UiElement parent, Image image, string text = null, string imagePosition = ImagePosition.image)
	{
		super(parent, text);

		this._elementId = "toolbutton";

		string tkScript = format("ttk::button %s -textvariable %s", this.id, this._textVariable);
		this._tk.eval(tkScript);

		this.setImage(image, imagePosition);
		this.setStyle(ButtonStyle.toolbutton);
	}

	/**
	 * Mixin common commands.
	 */
	mixin invoke;
	mixin default_;
	mixin command;
}
