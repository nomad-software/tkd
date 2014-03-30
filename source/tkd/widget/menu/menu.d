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
import std.array;
import std.conv;
import std.string;
import std.typecons;
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
	 * Array containing variabled used by check button entries in the menu.
	 */
	private string[] _checkButtonVariables;

	/**
	 * The variable used by any radio button entries in the menu.
	 */
	private string _radioButtonVariable;

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     label = The label of the menu.
	 *     underlineChar = The index of the character to underline.
	 *
	 * See_Also:
	 *     $(LINK2 ./menubar.html, tkd.widget.menu.menubar)
	 */
	public this(MenuBar parent, string label, ubyte underlineChar = ubyte.max)
	{
		super(parent);
		this._radioButtonVariable = format("variable-%s", this.generateHash());

		this._elementId = "menu";
		this._tk.eval("menu %s -type normal -tearoff 0", this.id);
		this._tk.eval("%s add cascade -menu %s -label {%s} -underline %s", parent.id, this.id, label, underlineChar);
	}

	/**
	 * Add an item to the menu.
	 *
	 * Params:
	 *     label = The label of the item.
	 *     callback = The callback to execute as the action for this menu item.
	 *     shortCutText = The keyboard shortcut text. This is for decoration only, you must also bind this keypress to an event.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/element.html#CommandCallback, tkd.element.element.CommandCallback)
	 */
	public auto addEntry(this T)(string label, CommandCallback callback, string shortCutText = null)
	{
		string command = this.createCommand(callback, label);

		this._tk.eval("%s add command -label {%s} -command %s -accelerator {%s}", this.id, label, command, shortCutText);

		return cast(T) this;
	}

	/**
	 * Add an item to the menu with an image.
	 *
	 * Params:
	 *     image = The image of the entry.
	 *     label = The label of the item.
	 *     callback = The callback to execute as the action for this menu item.
	 *     shortCutText = The keyboard shortcut text. This is for decoration only, you must also bind this keypress to an event.
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
	public auto addEntry(this T)(Image image, string label, CommandCallback callback, string imagePosition = ImagePosition.left, string shortCutText = null)
	{
		string command = this.createCommand(callback, label);

		this._tk.eval("%s add command -image %s -label {%s} -command %s -compound %s -accelerator {%s}", this.id, image.id, label, command, imagePosition, shortCutText);

		return cast(T) this;
	}

	/**
	 * Add an item to the menu that when selected adds a checked icon.
	 *
	 * Params:
	 *     label = The label of the item.
	 *     callback = The callback to execute as the action for this menu item.
	 *     shortCutText = The keyboard shortcut text. This is for decoration only, you must also bind this keypress to an event.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/element.html#CommandCallback, tkd.element.element.CommandCallback)
	 */
	public auto addCheckButtonEntry(this T)(string label, CommandCallback callback, string shortCutText = null)
	{
		this._checkButtonVariables ~= format("variable-%s", this.generateHash(label));
		string command = this.createCommand(callback, label);

		this._tk.eval("%s add checkbutton -label {%s} -command %s -accelerator {%s} -variable %s", this.id, label, command, shortCutText, this._checkButtonVariables.back());

		return cast(T) this;
	}

	/**
	 * Add an item to the menu with an image that when selected adds a checked icon.
	 *
	 * Params:
	 *     image = The image of the entry.
	 *     label = The label of the item.
	 *     callback = The callback to execute as the action for this menu item.
	 *     shortCutText = The keyboard shortcut text. This is for decoration only, you must also bind this keypress to an event.
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
	public auto addCheckButtonEntry(this T)(Image image, string label, CommandCallback callback, string imagePosition = ImagePosition.left, string shortCutText = null)
	{
		this._checkButtonVariables ~= format("variable-%s", this.generateHash(label));
		string command = this.createCommand(callback, label);

		this._tk.eval("%s add checkbutton -image %s -label {%s} -command %s -compound %s -accelerator {%s} -variable %s", this.id, image.id, label, command, imagePosition, shortCutText, this._checkButtonVariables.back());

		return cast(T) this;
	}

	/**
	 * Get if the check box entry at the passed index is checked or not. The 
	 * index only applies to check box entries in the menu not any other type 
	 * of entry. If there are no check box entries in the menu this method 
	 * returns false.
	 *
	 * Params:
	 *     index = The index of the check box entry.
	 *
	 * Returns:
	 *     True if the check box entry is selected, false if not.
	 */
	public bool isCheckBoxEntrySelected(int index)
	{
		if (index < this._checkButtonVariables.length)
		{
			return this._tk.getVariable(this._checkButtonVariables[index]).to!(int) == 1;
		}
		return false;
	}

	/**
	 * Add an item to the menu that acts as a radio button.
	 *
	 * There can only be one group of radio button entries in one menu. If more 
	 * than one group is needed use cascading menus to hold each group.
	 *
	 * Params:
	 *     label = The label of the item.
	 *     callback = The callback to execute as the action for this menu item.
	 *     shortCutText = The keyboard shortcut text. This is for decoration only, you must also bind this keypress to an event.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/element.html#CommandCallback, tkd.element.element.CommandCallback)
	 */
	public auto addRadioButtonEntry(this T)(string label, CommandCallback callback, string shortCutText = null)
	{
		string command = this.createCommand(callback, label);

		this._tk.eval("%s add radiobutton -label {%s} -command %s -accelerator {%s} -variable %s", this.id, label, command, shortCutText, this._radioButtonVariable);

		return cast(T) this;
	}

	/**
	 * Add an item to the menu with an image that acts as a radio button.
	 *
	 * There can only be one group of radio button entries in one menu. If more 
	 * than one group is needed use cascading menus to hold each group.
	 *
	 * Params:
	 *     image = The image of the entry.
	 *     label = The label of the item.
	 *     callback = The callback to execute as the action for this menu item.
	 *     shortCutText = The keyboard shortcut text. This is for decoration only, you must also bind this keypress to an event.
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
	public auto addRadioButtonEntry(this T)(Image image, string label, CommandCallback callback, string imagePosition = ImagePosition.left, string shortCutText = null)
	{
		string command = this.createCommand(callback, label);

		this._tk.eval("%s add radiobutton -image %s -label {%s} -command %s -compound %s -accelerator {%s} -variable %s", this.id, image.id, label, command, imagePosition, shortCutText, this._radioButtonVariable);

		return cast(T) this;
	}

	/**
	 * Get the value of the selected radio button entry. This value will be the 
	 * same as the entry's label. This method will return an empty string if no 
	 * radio button entry exists or none are selected.
	 *
	 * Returns:
	 *     The value of the selected radio button entry.
	 */
	public string getSelectedRadioEntryValue()
	{
		return this._tk.getVariable(this._radioButtonVariable).to!(string);
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

	/**
	 * Disable a menu item. The item indexes start at zero for the top-most 
	 * entry and increase as you go down. Index refers to all menu items 
	 * including separators.
	 *
	 * Params:
	 *     index = The index of the item to disable.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto disableEntry(this T)(int index)
	{
		this._tk.eval("%s entryconfigure %s -state disable", this.id, index);
		
		return cast(T) this;
	}

	/**
	 * Enable a menu item. The item indexes start at zero for the top-most 
	 * entry and increase as you go down. Index refers to all menu items 
	 * including separators.
	 *
	 * Params:
	 *     index = The index of the item to enable.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto enableEntry(this T)(int index)
	{
		this._tk.eval("%s entryconfigure %s -state normal", this.id, index);
		
		return cast(T) this;
	}

	/**
	 * Invoke a menu item by its index. The item indexes start at zero for the 
	 * top-most entry and increase as you go down. Index refers to all menu 
	 * items including separators.
	 *
	 * Params:
	 *     index = The index of the check box entry.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto invoke(this T)(int index)
	{
		this._tk.eval("%s invoke %s", this.id, index);

		return cast(T) this;
	}
}
