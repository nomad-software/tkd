/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.text;

/**
 * Imports.
 */
import tkd.element.uielement;
import tkd.widget.common.height;
import tkd.widget.common.width;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.yscrollcommand;
import tkd.widget.textwrapmode;
import tkd.widget.widget;

/**
 * A frame widget is a container, used to group other widgets together.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class Text : Widget, IXScrollable!(Text), IYScrollable!(Text)
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	public this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "text";

		this._tk.eval("text %s -highlightthickness 0", this.id);

		this.setWrapMode(TextWrapMode.word);
	}

	/**
	 * Set the wrap mode of the text.
	 *
	 * Params:
	 *     mode = The mode to wrap the text with.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./textwrapmode.html, tkd.widget.textwrapmode)
	 */
	public auto setWrapMode(this T)(string mode)
	{
		this._tk.eval("%s configure -wrap %s", this.id, mode);

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Height;
	mixin Width;
	mixin XScrollCommand!(Text);
	mixin YScrollCommand!(Text);
}
