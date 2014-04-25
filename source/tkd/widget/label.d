/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.label;

/**
 * Imports.
 */
import tkd.element.uielement;
import tkd.widget.common.anchor;
import tkd.widget.common.justify;
import tkd.widget.common.padding;
import tkd.widget.common.relief;
import tkd.widget.common.wraplength;
import tkd.widget.textwidget;

/**
 * A label widget displays a textual label and/or image.
 *
 * Example:
 * ---
 * auto label = new Label("Text")
 * 	.pack();
 * ---
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/anchor.html, Anchor) $(BR)
 *         $(LINK2 ./common/justify.html, Justify) $(BR)
 *         $(LINK2 ./common/padding.html, Padding) $(BR)
 *         $(LINK2 ./common/relief.html, Relief) $(BR)
 *         $(LINK2 ./common/wraplength.html, WrapLength) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;Invoke&gt;&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Alt-Key&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./textwidget.html, tkd.widget.textwidget)
 */
class Label : TextWidget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     text = The text of the label.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement) $(BR)
	 */
	this(UiElement parent, string text)
	{
		super(parent);
		this._elementId = "label";

		this._tk.eval("ttk::label %s -textvariable %s", this.id, this._textVariable);

		this.setText(text);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     text = The text of the label.
	 */
	this(string text)
	{
		this(null, text);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Anchor;
	mixin Justify;
	mixin Padding;
	mixin Relief;
	mixin WrapLength;
}
