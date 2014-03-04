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
import tkd.element.uielement;
import tkd.widget.common.height;
import tkd.widget.common.padding;
import tkd.widget.common.width;
import tkd.widget.widget;

/**
 * Class representing a notebook widget.
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
 *         &lt;Destroy&gt;,
 *         &lt;Control-Key-ISO_Left_Tab&gt;,
 *         &lt;Control-Shift-Key-Tab&gt;,
 *         &lt;Control-Key-Tab&gt;,
 *         &lt;Key-Left&gt;,
 *         &lt;Key-Right&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Alt-Key&gt;,
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
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	public this(UiElement parent = null)
	{
		super(parent);

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
	 */
	public void addTab(string text, Widget widget)
	{
		this.insertTab("end", text, widget);
	}

	/**
	 * Insert a tab into the notebook at a specified zero based index. When 
	 * adding a tab to the notebook the tab gains an id that is equal to the 
	 * passed widget's id and can be used later to refer to the new tab. If the 
	 * id of the widget passed is already used as a tab id then that existing 
	 * one will be moved to the new position.
	 *
	 * Params:
	 *     tabIndex = The index where the new tab will be created.
	 *     text = The text of the tab.
	 *     widget = The widget to add as the tab pane.
	 */
	public void insertTab(int tabIndex, string text, Widget widget)
	{
		this._tk.eval("%s insert %s %s -text \"%s\"", this.id, tabIndex, widget.id, text);
	}

	/**
	 * Insert a tab into the notebook before the specified tabId. When adding a 
	 * tab to the notebook the tab gains an id that is equal to the passed 
	 * widget's id and can be used later to refer to the new tab. If the id of 
	 * the widget passed is already used as a tab id then that existing one 
	 * will be moved to the new position.
	 *
	 * Params:
	 *     tabId = The tab id to position the tab before.
	 *     text = The text of the tab.
	 *     widget = The widget to add as the tab pane.
	 */
	public void insertTab(string tabId, string text, Widget widget)
	{
		this._tk.eval("%s insert %s %s -text \"%s\"", this.id, tabId, widget.id, text);
	}

	/**
	 * Remove a tab from the notbook via its index.
	 *
	 * Params:
	 *     tabIndex = The zero based index of the tab to remove.
	 */
	public void removeTab(int tabIndex)
	{
		this._tk.eval("%s forget %s", this.id, tabIndex);
	}

	/**
	 * Remove a tab from the notbook via its string id. The string id is the 
	 * widget id that was added as the tab.
	 *
	 * Params:
	 *     tabId = The tab string id of the tab to remove.
	 */
	public void removeTab(string tabId)
	{
		this._tk.eval("%s forget %s", this.id, tabId);
	}

	/**
	 * Hide a tab from the notbook via its index.
	 *
	 * Params:
	 *     tabIndex = The zero based index of the tab to hide.
	 */
	public void hideTab(int tabIndex)
	{
		this._tk.eval("%s hide %s", this.id, tabIndex);
	}

	/**
	 * Hide a tab from the notbook via its string id. The string id is the 
	 * widget id that was added as the tab.
	 *
	 * Params:
	 *     tabId = The tab string id of the tab to hide.
	 */
	public void hideTab(string tabId)
	{
		this._tk.eval("%s hide %s", this.id, tabId);
	}

	/**
	 * Get the tab index from its string id. The string id is the 
	 * widget id that was added as the tab.
	 *
	 * Params:
	 *     tabId = The tab string id of the tab.
	 */
	public int getTabIndexById(string tabId)
	{
		this._tk.eval("%s index %s", this.id, tabId);
		return this._tk.getResult!(int);
	}

	/**
	 * Call to enable keyboard traversal of the tabs.
	 */
	public void enableKeyboardTraversal()
	{
		this._tk.eval("ttk::notebook::enableTraversal %s", this.id);
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
