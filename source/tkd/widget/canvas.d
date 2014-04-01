/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.canvas;

/**
 * Imports.
 */
import tkd.element.uielement;
import tkd.image.image;
import tkd.widget.common.border;
import tkd.widget.common.height;
import tkd.widget.common.relief;
import tkd.widget.common.width;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.xview;
import tkd.widget.common.yscrollcommand;
import tkd.widget.common.yview;
import tkd.widget.reliefstyle;
import tkd.widget.widget;

/**
 * Canvas widgets implement structured graphics. A canvas displays any number 
 * of items, which may be things like rectangles, circles, lines, and text.  
 * Items may be manipulated (e.g. moved or re-colored) and commands may be 
 * associated with items in much the same way that the bind command allows 
 * commands to be bound to widgets.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/border.html, Border) $(BR)
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/relief.html, Relief) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
 *         $(LINK2 ./common/xscrollcommand.html, XScrollCommand) $(BR)
 *         $(LINK2 ./common/xview.html, XView) $(BR)
 *         $(LINK2 ./common/yscrollcommand.html, YScrollCommand) $(BR)
 *         $(LINK2 ./common/yview.html, YView) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class Canvas : Widget, IXScrollable!(Canvas), IYScrollable!(Canvas)
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
		this._elementId = "canvas";

		this._tk.eval("canvas %s -highlightthickness 0", this.id);

		this.setBorderWidth(1);
		this.setRelief(ReliefStyle.sunken);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Border;
	mixin Height;
	mixin Relief;
	mixin Width;
	mixin XScrollCommand!(Canvas);
	mixin XView;
	mixin YScrollCommand!(Canvas);
	mixin YView;
}
