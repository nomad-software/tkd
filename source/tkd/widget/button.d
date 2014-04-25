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
import tkd.element.uielement;
import tkd.image.image;
import tkd.image.imageposition;
import tkd.widget.common.command;
import tkd.widget.common.default_;
import tkd.widget.common.invoke;
import tkd.widget.textwidget;

/**
 * A button widget displays a textual label and/or image, and evaluates a 
 * command when pressed.
 *
 * Example:
 * ---
 * auto button = new Button(new Png!("image.png"), "Text")
 * 	.setCommand(delegate(CommandArgs arg){ ... })
 * 	.pack();
 * ---
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/command.html, Command) $(BR)
 *         $(LINK2 ./common/default_.html, Default) $(BR)
 *         $(LINK2 ./common/invoke.html, Invoke) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;Invoke&gt;&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;B1-Enter&gt;,
 *         &lt;B1-Leave&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;ButtonRelease-1&gt;,
 *         &lt;Enter&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-space&gt;,
 *         &lt;Leave&gt;,
 *     )
 *
 * Styles:
 *     Button widgets support the Toolbutton style in all standard themes, 
 *     which is useful for creating widgets for toolbars.
 *
 * See_Also:
 *     $(LINK2 ./textwidget.html, tkd.widget.textwidget)
 */
class Button : TextWidget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     text = The text of the button.
	 *     image = The button image.
	 *     imagePosition = The position of the image in relation to the text.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement) $(BR)
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/imageposition.html, tkd.image.imageposition) $(BR)
	 */
	this(UiElement parent, string text, Image image = null, string imagePosition = ImagePosition.top)
	{
		super(parent);
		this._elementId = "button";

		this._tk.eval("ttk::button %s -textvariable %s", this.id, this._textVariable);

		this.setText(text);

		if (image !is null)
		{
			this.setImage(image, imagePosition);
		}
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     image = The button image.
	 *     text = The text of the button.
	 *     imagePosition = The position of the image in relation to the text.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement) $(BR)
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/imageposition.html, tkd.image.imageposition) $(BR)
	 */
	this(UiElement parent, Image image, string text = null, string imagePosition = ImagePosition.image)
	{
		this(parent, text, image, imagePosition);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     text = The text of the button.
	 *     image = The button image.
	 *     imagePosition = The position of the image in relation to the text.
	 *
	 * See_Also:
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/imageposition.html, tkd.image.imageposition) $(BR)
	 */
	this(string text, Image image = null, string imagePosition = ImagePosition.top)
	{
		this(null, text, image, imagePosition);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     image = The button image.
	 *     text = The text of the button.
	 *     imagePosition = The position of the image in relation to the text.
	 *
	 * See_Also:
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/imageposition.html, tkd.image.imageposition) $(BR)
	 */
	this(Image image, string text = null, string imagePosition = ImagePosition.image)
	{
		this(null, text, image, imagePosition);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Command;
	mixin Default_;
	mixin Invoke;
}
