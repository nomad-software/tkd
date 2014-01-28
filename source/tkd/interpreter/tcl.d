/**
 * Tcl interpreter module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.interpreter.tcl;

/**
 * Imports.
 */
import std.conv;
import std.string;
import tcltk.tcl;
import tkd.interpreter.logger;

/**
 * Simple wrapper for the Tcl interpreter.
 */
class Tcl
{
	/**
	 * An instance of the native tcl interpreter.
	 */
	protected Tcl_Interp* _interpreter;

	/**
	 * An instance of this tcl interpreter.
	 */
	private static Tcl _instance;

	/**
	 * The logger.
	 */
	protected Logger _log;

	/**
	 * Create the interpreter and initialise it.
	 *
	 * Throws:
	 *     Exception if Tcl interpreter cannot be initialised.
	 */
	protected this()
	{
		debug this._log = new Logger();
		debug this._log.info("Inititalising Tcl");

		this._interpreter = Tcl_CreateInterp();

		if (Tcl_Init(this._interpreter) != TCL_OK)
		{
			throw new Exception(Tcl_GetStringResult(this._interpreter).to!(string));
		}
	}

	/**
	 * Clean up.
	 */
	protected ~this()
	{
		debug this._log.info("Cleaning up Tcl");

		Tcl_DeleteInterp(this._interpreter);
	}

	/**
	 * Get the instance of this class.
	 *
	 * Returns:
	 *     If An instance doesn't exist, one is created and returned.
	 *     If one already exists, that is returned.
	 */
	public static Tcl getInstance()
	{
		if (Tcl._instance is null)
		{
			Tcl._instance = new Tcl();
		}
		return Tcl._instance;
	}

	/**
	 * Evaluate a script fragment using the interpreter.
	 *
	 * Params:
	 *     script = The script to evaluate, including any format placeholders.
	 *     args = variadic list of arguments to provide data for any format placeholders.
	 *
	 * Returns:
	 *     An int equal to TCL_OK or TCL_ERROR.
	 */
	public int eval(A...)(string script, A args)
	{
		debug this._log.info(script, args);

		return Tcl_EvalEx(this._interpreter, format(script, args).toStringz, -1, 0);
	}

	/**
	 * Set the result of the interpreter.
	 * This is sometimes used to set the result to an error if things go bad.
	 *
	 * Params:
	 *     result = The text to set as the result, including any format placeholders.
	 *     args = variadic list of arguments to provide data for any format placeholders.
	 */
	public void setResult(A...)(string result, A args)
	{
		Tcl_SetResult(this._interpreter, format(result, args).toStringz, TCL_STATIC);
	}

	/**
	 * Get the result string from the interpreter.
	 *
	 * Returns:
	 *     A string representing the result of the last script fragment evaluated.
	 */
	public string getResult()
	{
		return Tcl_GetStringResult(this._interpreter).to!(string);
	}

	/**
	 * Create a new command in the Tcl interpreter.
	 *
	 * Params:
	 *     name = The name of the new command.
	 *     commandProcedure = A function pointer to the new command.
	 *     data = Extra data to be passed to the command on invocation.
	 *     deleteProcedure = The procedure to run when deleteCommand is called.
	 */
	public Tcl_Command createCommand(string name, Tcl_CmdProc commandProcedure, ClientData data = null, Tcl_CmdDeleteProc deleteProcedure = null)
	{
		debug this._log.info("Creating command %s", name);

		return Tcl_CreateCommand(this._interpreter, name.toStringz, commandProcedure, data, deleteProcedure);
	}

	/**
	 * Delete a command in the Tcl interpreter.
	 *
	 * Params:
	 *     name = The name of the command to delete.
	 *
	 * Returns:
	 *     TCL_OK on success, -1 if the command didn't exist.
	 */
	public int deleteCommand(string name)
	{
		debug this._log.info("Deleting command %s", name);

		return Tcl_DeleteCommand(this._interpreter, name.toStringz);
	}

	/**
	 * Set the value of a variable.
	 * If the variable doesn't exist it is created.
	 *
	 * Params:
	 *     name = The name of the variable to set.
	 *     value = The variable's value.
	 */
	public void setVariable(string name, string value)
	{
		debug this._log.info("Setting variable %s", name);

		Tcl_SetVar(this._interpreter, name.toStringz, value.toStringz, TCL_GLOBAL_ONLY);
	}

	/**
	 * Get the value of a variable.
	 *
	 * Params:
	 *     name = The name of the variable to get the value of.
	 *
	 * Returns:
	 *     A string containing the variable's value.
	 */
	public string getVariable(string name)
	{
		debug this._log.info("Getting variable %s", name);

		return Tcl_GetVar(this._interpreter, name.toStringz, TCL_GLOBAL_ONLY).to!(string);
	}

	/**
	 * Delete a variable from the interpreter.
	 *
	 * Params:
	 *     name = The name of the variable to delete.
	 *
	 * Returns:
	 *     TCL_OK on success, TCL_ERROR on failure.
	 */
	public int deleteVariable(string name)
	{
		debug this._log.info("Deleting variable %s", name);

		return Tcl_UnsetVar(this._interpreter, name.toStringz, TCL_GLOBAL_ONLY);
	}
}
