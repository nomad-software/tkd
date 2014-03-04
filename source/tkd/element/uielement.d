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
import core.stdc.stdlib : malloc, free;
import std.range;
import std.string;
import tcltk.tk;
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
 *     $(LINK2 ../element/element.html, tkd.element.element)
 */
abstract class UiElement : Element
{
	/**
	 * The parent of this element if nested within another.
	 */
	protected UiElement _parent;

	/**
	 * Construct the uielement.
	 *
	 * Params:
	 *     parent = An optional parent of this element.
	 */
	public this(UiElement parent = null)
	{
		super();
		this._parent    = parent;
		this._elementId = "uielement";
	}

	/**
	 * The unique id of this element.
	 *
	 * Returns:
	 *     The string id.
	 */
	override public @property string id() nothrow
	{
		string parentId;

		if (this._parent !is null)
		{
			parentId = this._parent.id;
		}

		return parentId ~ "." ~ super.id;
	}

	/**
	 * The parent element if any.
	 *
	 * Returns:
	 *     The parent element.
	 */
	public @property UiElement parent()
	{
		return this._parent;
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
	 * See_Also:
	 *     $(LINK2 ./cursor.html, tkd.element.cursor) for supported cursors.
	 */
	public void setCursor(string cursor)
	{
		this._tk.eval(format("%s configure -cursor %s", this.id, cursor));
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
	 *     binding = The binding that triggers this event.
	 *     callback = The delegate callback to execute when the event triggers.
	 *
	 * See_Also:
	 *     $(LINK2 ./uielement.html#UiElementBindCallback, tkd.element.uielement.UiElementBindCallback)
	 */
	public void bind(string binding, UiElementBindCallback callback)
	{
		this.unbind(binding);

		BindArgs* args  = cast(BindArgs*)malloc(BindArgs.sizeof);

		(*args).element  = this;
		(*args).binding  = binding;
		(*args).callback = callback;

		string command  = format("command-%s", this.generateHash(binding ~ this.id));
		string tkScript = format("bind %s %s { %s }", this.id, binding, command);

		Tcl_CmdProc bindCallbackHandler = function(ClientData data, Tcl_Interp* tclInterpreter, int argc, const(char)** argv)
		{
			BindArgs args = *cast(BindArgs*)data;

			try
			{
				args.callback(args.element, args);
			}
			catch (Throwable ex)
			{
				string error = "Error occurred in bound callback. ";
				error ~= ex.msg ~ "\n";
				error ~= "UiElement: " ~ args.element.id ~ "\n";
				error ~= "Binding: " ~ args.binding ~ "\n";

				Tcl_SetResult(tclInterpreter, error.toStringz, TCL_STATIC);
				return TCL_ERROR;
			}

			return TCL_OK;
		};

		Tcl_CmdDeleteProc deleteBindCallbackHandler = function(ClientData data)
		{
			free(data);
		};

		this._tk.createCommand(command, bindCallbackHandler, args, deleteBindCallbackHandler);
		this._tk.eval(tkScript);
	}

	/**
	 * Unbind a previous event binding.
	 *
	 * Params:
	 *     binding = The binding to remove.
	 */
	public void unbind(string binding)
	{
		string command  = format("command-%s", this.generateHash(binding ~ this.id));
		string tkScript = format("bind %s %s { }", this.id, binding);

		this._tk.deleteCommand(command);
		this._tk.eval(tkScript);
	}
}

/**
 * Alias representing an element callback.
 */
alias void delegate(UiElement sender, BindArgs args) UiElementBindCallback;

/**
 * The BindArgs struct passed to the UiElementBindCallback on invocation.
 */
struct BindArgs
{
	/**
	 * The element that raised the event.
	 */
	UiElement element;

	/**
	 * The event that occurred.
	 */
	string binding;

	/**
	 * The callback which was invoked for the event.
	 */
	UiElementBindCallback callback;
}
