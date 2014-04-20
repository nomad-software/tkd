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
import std.algorithm;
import std.conv;
import std.range;
import std.string;
import tkd.element.cursor;
import tkd.element.element;

/**
 * The ui element base class.
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
	 *     The binding argument specifies a sequence of one or more event 
	 *     patterns, with optional white space between the patterns. Each event 
	 *     pattern may take one of three forms. In the simplest case it is a 
	 *     single printing ASCII character, such as a or [. The character may 
	 *     not be a space character or the character &lt;. This form of pattern 
	 *     matches a KeyPress event for the particular character. The second 
	 *     form of pattern is longer but more general. It has the following 
	 *     syntax.
	 *     ----
	 *     <modifier-modifier-type-detail>
	 *     ----
	 *     The entire event pattern is surrounded by angle brackets. Inside the 
	 *     angle brackets are zero or more modifiers, an event type, and an 
	 *     extra piece of information (detail) identifying a particular button 
	 *     or keysym. Any of the fields may be omitted, as long as at least one 
	 *     of type and detail is present. The fields must be separated by white 
	 *     space or dashes (dashes are prefered). The third form of pattern is 
	 *     used to specify a user-defined, named virtual event. It has the 
	 *     following syntax.
	 *     ----
	 *     <<name>>
	 *     ----
	 *     The entire virtual event pattern is surrounded by double angle 
	 *     brackets. Inside the angle brackets is the user-defined name of the 
	 *     virtual event. Modifiers, such as Shift or Control, may not be 
	 *     combined with a virtual event to modify it. Bindings on a virtual 
	 *     event may be created before the virtual event is defined, and if the 
	 *     definition of a virtual event changes dynamically, all windows bound 
	 *     to that virtual event will respond immediately to the new 
	 *     definition. Some widgets (e.g. menu and text) issue virtual events 
	 *     when their internal state is updated in some ways. Please see the 
	 *     documentation for each widget for details.
	 *
	 * Event_Modifiers:
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
	 * Event_Types:
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
	 * Event_Details:
	 *     The last part of a long event specification is detail. In the case 
	 *     of a ButtonPress or ButtonRelease event, it is the number of a 
	 *     button (1-5). If a button number is given, then only an event on 
	 *     that particular button will match; if no button number is given, 
	 *     then an event on any button will match. Note: giving a specific 
	 *     button number is different than specifying a button 
	 *     modifier; in the first case, it refers to a button being 
	 *     pressed or released, while in the second it refers to some 
	 *     other button that is already depressed when the matching 
	 *     event occurs. If a button number is given then type may be 
	 *     omitted; if will default to ButtonPress. For example, the 
	 *     specifier $(B &lt;1&gt;) is equivalent to $(B &lt;ButtonPress-1&gt;).
	 *
	 *     If the event type is KeyPress or KeyRelease, then detail may be 
	 *     specified in the form of an X keysym. Keysyms are textual 
	 *     specifications for particular keys on the keyboard; they include all 
	 *     the alphanumeric ASCII characters (e.g. “a” is the keysym for the 
	 *     ASCII character “a”), plus descriptions for non-alphanumeric 
	 *     characters (“comma”is the keysym for the comma character), plus 
	 *     descriptions for all the non-ASCII keys on the keyboard (e.g. 
	 *     “Shift_L” is the keysym for the left shift key, and “F1” is 
	 *     the keysym for the F1 function key, if it exists). The 
	 *     complete list of keysyms is not presented here; it is available in 
	 *     other X documentation and may vary from system to system. If a 
	 *     keysym detail is given, then the type field may be omitted; it will 
	 *     default to KeyPress. For example, $(B &lt;Control-comma&gt;) is 
	 *     equivalent to $(B &lt;Control-KeyPress-comma&gt;).
	 *
	 * Virtual_Events:
	 *     The following are built-in virtual events for the purposes of notification:
	 *     $(P
	 *         $(PARAM_TABLE
	 *             $(PARAM_ROW &lt;&lt;AltUnderlined&gt;&gt;, This is sent to widget to notify it that the letter it has underlined (as an accelerator indicator) with the -underline option has been pressed in combination with the Alt key. The usual response to this is to either focus into the widget (or some related widget) or to invoke the widget.)
	 *             $(PARAM_ROW &lt;&lt;Invoke&gt;&gt;, This can be sent to some widgets (e.g. button, listbox, menu) as an alternative to &lt;space&gt;.)
	 *             $(PARAM_ROW &lt;&lt;ListboxSelect&gt;&gt;, This is sent to a listbox when the set of selected item(s) in the listbox is updated.)
	 *             $(PARAM_ROW &lt;&lt;MenuSelect&gt;&gt;, This is sent to a menu when the currently selected item in the menu changes. It is intended for use with context-sensitive help systems.)
	 *             $(PARAM_ROW &lt;&lt;Modified&gt;&gt;, This is sent to a text widget when the contents of the widget are changed.)
	 *             $(PARAM_ROW &lt;&lt;Selection&gt;&gt;, This is sent to a text widget when the selection in the widget is changed.)
	 *             $(PARAM_ROW &lt;&lt;ThemeChanged&gt;&gt;, This is sent to a text widget when the ttk (Tile) theme changed.)
	 *             $(PARAM_ROW &lt;&lt;TraverseIn&gt;&gt;, This is sent to a widget when the focus enters the widget because of a user-driven “tab to widget” action.)
	 *             $(PARAM_ROW &lt;&lt;TraverseOut&gt;&gt;, This is sent to a widget when the focus leaves the widget because of a user-driven “tab to widget” action.)
	 *         )
	 *     )
	 *     The following are built-in virtual events for the purposes of unifying bindings across multiple platforms.
	 *     $(P
	 *         $(PARAM_TABLE
	 *             $(PARAM_ROW &lt;&lt;Clear&gt;&gt;, Delete the currently selected widget contents.)
	 *             $(PARAM_ROW &lt;&lt;Copy&gt;&gt;, Copy the currently selected widget contents to the clipboard.)
	 *             $(PARAM_ROW &lt;&lt;Cut&gt;&gt;, Move the currently selected widget contents to the clipboard.)
	 *             $(PARAM_ROW &lt;&lt;LineEnd&gt;&gt;, Move to the end of the line in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;LineStart&gt;&gt;, Move to the start of the line in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;NextChar&gt;&gt;, Move to the next item (i.e., visible character) in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;NextLine&gt;&gt;, Move to the next line in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;NextPara&gt;&gt;, Move to the next paragraph in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;NextWord&gt;&gt;, Move to the next group of items (i.e., visible word) in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;Paste&gt;&gt;, Replace the currently selected widget contents with the contents of the clipboard.)
	 *             $(PARAM_ROW &lt;&lt;PasteSelection&gt;&gt;, Insert the contents of the selection at the mouse location. (This event has meaningful %x and %y substitutions).)
	 *             $(PARAM_ROW &lt;&lt;PrevChar&gt;&gt;, Move to the previous item (i.e., visible character) in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;PrevLine&gt;&gt;, Move to the previous line in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;PrevPara&gt;&gt;, Move to the previous paragraph in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;PrevWindow&gt;&gt;, Traverse to the previous window.)
	 *             $(PARAM_ROW &lt;&lt;PrevWord&gt;&gt;, Move to the previous group of items (i.e., visible word) in the current widget while deselecting any selected contents.)
	 *             $(PARAM_ROW &lt;&lt;Redo&gt;&gt;, Redo one undone action.)
	 *             $(PARAM_ROW &lt;&lt;SelectAll&gt;&gt;, Set the range of selected contents to the complete widget.)
	 *             $(PARAM_ROW &lt;&lt;SelectLineEnd&gt;&gt;, Move to the end of the line in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;SelectLineStart&gt;&gt;, Move to the start of the line in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;SelectNextChar&gt;&gt;, Move to the next item (i.e., visible character) in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;SelectNextLine&gt;&gt;, Move to the next line in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;SelectNextPara&gt;&gt;, Move to the next paragraph in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;SelectNextWord&gt;&gt;, Move to the next group of items (i.e., visible word) in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;SelectNone&gt;&gt;, Reset the range of selected contents to be empty.)
	 *             $(PARAM_ROW &lt;&lt;SelectPrevChar&gt;&gt;, Move to the previous item (i.e., visible character) in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;SelectPrevLine&gt;&gt;, Move to the previous line in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;SelectPrevPara&gt;&gt;, Move to the previous paragraph in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;SelectPrevWord&gt;&gt;, Move to the previous group of items (i.e., visible word) in the current widget while extending the range of selected contents.)
	 *             $(PARAM_ROW &lt;&lt;ToggleSelection&gt;&gt;, Toggle the selection.)
	 *             $(PARAM_ROW &lt;&lt;Undo&gt;&gt;, Undo the last action.)
	 *         )
	 *     )
	 *
	 * Callback_Arguments:
	 *     These are the fields within the callback's $(LINK2 
	 *     ./element.html#CommandArgs, CommandArgs) parameter which 
	 *     are populated by this method when the callback is executed. 
	 *     $(P
	 *         $(PARAM_TABLE
	 *             $(PARAM_ROW CommandArgs.element, The element that executed the callback.)
	 *             $(PARAM_ROW CommandArgs.uniqueData, The binding that was responded to.)
	 *             $(PARAM_ROW CommandArgs.callback, The callback which was executed.)
	 *             $(PARAM_ROW CommandArgs.event.button, The number of any button that was pressed.)
	 *             $(PARAM_ROW CommandArgs.event.keyCode, The key code of any key pressed.)
	 *             $(PARAM_ROW CommandArgs.event.x, The horizontal position of the mouse relative to the widget.)
	 *             $(PARAM_ROW CommandArgs.event.y, The vertical position of the mouse relative to the widget.)
	 *             $(PARAM_ROW CommandArgs.event.wheel, Mouse wheel delta.)
	 *             $(PARAM_ROW CommandArgs.event.key, Key symbol of any key pressed.)
	 *             $(PARAM_ROW CommandArgs.event.screenX, The horizontal position of the mouse relative to the screen.)
	 *             $(PARAM_ROW CommandArgs.event.screenY, The vertical position of the mouse relative to the screen.)
	 *         )
	 *     )
	 *
	 * See_Also:
	 *     $(LINK2 ../tkdapplication.html#TkdApplication.addVirtualEvent, tkd.tkdapplication.TkdApplication.addVirtualEvent) $(BR)
	 *     $(LINK2 ../tkdapplication.html#TkdApplication.deleteVirtualEvent, tkd.tkdapplication.TkdApplication.deleteVirtualEvent) $(BR)
	 *     $(LINK2 ./element.html#CommandCallback, tkd.element.element.CommandCallback) $(BR)
	 *     $(LINK2 ./uielement.html#UiElement.generateEvent, tkd.element.element.UiElement.generateEvent) $(BR)
	 */
	public auto bind(this T)(string binding, CommandCallback callback)
	{
		assert(!std.regex.match(binding, r"^<.*?>$").empty, "Binding must take the form of <binding>");

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
	 * Used by the grid geometry manager. Sets options for grid columns that contain child widgets.
	 *
	 * Params:
	 *     index = The index of the column to configure.
	 *     weight = The weight of the column while expanding. The default is 1. 2 means expand twice as much, etc.
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
	public auto configureGeometryColumn(this T)(int index, int weight, int minSize = 0, int uniformGroup = 0, int pad = 0)
	{
		this._tk.eval("grid columnconfigure %s %s -weight %s -minsize %s -uniform %s -pad %s", this.id, index, weight, minSize, uniformGroup, pad);

		return cast(T) this;
	}

	/**
	 * Used by the grid geometry manager. Sets options for grid rows that contain child widgets.
	 *
	 * Params:
	 *     index = The index of the row to configure.
	 *     weight = The weight of the column while expanding. The default is 1. 2 means expand twice as much, etc.
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
	public auto configureGeometryRow(this T)(int index, int weight, int minSize = 0, int uniformGroup = 0, int pad = 0)
	{
		this._tk.eval("grid rowconfigure %s %s -weight %s -minsize %s -uniform %s -pad %s", this.id, index, weight, minSize, uniformGroup, pad);

		return cast(T) this;
	}

	/**
	 * Provides a simple means to block keyboard, button, and pointer events 
	 * from elements, while overriding the cursor with a configurable busy 
	 * cursor.
	 *
	 * Params:
	 *     busy = Specifies whether this element is busy or not.
	 *     cursor = The cursor to use if the element is busy.
	 *
	 * Returns:
	 *     This element to aid method chaining.
	 *
	 * Caveats:
	 *     Note that this method does not currently have any effect on 
	 *     MacOSX when Tk is built using Aqua support.
	 *
	 * See_Also:
	 *     $(LINK2 ./cursor.html, tkd.element.cursor) $(BR)
	 */
	public auto setBusy(this T)(bool busy, string cursor = Cursor.watch)
	{
		if (busy)
		{
			this._tk.eval("tk busy hold %s -cursor {%s}", this.id, cursor);
		}
		else
		{
			this._tk.eval("tk busy forget %s", this.id);
		}

		return cast(T) this;
	}

	/**
	 * Gets if the element is busy or not.
	 *
	 * Returns:
	 *     true if the element is busy, false if not.
	 *
	 * See_Also:
	 *     $(LINK2 ./cursor.html, tkd.element.cursor) $(BR)
	 */
	public bool isBusy(this T)()
	{
		this._tk.eval("tk busy status %s", this.id);

		return this._tk.getResult!(int) == 1;
	}

	/**
	 * Generates an event and arranges for it to be processed just as if it had 
	 * come from the operating system. Event provides a basic description of 
	 * the event, such as $(B &lt;Shift-Button-2&gt;) or $(B 
	 * &lt;&lt;Paste&gt;&gt;). The event argument may have any of the forms 
	 * allowed for the binding argument of the $(LINK2 
	 * ./uielement.html#UiElement.bind, bind) method except that it must 
	 * consist of a single event pattern only. Certain events, such as key 
	 * events, require that the window has focus to receive the event properly.
	 *
	 * Params:
	 *     event = The event to issue.
	 *
	 * See_Also:
	 *     $(LINK2 ../tkdapplication.html#TkdApplication.addVirtualEvent, tkd.tkdapplication.TkdApplication.addVirtualEvent) $(BR)
	 *     $(LINK2 ../tkdapplication.html#TkdApplication.deleteVirtualEvent, tkd.tkdapplication.TkdApplication.deleteVirtualEvent) $(BR)
	 *     $(LINK2 ./uielement.html#UiElement.bind, tkd.element.uielement.UiElement.bind) $(BR)
	 */
	public void generateEvent(this T)(string event)
	{
		assert(!std.regex.match(event, r"^<.*?>$").empty, "Event must take the form of <binding>");

		this._tk.eval("event generate %s %s", this.id, event);
	}

	/**
	 * Set the element to take focus so any key press or key release events for 
	 * the application are sent to that element. It is also possible to force 
	 * the operating system to apply focus to the element immediately.
	 *
	 * Params:
	 *     force = Whether or not to force the focus.
	 *
	 * Returns:
	 *     This element to aid method chaining.
	 */
	public auto focus(this T)(bool force = false)
	{
		if (force)
		{
			this._tk.eval("focus -force %s", this.id);
		}
		else
		{
			this._tk.eval("focus %s", this.id);
		}

		return cast(T) this;
	}

	/**
	 * This command implements simple pointer and keyboard grabs. When a grab 
	 * is set for a particular element, it restricts all pointer events to the 
	 * grab window and its descendants. Whenever the pointer is within the grab 
	 * element, the pointer will behave exactly the same as if there had been 
	 * no grab at all and all events will be reported in the normal fashion. 
	 * When the pointer is outside the element, button presses, releases and 
	 * mouse motion events are reported to the element, and element entry and 
	 * exit events are ignored. The grab 'owns' the pointer: elements outside 
	 * the grab will be visible on the screen but they will be insensitive 
	 * until the grab is released. The tree of elements underneath the grab 
	 * element can include windows, in which case all windows and their 
	 * descendants will continue to receive mouse events during the grab.
	 *
	 * Two forms of grabs are possible: local and global. A local grab affects 
	 * only the grabbing application: events will be reported to other 
	 * applications as if the grab had never occurred. Grabs are local by 
	 * default. A global grab locks out all applications on the screen, so that 
	 * only the given element and its descendants of the grabbing application 
	 * will be sensitive to pointer events (mouse button presses, mouse button 
	 * releases, pointer motions, entries, and exits). During global grabs the 
	 * window manager will not receive pointer events either.
	 *
	 * During local grabs, keyboard events (key presses and key releases) are 
	 * delivered as usual: the window manager controls which application 
	 * receives keyboard events, and if they are sent to any element in the 
	 * grabbing application then they are redirected to the focused element. 
	 * During a global grab all keyboard events are always sent to the grabbing 
	 * application. The focus command is still used to determine which element 
	 * in the application receives the keyboard events. The keyboard grab is 
	 * released when the grab is released.
	 *
	 * Params:
	 *     enable = Whether to enable or release the grab.
	 *     global = Whether or not the grab should be global.
	 *
	 * Returns:
	 *     This element to aid method chaining.
	 *
	 * Caveats:
	 *     It is very easy to use global grabs to render a display completely 
	 *     unusable (e.g. by setting a grab on an element which does not 
	 *     respond to events and not providing any mechanism for releasing the 
	 *     grab).  Take extreme care when using them! For a global grab to work 
	 *     the element needs to be placed and visible on the UI. Local grabs 
	 *     are not affected by this requirement.
	 */
	public auto setGrab(this T)(bool enable, bool global = false)
	{
		if (!enable)
		{
			this._tk.eval("grab release %s", this.id);
		}
		else if (global)
		{
			this._tk.eval("grab -global %s", this.id);
		}
		else
		{
			this._tk.eval("grab %s", this.id);
		}

		return cast(T) this;
	}

	/**
	 * Gets if the element is currently grabbing all events or not.
	 *
	 * Returns:
	 *     This element to aid method chaining.
	 */
	public bool isGrabbing(this T)()
	{
		this._tk.eval("grab status %s", this.id);

		return this._tk.getResult!(string) != "none";
	}
}
