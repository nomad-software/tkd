/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.notebook;

/**
 * Imports.
 */
import std.array;
import tkd.element.uielement;
import tkd.image.image;
import tkd.image.imageposition;
import tkd.widget.common.height;
import tkd.widget.common.padding;
import tkd.widget.common.width;
import tkd.widget.widget;

/**
 * A notebook widget manages a collection of panes and displays a single one at 
 * a time. Each pane is associated with a tab, which the user may select to 
 * change the currently-displayed pane.
 *
 * Example:
 * ---
 * // The notebook must be created first.
 * // See the constructor notes in the documentation.
 * auto noteBook = new NoteBook();
 *
 * // The pane's widgets are contained within the frame.
 * auto pane = new Frame(noteBook);
 *
 * noteBook.addTab("Text", pane)
 * 	.pack();
 * ---
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/padding.html, Padding) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;NotebookTabChanged&gt;&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;Control-Key-ISO_Left_Tab&gt;,
 *         &lt;Control-Key-Tab&gt;,
 *         &lt;Control-Shift-Key-Tab&gt;,
 *         &lt;Destroy&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Left&gt;,
 *         &lt;Key-Right&gt;,
 *         &lt;Key-Tab&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class NoteBook : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * Bugs:
	 *     Because this widget contains and handles other widget's geometry, it 
	 *     must be created before the child panes and not chained with methods 
	 *     that add new tabs. If it is chained, tabs will not be handled 
	 *     correctly and might not show at all. This seems to be a limitation 
	 *     with Tcl/Tk.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	public this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "notebook";

		this._tk.eval("ttk::notebook %s", this.id);
	}

	/**
	 * Add a tab to the notebook. When adding a tab to the notebook the tab 
	 * gains an id that is equal to the passed widget's id and can be used 
	 * later to refer to the new tab.
	 *
	 * Params:
	 *     text = The text of the tab.
	 *     widget = The widget to add as the tab pane.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto addTab(this T)(string text, Widget widget)
	{
		this.insertTab("end", text, widget);

		return cast(T) this;
	}

	/**
	 * Insert a tab into the notebook at a specified zero based index. When 
	 * adding a tab to the notebook the tab gains an id that is equal to the 
	 * passed widget's id and can be used later to refer to the new tab. If the 
	 * id of the widget passed is already used as a tab id then that existing 
	 * one will be moved to the new position.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *     text = The text of the tab.
	 *     widget = The widget to add as the tab pane.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto insertTab(this T, I)(I tabIdentifier, string text, Widget widget) if (is(I == int) || is(I == string))
	{
		this._tk.eval(`%s insert %s %s -text "%s"`, this.id, tabIdentifier, widget.id, text);

		return cast(T) this;
	}

	/**
	 * Select a tab in the notebook.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto selectTab(this T, I)(I tabIdentifier) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s select %s", this.id, tabIdentifier);

		return cast(T) this;
	}

	/**
	 * Remove a tab from the notbook.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto removeTab(this T, I)(I tabIdentifier) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s forget %s", this.id, tabIdentifier);

		return cast(T) this;
	}

	/**
	 * Hide a tab from the notbook.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto hideTab(this T, I)(I tabIdentifier) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s hide %s", this.id, tabIdentifier);

		return cast(T) this;
	}

	/**
	 * Set a tab's state.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *     state = A widget state.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state) for states.
	 */
	public auto setTabState(this T, I)(I tabIdentifier, string state) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s tab %s -state %s", this.id, tabIdentifier, state);

		return cast(T) this;
	}

	/**
	 * Set a tab pane's sticky state. Specifies how the slave widget is 
	 * positioned within the pane area. Sticky state is a string containing 
	 * zero or more of the characters n, s, e, or w. Each letter refers to a 
	 * side (north, south, east, or west) that the slave window will "stick" 
	 * to, as per the grid geometry manager.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *     stickyState = A widget state.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setPaneStickyState(this T, I)(I tabIdentifier, string stickyState) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s tab %s -sticky %s", this.id, tabIdentifier, stickyState);

		return cast(T) this;
	}

	/**
	 * Set a tab pane's padding.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *     padding = The desired widget padding.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setPanePadding(this T, I)(I tabIdentifier, int padding) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s tab %s -padding %s", this.id, tabIdentifier, padding);

		return cast(T) this;
	}

	/**
	 * Set a tab's text.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *     text = The tab text.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setTabText(this T, I)(I tabIdentifier, string text) if (is(I == int) || is(I == string))
	{
		this._tk.eval(`%s tab %s -text "%s"`, this.id, tabIdentifier, text);

		return cast(T) this;
	}

	/**
	 * Set a tab's image.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *     image = The image to set on the widget.
	 *     imagePosition = The position of the image relative to the text.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../image/png.html, tkd.image.png) $(BR)
	 *     $(LINK2 ../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../image/imageposition.html, tkd.image.imageposition) $(BR)
	 */
	public auto setTabImage(this T, I)(I tabIdentifier, Image image, string imagePosition = ImagePosition.image) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s tab %s -image %s", this.id, tabIdentifier, image.id);
		this.setTabImagePosition(tabIdentifier, imagePosition);

		return cast(T) this;
	}

	/**
	 * Change the position of the tab image in relation to the text.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *     imagePosition = The position of the image relative to the text.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../image/imageposition.html, tkd.image.imageposition)
	 */
	public auto setTabImagePosition(this T, I)(I tabIdentifier, string imagePosition) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s tab %s -compound %s", this.id, tabIdentifier, imagePosition);

		return cast(T) this;
	}

	/**
	 * Underline a character in the tab text. The underlined character is used 
	 * for mnemonic activation if keyboard traversal is enabled.
	 *
	 * Params:
	 *     tabIdentifier = The zero based index or string id of the tab.
	 *     index = The index of the character to underline.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../image/imageposition.html, tkd.image.imageposition) $(BR)
	 *     $(LINK2 ./notebook.html#NoteBook.enableKeyboardTraversal, enableKeyboardTraversal) $(BR)
	 */
	public auto underlineTabChar(this T, I)(I tabIdentifier, int index) if (is(I == int) || is(I == string))
	{
		this._tk.eval("%s tab %s -underline %s", this.id, tabIdentifier, index);

		return cast(T) this;
	}

	/**
	 * Call to enable keyboard traversal of the tabs.
	 *
	 * This will extend the bindings for the toplevel window containing the notebook as follows:
	 * $(UL
	 *     $(LI Control-Tab selects the tab following the currently selected one.)
	 *     $(LI Control-Shift-Tab selects the tab preceding the currently selected one.)
	 *     $(LI Alt-c, where c is the mnemonic (underlined) character of any tab, will select that tab.)
	 * )
	 * Multiple notebooks in a single window may be enabled for traversal, 
	 * including nested notebooks. However, notebook traversal only works 
	 * properly if all widget panes are direct children of the notebook.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./notebook.html#NoteBook.underlineTabChar, underlineTabChar) $(BR)
	 */
	public auto enableKeyboardTraversal(this T)()
	{
		this._tk.eval("ttk::notebook::enableTraversal %s", this.id);

		return cast(T) this;
	}

	/**
	 * Get an array of all the current tab id's.
	 *
	 * Returns:
	 *     An array containing all the tab id's.
	 */
	public string[] getTabIds()
	{
		this._tk.eval("%s tabs", this.id);
		return this._tk.getResult!(string).split();
	}

	/**
	 * Get the tab index from its id. The id is the widget id that was added as 
	 * the tab.
	 *
	 * Params:
	 *     tabId = The tab id of the tab.
	 */
	public int getTabIndexById(string tabId)
	{
		this._tk.eval("%s index %s", this.id, tabId);
		return this._tk.getResult!(int);
	}

	/**
	 * Get the number of tabs in the notebook.
	 *
	 * Returns:
	 *     The number of tabs.
	 */
	public int getNumberOfTabs()
	{
		return this.getTabIndexById("end");
	}

	/**
	 * Mixin common commands.
	 */
	mixin Height;
	mixin Padding;
	mixin Width;
}
