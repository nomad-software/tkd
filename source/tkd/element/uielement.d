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
		if (this._tk.getResult().empty())
		{
			this._tk.eval(format("winfo class %s", this.id));
		}
		return this._tk.getResult();
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
		return this._tk.getResult();
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
