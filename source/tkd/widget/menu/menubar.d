/**
 * Menu module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.menu.menubar;

/**
 * Imports.
 */
import tkd.element.uielement;
import tkd.tkdapplication : Window;

/**
 * A menubar is the bar across the top of a window holding the menu items.
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;MenuSelect&gt;&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;Button&gt;,
 *         &lt;ButtonRelease&gt;,
 *         &lt;Enter&gt;
 *         &lt;Key-Down&gt;,
 *         &lt;Key-Escape&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Left&gt;,
 *         &lt;Key-Return&gt;,
 *         &lt;Key-Right&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-Up&gt;,
 *         &lt;Key-space&gt;,
 *         &lt;Key&gt;,
 *         &lt;Leave&gt;,
 *         &lt;Motion&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ../../element/uielement.html, tkd.element.uielement)
 */
class MenuBar : UiElement
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../../tkdapplication.html#Window, tkd.tkdapplication.Window)
	 */
	public this(Window parent)
	{
		super(parent);

		this._elementId = "menubar";
		this._tk.eval("menu %s -type menubar -tearoff 0", this.id);
		this._tk.eval("%s configure -menu %s", parent.id, this.id);
	}

}
