/**
 * Menu module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.menu.menu;

/**
 * Imports.
 */
import std.string;
import tkd.element.element;
import tkd.element.uielement;
import tkd.image.image;
import tkd.image.imageposition;
import tkd.widget.menu.menubar;

/**
 * The cascading menu that items are selected from.
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
class Menu : UiElement
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     label = The label of the menu.
	 *
	 * See_Also:
	 *     $(LINK2 ./menubar.html, tkd.widget.menu.menubar)
	 */
	public this(MenuBar parent, string label)
	{
		super(parent);

		this._elementId = "menu";
		this._tk.eval("menu %s -type normal -tearoff 0", this.id);
		this._tk.eval("%s add cascade -menu %s -label {%s}", parent.id, this.id, label);
	}

	/**
	 * Add an item to the menu.
	 *
	 * Params:
	 *     label = The label of the item.
	 *     callback = The callback to execute as the action for this menu item.
	 *     accelerator = The keyboard shortcut. This is for decoration only, you must also bind this keypress to an event.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/element.html#CommandCallback, tkd.element.element.CommandCallback)
	 */
	public auto addEntry(this T)(string label, CommandCallback callback, string accelerator = null)
	{
		string command = this.createCommand(callback, label);

		this._tk.eval("%s add command -label {%s} -command %s -accelerator {%s}", this.id, label, command, accelerator);

		return cast(T) this;
	}

	/**
	 * Add an item to the menu with an image.
	 *
	 * Params:
	 *     image = The image of the entry.
	 *     label = The label of the item.
	 *     callback = The callback to execute as the action for this menu item.
	 *     accelerator = The keyboard shortcut. This is for decoration only, you must also bind this keypress to an event.
	 *     imagePosition = The position of the image in relation to the text.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/element.html#CommandCallback, tkd.element.element.CommandCallback)
	 *     $(LINK2 ../../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../../image/png.html, tkd.image.png) $(BR)
	 *     $(LINK2 ../../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../../image/imageposition.html, tkd.image.imageposition) $(BR)
	 */
	public auto addEntry(this T)(Image image, string label, CommandCallback callback, string imagePosition = ImagePosition.left, string accelerator = null)
	{
		string command = this.createCommand(callback, label);

		this._tk.eval("%s add command -image %s -label {%s} -command %s -compound %s -accelerator {%s}", this.id, image.id, label, command, imagePosition, accelerator);

		return cast(T) this;
	}

	/**
	 * Add a separator to the menu.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto addSeparator(this T)()
	{
		this._tk.eval("%s add separator", this.id);

		return cast(T) this;
	}
}
