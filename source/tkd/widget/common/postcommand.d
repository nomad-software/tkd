/**
 * Post command module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.postcommand;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template PostCommand()
{
	import std.string;
	import tcltk.tk;

	/**
	 * Add a post command to a widget. This is usually to modify the widget after creation.
	 *
	 * Params:
	 *     callback = The delegate callback to execute when invoking the post command.
	 *
	 * See_Also:
	 *     $(LINK2 ../widget.html#WidgetCommandCallback, tkd.widget.WidgetCommandCallback)
	 */
	public void setPostCommand(WidgetCommandCallback callback)
	{
		this.removePostCommand();

		Tcl_CmdProc commandCallbackHandler = function(ClientData data, Tcl_Interp* tclInterpreter, int argc, const(char)** argv)
		{
			CommandArgs args = *cast(CommandArgs*)data;

			try
			{
				args.callback(args.widget, args);
			}
			catch (Throwable ex)
			{
				string error = "Error occurred in post command callback. ";
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

		string command  = format("command-%s", this.generateHash("postcommand" ~ this.id));
		string tkScript = format("%s configure -postcommand %s", this.id, command);

		this._tk.createCommand(command, commandCallbackHandler, args, deleteCallbackHandler);
		this._tk.eval(tkScript);
	}

	/**
	 * Remove a previously set command.
	 */
	public void removePostCommand()
	{
		string command  = format("command-%s", this.generateHash("postcommand" ~ this.id));
		string tkScript = format("%s configure -postcommand { }", this.id);

		this._tk.deleteCommand(command);
		this._tk.eval(tkScript);
	}
}
