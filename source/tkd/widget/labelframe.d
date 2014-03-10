/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.labelframe;

/**
 * Imports.
 */
import tkd.element.uielement;
import tkd.widget.common.anchor;
import tkd.widget.common.height;
import tkd.widget.common.padding;
import tkd.widget.common.text;
import tkd.widget.common.underline;
import tkd.widget.common.width;
import tkd.widget.widget;

/**
 * A label frame widget is a container used to group other widgets together. It 
 * has an optional label, which may be a plain text string or another widget.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/anchor.html, Anchor) $(BR)
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/padding.html, Padding) $(BR)
 *         $(LINK2 ./common/text.html, Text) $(BR)
 *         $(LINK2 ./common/underline.html, Underline) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;Invoke&gt;&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class LabelFrame : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     text = The text of the widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	public this(UiElement parent, string text)
	{
		super(parent);
		this._elementId = "labelframe";

		this._tk.eval("ttk::labelframe %s -text \"%s\"", this.id, text);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     text = The text of the widget.
	 */
	public this(string text)
	{
		super(null);

		this._tk.eval("ttk::labelframe %s -text \"%s\"", this.id, text);
	}

	/**
	 * Set a widget to use for the label. The widget must be a child of the 
	 * labelframe widget or one of the labelframe's ancestors, and must belong 
	 * to the same top-level widget as the labelframe. If set, overrides the 
	 * text parameter.
	 *
	 * Params:
	 *     widget = The widget to use as the label.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setLabel(this T)(Widget widget)
	{
		this._tk.eval("%s configure -labelwidget %s", this.id, widget.id);

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Anchor!("-labelanchor");
	mixin Height;
	mixin Padding;
	mixin Text;
	mixin Underline;
	mixin Width;
}
