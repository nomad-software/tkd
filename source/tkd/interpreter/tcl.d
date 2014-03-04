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
		debug this._log = new Logger("debug.log");
		debug this._log.info("Inititalising Tcl");

		this._interpreter = Tcl_CreateInterp();

		if (Tcl_Init(this._interpreter) != TCL_OK)
		{
			string result = Tcl_GetStringResult(this._interpreter).to!(string);
			throw new Exception(format("Tcl interpreter could not be initialised. %s", result));
		}
	}

	/**
	 * Clean up.
	 */
	protected ~this()
	{
		Tcl_DeleteInterp(this._interpreter);
	}

	/**
	 * Get an instance of this class.
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
	 * Throws:
	 *     Exception if the script evaluation failed.
	 */
	public void eval(A...)(string script, A args)
	{
		debug this._log.eval(script, args);

		int result = Tcl_EvalEx(this._interpreter, format(script, args).toStringz, -1, 0);

		if (result == TCL_ERROR)
		{
			throw new Exception(this.getResult!(string));
		}
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
		debug this._log.info("Setting interpreter result '%s'", format(result, args));
		Tcl_SetResult(this._interpreter, format(result, args).toStringz, TCL_STATIC);
	}

	/**
	 * Get the result string from the interpreter.
	 *
	 * Returns:
	 *     A string representing the result of the last script fragment evaluated.
	 */
	public T getResult(T)()
	{
		string result = Tcl_GetStringResult(this._interpreter).to!(string);
		debug this._log.info("Getting interpreter result '%s'", result);
		return result.to!(T);
	}

	/**
	 * Create a new command in the Tcl interpreter.
	 *
	 * Params:
	 *     name = The name of the new command.
	 *     commandProcedure = A function pointer to the new command.
	 *     data = Extra data to be passed to the command on invocation.
	 *     deleteProcedure = The procedure to run when deleteCommand is called.
	 *
	 * Returns:
	 *     A command token that can be used to refer to the command created.
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
	 * Throws:
	 *     Exception if the command cannot be deleted.
	 */
	public void deleteCommand(string name)
	{
		debug this._log.info("Deleting command %s", name);

		int result = Tcl_DeleteCommand(this._interpreter, name.toStringz);

		if (result == TCL_ERROR)
		{
			throw new Exception(this.getResult!(string));
		}
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
		debug this._log.info("Setting variable %s <- '%s'", name, value);
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
		string result = Tcl_GetVar(this._interpreter, name.toStringz, TCL_GLOBAL_ONLY).to!(string);
		debug this._log.info("Getting variable %s -> '%s'", name, result);
		return result;
	}

	/**
	 * Delete a variable from the interpreter.
	 *
	 * Params:
	 *     name = The name of the variable to delete.
	 *
	 * Throws:
	 *     Exception if the command cannot be deleted.
	 */
	public void deleteVariable(string name)
	{
		debug this._log.info("Deleting variable %s", name);

		int result = Tcl_UnsetVar(this._interpreter, name.toStringz, TCL_GLOBAL_ONLY);

		if (result == TCL_ERROR)
		{
			throw new Exception(this.getResult!(string));
		}
	}

}
