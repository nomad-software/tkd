/**
 * Command module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.command;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Command()
{
	import std.string;
	import tcltk.tk;
	import tkd.widget.widget;

	/**
	 * Add a command to a widget.
	 *
	 * Params:
	 *     callback = The delegate callback to execute when invoking the command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../widget.html#WidgetCommandCallback, tkd.widget.WidgetCommandCallback)
	 */
	public auto setCommand(WidgetCommandCallback callback)
	{
		this.removeCommand();

		Tcl_CmdProc commandCallbackHandler = function(ClientData data, Tcl_Interp* tclInterpreter, int argc, const(char)** argv)
		{
			CommandArgs args = *cast(CommandArgs*)data;

			try
			{
				args.callback(args.widget, args);
			}
			catch (Throwable ex)
			{
				string error = "Error occurred in command callback. ";
				error ~= ex.msg ~ "\n";
				error ~= "Widget: " ~ args.widget.id ~ "\n";

				Tcl_SetResult(tclInterpreter, error.toStringz, TCL_STATIC);
				return TCL_ERROR;
			}

			return TCL_OK;
		};

		Tcl_CmdDeleteProc deleteCallbackHandler = function(ClientData data)
		{
			free(data);
		};

		CommandArgs* args = cast(CommandArgs*)malloc(CommandArgs.sizeof);

		(*args).widget   = this;
		(*args).callback = callback;

		string command  = format("command-%s", this.generateHash("command" ~ this.id));
		string tkScript = format("%s configure -command %s", this.id, command);

		this._tk.createCommand(command, commandCallbackHandler, args, deleteCallbackHandler);
		this._tk.eval(tkScript);

		return this;
	}

	/**
	 * Remove a previously set command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto removeCommand()
	{
		string command  = format("command-%s", this.generateHash("command" ~ this.id));
		string tkScript = format("%s configure -command { }", this.id);

		this._tk.deleteCommand(command);
		this._tk.eval(tkScript);

		return this;
	}
}
