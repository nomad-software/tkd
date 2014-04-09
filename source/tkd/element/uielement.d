/**
 * Element module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.uielement;

/**
 * Imports.
 */
import std.conv;
import std.range;
import std.string;
import tkd.element.element;

/**
 * The ui element base class.
 *
 * Events:
 *     All UI elements can raise the following events which can be bound to using the bind method.
 *     $(P
 *         $(PARAM_TABLE
 *             $(PARAM_ROW &lt;Activate&gt; $(BR) &lt;Deactivate&gt;, These two events are sent to every sub-window of a toplevel when they change state. In addition to the focus Window the Macintosh platform and Windows platforms have a notion of an active window (which often has but is not required to have the focus). On the Macintosh widgets in the active window have a different appearance than widgets in deactive windows. The Activate event is sent to all the sub-windows in a toplevel when it changes from being deactive to active. Likewise the Deactive event is sent when the window's state changes from active to deactive. There are no useful percent substitutions you would make when binding to these events.)
 *             $(PARAM_ROW &lt;MouseWheel&gt;, Some mice on the Windows platform support a mouse wheel which is used for scrolling documents without using the scrollbars. By rolling the wheel the system will generate MouseWheel events that the application can use to scroll. On Windows the event is always routed to the window that currently has focus (like Key events.) On Mac OS X the event is routed to the window under the pointer. When the event is received you can use the %D substitution to get the delta field for the event which is a integer value describing how the mouse wheel has moved. The smallest value for which the system will report is defined by the OS. On Windows 95 & 98 machines this value is at least 120 before it is reported. However higher resolution devices may be available in the future. On Mac OS X the value is not scaled by 120 but a value of 1 corresponds to roughly one text line. The sign of the value determines which direction your widget should scroll. Positive values should scroll up and negative values should scroll down.)
 *             $(PARAM_ROW &lt;KeyPress&gt; $(BR) &lt;KeyRelease&gt;, The KeyPress and KeyRelease events are generated whenever a key is pressed or released. KeyPress and KeyRelease events are sent to the UI element which currently has the keyboard focus.)
 *             $(PARAM_ROW &lt;ButtonPress&gt; $(BR) &lt;ButtonRelease&gt; $(BR) &lt;Motion&gt;, The ButtonPress and ButtonRelease events are generated when the user presses or releases a mouse button. Motion events are generated whenever the pointer is moved. ButtonPress ButtonRelease and Motion events are normally sent to the window containing the pointer. When a mouse button is pressed the window containing the pointer automatically obtains a temporary pointer grab. Subsequent ButtonPress ButtonRelease and Motion events will be sent to that window regardless of which window contains the pointer until all buttons have been released.)
 *             $(PARAM_ROW &lt;Configure&gt;, A Configure event is sent to a window whenever its size position or border width changes and sometimes when it has changed position in the stacking order.)
 *             $(PARAM_ROW &lt;Map&gt; $(BR) &lt;Unmap&gt;, The Map and Unmap events are generated whenever the mapping state of a window changes. Windows are created in the unmapped state. Top-level windows become mapped when they transition to the normal state and are unmapped in the withdrawn and iconic states. Other windows become mapped when they are placed under control of a geometry manager (for example pack or grid). A window is viewable only if it and all of its ancestors are mapped. Note that geometry managers typically do not map their children until they have been mapped themselves and unmap all children when they become unmapped; hence in Tk Map and Unmap events indicate whether or not a window is viewable.)
 *             $(PARAM_ROW &lt;Visibility&gt;, A window is said to be obscured when another window above it in the stacking order fully or partially overlaps it. Visibility events are generated whenever a window's obscurity state changes; the state field (%s) specifies the new state.)
 *             $(PARAM_ROW &lt;Expose&gt;, An Expose event is generated whenever all or part of a window should be redrawn (for example when a window is first mapped or if it becomes unobscured). It is normally not necessary for client applications to handle Expose events since Tk handles them internally.)
 *             $(PARAM_ROW &lt;Destroy&gt;, A Destroy event is delivered to a window when it is destroyed. When the Destroy event is delivered to a widget it is in a 'half-dead' state: the widget still exists but most operations on it will fail.)
 *             $(PARAM_ROW &lt;FocusIn&gt; $(BR) &lt;FocusOut&gt;, The FocusIn and FocusOut events are generated whenever the keyboard focus changes. A FocusOut event is sent to the old focus window and a FocusIn event is sent to the new one. In addition if the old and new focus windows do not share a common parent 'virtual crossing' focus events are sent to the intermediate windows in the hierarchy. Thus a FocusIn event indicates that the target window or one of its descendants has acquired the focus and a FocusOut event indicates that the focus has been changed to a window outside the target window's hierarchy. The keyboard focus may be changed explicitly by a call to focus or implicitly by the window manager.)
 *             $(PARAM_ROW &lt;Enter&gt; $(BR) &lt;Leave&gt;, An Enter event is sent to a window when the pointer enters that window and a Leave event is sent when the pointer leaves it. If there is a pointer grab in effect Enter and Leave events are only delivered to the window owning the grab. In addition when the pointer moves between two windows Enter and Leave 'virtual crossing' events are sent to intermediate windows in the hierarchy in the same manner as for FocusIn and FocusOut events.)
 *             $(PARAM_ROW &lt;Property&gt;, A Property event is sent to a window whenever an X property belonging to that window is changed or deleted. Property events are not normally delivered to Tk applications as they are handled by the Tk core.)
 *             $(PARAM_ROW &lt;Colormap&gt;, A Colormap event is generated whenever the colormap associated with a window has been changed installed or uninstalled. Widgets may be assigned a private colormap by specifying a -colormap option; the window manager is responsible for installing and uninstalling colormaps as necessary.)
 *             $(PARAM_ROW &lt;CirculateRequest&gt; $(BR) &lt;ConfigureRequest&gt; $(BR) &lt;Create&gt; $(BR) &lt;MapRequest&gt; $(BR) &lt;ResizeRequest&gt;, A Colormap event is generated whenever the colormap associated with a window has been changed installed or uninstalled. Widgets may be assigned a private colormap by specifying a -colormap option; the window manager is responsible for installing and uninstalling colormaps as necessary. Note that Tk provides no useful details for this event type.)
 *             $(PARAM_ROW &lt;Circulate&gt; $(BR) &lt;Gravity&gt; $(BR) &lt;Reparent&gt;, The events Gravity and Reparent are not normally delivered to Tk applications. They are included for completeness. A Circulate event indicates that the window has moved to the top or to the bottom of the stacking order as a result of an XCirculateSubwindows protocol request. Note that the stacking order may be changed for other reasons which do not generate a Circulate event, and that Tk does not use XCirculateSubwindows() internally. This event type is included only for completeness; there is no reliable way to track changes to a window's position in the stacking order.)
 *         )
 *     )
 *
 * See_Also:
 *     $(LINK2 ./element.html, tkd.element.element)
 */
abstract class UiElement : Element
{
	/**
	 * Construct the element.
	 *
	 * Params:
	 *     parent = An optional parent of this element.
	 */
	public this(UiElement parent = null)
	{
		super(parent);
	}

	/**
	 * Get the widget's class.
	 *
	 * Returns:
	 *     The widget's class as a string.
	 *
	 * See_Also:
	 *     $(LINK2 ./elementclass.html, tkd.element.elementclass) for returned classes.
	 */
	public string getClass()
	{
		this._tk.eval(format("%s cget -class", this.id));
		if (this._tk.getResult!(string).empty())
		{
			this._tk.eval(format("winfo class %s", this.id));
		}
		return this._tk.getResult!(string);
	}

	/**
	 * Set the widget's cursor.
	 *
	 * Params:
	 *     cursor = Any valid widget cursor.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./cursor.html, tkd.element.cursor) for supported cursors.
	 */
	public auto setCursor(this T)(string cursor)
	{
		this._tk.eval(format("%s configure -cursor %s", this.id, cursor));

		return cast(T) this;
	}

	/**
	 * Get the widget's cursor.
	 *
	 * Returns:
	 *     The widget's cursor.
	 *
	 * See_Also:
	 *     $(LINK2 ./cursor.html, tkd.element.cursor) for returned cursors.
	 */
	public string getCursor()
	{
		this._tk.eval(format("%s cget -cursor", this.id));
		return this._tk.getResult!(string);
	}

	/**
	 * Bind a callback to a particular event triggered by this element.
	 *
	 * Params:
	 *     binding = The binding that triggers this event. See below.
	 *     callback = The delegate callback to execute when the event triggers.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * Bindings:
	 *     Bindings can be any of the preset events listed above or you can 
	 *     create custom bindings from lists of modifiers. All bindings must be 
	 *     inside angled brackets.
	 *
	 *     Modifiers consist of any of the following values:
	 *     $(P
	 *         $(PARAM_TABLE
	 *             $(PARAM_ROW &lt;Alt&gt;, The Alt key.)
	 *             $(PARAM_ROW &lt;Button1&gt; $(BR) &lt;B1&gt;, Mouse button one.)
	 *             $(PARAM_ROW &lt;Button2&gt; $(BR) &lt;B2&gt;, Mouse button two.)
	 *             $(PARAM_ROW &lt;Button3&gt; $(BR) &lt;B3&gt;, Mouse button three.)
	 *             $(PARAM_ROW &lt;Button3&gt; $(BR) &lt;B5&gt;, Mouse button five.)
	 *             $(PARAM_ROW &lt;Button4&gt; $(BR) &lt;B4&gt;, Mouse button four.)
	 *             $(PARAM_ROW &lt;Control&gt;, The Ctrl key.)
	 *             $(PARAM_ROW &lt;Double&gt;, Modifier for doing something twice.)
	 *             $(PARAM_ROW &lt;Extended&gt;, Extended keyboard support.)
	 *             $(PARAM_ROW &lt;Lock&gt;, Unknown.)
	 *             $(PARAM_ROW &lt;Meta&gt; $(BR) &lt;M&gt;, The meta key.)
	 *             $(PARAM_ROW &lt;Mod1&gt; $(BR) &lt;M1&gt; $(BR) &lt;Command&gt;, First modifier key.)
	 *             $(PARAM_ROW &lt;Mod2&gt; $(BR) &lt;M2&gt; $(BR) &lt;Option&gt;, Second modifier key.)
	 *             $(PARAM_ROW &lt;Mod3&gt; $(BR) &lt;M3&gt;, Third modifier key.)
	 *             $(PARAM_ROW &lt;Mod4&gt; $(BR) &lt;M4&gt;, Fourth modifier key.)
	 *             $(PARAM_ROW &lt;Mod5&gt; $(BR) &lt;M5&gt;, Fifth modifier key.)
	 *             $(PARAM_ROW &lt;Quadruple&gt;, Modifier for doing something four times.)
	 *             $(PARAM_ROW &lt;Shift&gt;, The Shift key.)
	 *             $(PARAM_ROW &lt;Triple&gt;, Modifier for doing something three times.)
	 *         )
	 *     )
	 *     Where more than one value is listed, the values are equivalent. Most 
	 *     of the modifiers have the obvious meanings. For example, Button1 
	 *     requires that button 1 be depressed when the event occurs. For a 
	 *     binding to match a given event, the modifiers in the event must 
	 *     include all of those specified in the event pattern. An event may 
	 *     also contain additional modifiers not specified in the binding. For 
	 *     example, if button 1 is pressed while the shift and control keys are 
	 *     down, the pattern $(B &lt;Control-Button-1&gt;) will match the 
	 *     event, but $(B &lt;Mod1-Button-1&gt;) will not. If no modifiers are 
	 *     specified, then any combination of modifiers may be present in the 
	 *     event.
	 *
	 *     Meta and M refer to whichever of the M1 through M5 modifiers is 
	 *     associated with the Meta key(s) on the keyboard. If there are no 
	 *     Meta keys, or if they are not associated with any modifiers, then 
	 *     Meta and M will not match any events. Similarly, the Alt modifier 
	 *     refers to whichever modifier is associated with the alt key(s) on 
	 *     the keyboard.
	 *
	 *     The Double, Triple and Quadruple modifiers are a convenience for 
	 *     specifying double mouse clicks and other repeated events. They cause 
	 *     a particular event pattern to be repeated 2, 3 or 4 times, and also 
	 *     place a time and space requirement on the sequence: for a sequence 
	 *     of events to match a Double, Triple or Quadruple pattern, all of the 
	 *     events must occur close together in time and without substantial 
	 *     mouse motion in between. For example, $(B &lt;Double-Button-1&gt;) 
	 *     is equivalent to $(B &lt;Button-1&gt;&lt;Button-1&gt;) with the 
	 *     extra time and space requirement.
	 *
	 *     The Command and Option modifiers correspond to Macintosh-specific 
	 *     modifier keys.
	 *
	 *     The Extended modifier is, at present, specific to Windows. It 
	 *     appears on events that are associated with the keys on the 'extended 
	 *     keyboard'. On a US keyboard, the extended keys include the Alt and 
	 *     Control keys at the right of the keyboard, the cursor keys in the 
	 *     cluster to the left of the numeric pad, the NumLock key, the 
	 *     Break key, the PrintScreen key, and the / and Enter keys in the 
	 *     numeric keypad.
	 *
	 * See_Also:
	 *     $(LINK2 ./element.html#CommandCallback, tkd.element.element.CommandCallback)
	 */
	public auto bind(this T)(string binding, CommandCallback callback)
	{
		string command = this.createCommand(callback, binding);
		this._tk.eval("bind %s {%s} {%s %%b %%k %%x %%y %%D %%K %%X %%Y}", this.id, binding, command);

		return cast(T) this;
	}

	/**
	 * Unbind a previous event binding.
	 *
	 * Params:
	 *     binding = The binding to remove.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto unbind(this T)(string binding)
	{
		this._tk.deleteCommand(this.getCommandName(binding));
		this._tk.eval("bind %s {%s} {}", this.id, binding);

		return cast(T) this;
	}

	/**
	 * Destroy this element and remove it from the GUI.
	 *
	 * Caveats:
	 *     Once an element is destroyed it can no longer be referenced in your 
	 *     code or a segmentation fault will occur and potentially crash your 
	 *     program.
	 */
	public void destroy()
	{
		this._tk.eval("destroy %s", this.id);
		super.destroy();
	}

	/**
	 * Get the string id's of the immediate children elements.
	 *
	 * Returns:
	 *     A string array containing the id's.
	 */
	public string[] getChildIds()
	{
		this._tk.eval("winfo children %s", this.id);

		return this._tk.getResult!(string).split();
	}

	/**
	 * Get the width of the element.
	 *
	 * Returns:
	 *     The width of the element.
	 */
	public int getWidth()
	{
		this._tk.eval("winfo width %s", this.id);

		return this._tk.getResult!(int);
	}

	/**
	 * Get the height of the element.
	 *
	 * Returns:
	 *     The height of the element.
	 */
	public int getHeight()
	{
		this._tk.eval("winfo height %s", this.id);

		return this._tk.getResult!(int);
	}

	/**
	 * Get the platform specific window id. This is equal to the hwnd on 
	 * Windows or the x11 window id on Linux.
	 *
	 * Bugs:
	 *     Unknown if this works on Mac OSX.
	 *
	 * Returns:
	 *     The platform specific window id.
	 */
	public @property size_t hwnd()
	{
		this._tk.eval("winfo id %s", this.id);

		return this._tk.getResult!(string).chompPrefix("0x").to!(size_t)(16);
	}

	/**
	 * Get the position of the cursor over the element. The cursor 
	 * position returned is relative to the screen. It is only returned if the 
	 * cursor is over the element.
	 *
	 * Returns:
	 *     An array holding the screen position of the cursor.
	 */
	public int[] getCursorPos()
	{
		this._tk.eval("winfo pointerxy %s", this.id);

		return this._tk.getResult!(string).split().map!(to!(int)).array;
	}

	/**
	 * Get the horizontal position of the cursor over the element. The cursor 
	 * position returned is relative to the screen. It is only returned if the 
	 * cursor is over the element.
	 *
	 * Returns:
	 *     The horizontal screen position of the cursor.
	 */
	public int getCursorXPos()
	{
		this._tk.eval("winfo pointerx %s", this.id);

		return this._tk.getResult!(int);
	}

	/**
	 * Get the vertical position of the cursor over the element. The cursor 
	 * position returned is relative to the screen. It is only returned if the 
	 * cursor is over the element.
	 *
	 * Returns:
	 *     The vertical screen position of the cursor.
	 */
	public int getCursorYPos()
	{
		this._tk.eval("winfo pointery %s", this.id);

		return this._tk.getResult!(int);
	}

	/**
	 * Get the width of the screen this element is displayed on.
	 *
	 * Returns:
	 *     The width of the screen.
	 */
	public int getScreenWidth()
	{
		this._tk.eval("winfo screenwidth %s", this.id);

		return this._tk.getResult!(int);
	}

	/**
	 * Get the height of the screen this element is displayed on.
	 *
	 * Returns:
	 *     The height of the screen.
	 */
	public int getScreenHeight()
	{
		this._tk.eval("winfo screenheight %s", this.id);

		return this._tk.getResult!(int);
	}

	/**
	 * Get the horizontal position of the element. The number returned is 
	 * calculated using the top, left-most pixel of the element including 
	 * border if one exists.
	 *
	 * Params:
	 *     relativeToParent = True to get the position relative to its parent, false for the position on the screen.
	 *
	 * Returns:
	 *     The horizontal position of the element.
	 */
	public int getXPos(bool relativeToParent = false)
	{
		if (relativeToParent)
		{
			this._tk.eval("winfo x %s", this.id);
		}
		else
		{
			this._tk.eval("winfo rootx %s", this.id);
		}

		return this._tk.getResult!(int);
	}

	/**
	 * Get the vertical position of the element. The number returned is 
	 * calculated using the top, left-most pixel of the element including 
	 * border if one exists.
	 *
	 * Params:
	 *     relativeToParent = True to get the position relative to its parent, false for the position on the screen.
	 *
	 * Returns:
	 *     The vertical position of the element.
	 */
	public int getYPos(bool relativeToParent = false)
	{
		if (relativeToParent)
		{
			this._tk.eval("winfo y %s", this.id);
		}
		else
		{
			this._tk.eval("winfo rooty %s", this.id);
		}

		return this._tk.getResult!(int);
	}

	/**
	 * Set if the element should change it size when requested to do so by a 
	 * geometry manager.
	 *
	 * Params:
	 *     enable = True to enable, false to disable.
	 *
	 * Returns:
	 *     This element to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../widget/widget.html#Widget.pack, tkd.widget.widget.Widget.pack) $(BR)
	 *     $(LINK2 ../widget/widget.html#Widget.grid, tkd.widget.widget.Widget.grid) $(BR)
	 */
	public auto enableGeometryAutoSize(this T)(bool enable)
	{
		this._tk.eval("pack propagate %s %s", this.id, enable);
		this._tk.eval("grid propagate %s %s", this.id, enable);

		return cast(T) this;
	}

	/**
	 * Used by the grid geometry manager. Sets options for columns.
	 *
	 * Params:
	 *     index = The index of the column to configure.
	 *     weight = The weight of the column while expanding.
	 *     minSize = The min size of the column.
	 *     uniformGroup = The group to which the column will resize in uniform.
	 *     pad = Extra padding for the column.
	 *
	 * Returns:
	 *     This element to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../widget/widget.html#Widget.grid, tkd.widget.widget.Widget.grid) $(BR)
	 */
	public auto configureGeometryColumn(this T)(int index, int weight, int minSize, int uniformGroup = 0, int pad = 0)
	{
		this._tk.eval("grid columnconfigure %s %s -weight %s -minsize %s -uniform %s -pad %s", this.id, index, weight, minSize, uniformGroup, pad);

		return cast(T) this;
	}

	/**
	 * Used by the grid geometry manager. Sets options for row.
	 *
	 * Params:
	 *     index = The index of the row to configure.
	 *     weight = The weight of the row while expanding.
	 *     minSize = The min size of the row.
	 *     uniformGroup = The group to which the row will resize in uniform.
	 *     pad = Extra padding for the row.
	 *
	 * Returns:
	 *     This element to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../widget/widget.html#Widget.grid, tkd.widget.widget.Widget.grid) $(BR)
	 */
	public auto configureGeometryRow(this T)(int index, int weight, int minSize, int uniformGroup = 0, int pad = 0)
	{
		this._tk.eval("grid rowconfigure %s %s -weight %s -minsize %s -uniform %s -pad %s", this.id, index, weight, minSize, uniformGroup, pad);

		return cast(T) this;
	}
}
