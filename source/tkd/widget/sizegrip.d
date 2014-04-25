/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.sizegrip;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.widget.widget;

/**
 * A sizegrip widget (also known as a grow box) allows the user to resize the 
 * containing toplevel window by pressing and dragging the grip.
 *
 * Example:
 * ---
 * auto sizeGrip = new SizeGrip()
 * 	.pack(0, 0, GeometrySide.bottom, GeometryFill.none, AnchorPosition.southEast);
 * ---
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;B1-Motion&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;ButtonRelease-1&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class SizeGrip : Widget
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
		this._elementId     = "sizegrip";

		this._tk.eval("ttk::sizegrip %s", this.id);
	}
}
