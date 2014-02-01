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
	 */
	public string getCursor()
	{
		this._tk.eval(format("%s cget -cursor", this.id));
		return this._tk.getResult();
	}

	/**
	 * Bind an event to this element.
	 *
	 * Params:
	 *     binding = The binding that triggers this event.
	 *     callback = The delegate callback to execute when the event triggers.
	 */
	public void bind(string binding, UiElementCallback callback)
	{
		this.unbind(binding);

		EventArgs* eventArgs  = cast(EventArgs*)malloc(EventArgs.sizeof);

		(*eventArgs).element  = this;
		(*eventArgs).binding  = binding;
		(*eventArgs).callback = callback;

		string command  = format("command-%s", this.generateHash(binding ~ this.id));
		string tkScript = format("bind %s %s { %s }", this.id, binding, command);

		this._tk.createCommand(command, &commandCallback, eventArgs, &deleteCommandCallback);
		this._tk.eval(tkScript);
	}

	/**
	 * Unbind a previous binding.
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
 * Alias representing an element callback triggered during events.
 */
alias void delegate(UiElement sender, EventArgs args) UiElementCallback;

/**
 * The EventArgs struct passed to the UiElementCallback on invocation.
 */
struct EventArgs
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
	 * The callback which was called during the event.
	 */
	UiElementCallback callback;
}

/**
 * The function used to create new commands. All bound events trigger for the above element call this function.
 *
 * Params:
 *     data = Client data registered with the new command.
 *     tclInterpreter = The native Tcl interpreter.
 *     argc = The number of parameters called from Tcl.
 *     argv = A pointer to an array of string parameters called from Tcl.
 */
private extern(C) int commandCallback(ClientData data, Tcl_Interp* tclInterpreter, int argc, const(char)** argv) nothrow
{
	EventArgs eventArgs = *cast(EventArgs*)data;

	try
	{
		eventArgs.callback(eventArgs.element, eventArgs);
	}
	catch (Throwable ex)
	{
		string error = "Error occurred in bound callback. ";
		error ~= ex.msg ~ "\n";
		error ~= "UiElement: " ~ eventArgs.element.id ~ "\n";
		error ~= "Binding: " ~ eventArgs.binding ~ "\n";

		Tcl_SetResult(tclInterpreter, error.toStringz, TCL_STATIC);
		return TCL_ERROR;
	}

	return TCL_OK;
}

/**
 * Function automatically called by Tcl when deleting a custom command from the interpreter.
 * Freeing the memory allocated from creating the command's client data.
 *
 * Params:
 *     data = The client data registered with this command on creation.
 */
private extern(C) void deleteCommandCallback(ClientData data) nothrow
{
	free(data);
}
