/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.widget;

/**
 * Imports.
 */
import core.stdc.stdlib;
import std.array;
import std.algorithm;
import std.conv;
import std.digest.crc;
import std.random;
import std.range;
import std.string;
import tcltk.tk;
import tkd.tk;

/**
 * Alias representing a widget callback triggered during events.
 */
alias void delegate(Widget sender, EventArgs args) WidgetCallback;

/**
 * The EventArgs struct passed to the WidgetCallback on invocation.
 */
struct EventArgs
{
	/**
	 * The widget that raised the event.
	 */
	Widget widget;

	/**
	 * The event that occurred.
	 */
	string binding;

	/**
	 * The callback which was called during the event.
	 */
	WidgetCallback callback;
}

/**
 * The widget base class.
 */
abstract class Widget
{
	/**
	 * The Tk interpreter.
	 */
	protected Tk _tk;

	/**
	 * The unique hash of this widget.
	 */
	protected string _hash;

	/**
	 * The parent of this widget if nested within another.
	 */
	protected Widget _parent;

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 */
	this(Widget parent = null)
	{
		this._tk     = Tk.getInstance();
		this._parent = parent;
		this._hash   = this.generateHash();
	}

	/**
	 * Accessor for the unique widget hash.
	 *
	 * Returns:
	 *     The string hash.
	 */
	public @property string hash()
	{
		return this._hash;
	}

	/**
	 * The unique id of this widget.
	 *
	 * Returns:
	 *     The string id.
	 */
	public @property string id()
	{
		string parentId;

		if (this._parent !is null)
		{
			parentId = this._parent.id;
		}

		return format("%s.widget-%s", parentId, this._hash);
	}

	/**
	 * The parent widget if any.
	 *
	 * Returns:
	 *     The parent widget.
	 */
	public @property Widget parent()
	{
		return this._parent;
	}

	/**
	 * Geometry method for placing the widget onto the interface.
	 */
	public void pack()
	{
		string tkScript = format("pack %s -padx 10 -pady 10", this.id);

import std.stdio;
writefln("Geometry: %s", tkScript);

		this._tk.eval(tkScript);
	}

	/**
	 * Bind an event to this widget.
	 *
	 * Params:
	 *     binding = The binding that triggers this event.
	 *     callback = The delegate callback to execute when the event triggers.
	 */
	public void bind(string binding, WidgetCallback callback)
	{
		this.unbind(binding);

		EventArgs* eventArgs  = cast(EventArgs*)malloc(EventArgs.sizeof);

		(*eventArgs).widget   = this;
		(*eventArgs).binding  = binding;
		(*eventArgs).callback = callback;

		string command  = format("command-%s", hexDigest!(CRC32)(binding ~ this.id).array.to!(string));
		string tkScript = format("bind %s %s { %s }", this.id, binding, command);

import std.stdio;
writefln("Bind    : %s", tkScript);

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
		string command  = format("command-%s", hexDigest!(CRC32)(this.id).array.to!(string));
		string tkScript = format("bind %s %s { }", this.id, binding);

import std.stdio;
writefln("Unbind  : %s", tkScript);

		this._tk.deleteCommand(command);
		this._tk.eval(tkScript);
	}

	/**
	 * Generate the unique hash for this widget.
	 *
	 * Returns:
	 *     The string hash.
	 */
	protected string generateHash()
	{
		uint number = Random(unpredictableSeed).front;
		return hexDigest!(CRC32)(number.to!(string)).array.to!(string);
	}
}

/**
 * The function used to create new commands. All bound events trigger for the above widget call this function.
 *
 * Params:
 *     data = Client data registered with the new command.
 *     tclInterpreter = The native Tcl interpreter.
 *     argc = The number of parameters called from Tcl.
 *     argv = A pointer to an array of string parameters called from Tcl.
 */
private extern(C) int commandCallback(ClientData data, Tcl_Interp* tclInterpreter, int argc, const(char)** argv) nothrow
{
	scope (failure)
	{
		Tcl_SetResult(tclInterpreter, "Error occurred in event callback.".toStringz, TCL_STATIC);
		return TCL_ERROR;
	}

	EventArgs eventArgs = *cast(EventArgs*)data;
	eventArgs.callback(eventArgs.widget, eventArgs);

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

scope (failure) return;
EventArgs eventArgs = *cast(EventArgs*)data;
import std.stdio;
writefln("Freeing : 0x%X (%s)", data, eventArgs.widget.id);

	free(data);
}
