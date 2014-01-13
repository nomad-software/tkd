/**
 * Tcl interpreter module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.tcl;

/**
 * Imports.
 */
import std.conv;
import std.string;
import tcltk.tcl;

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
	 * Create the interpreter and initialise it.
	 *
	 * Throws:
	 *     Exception if Tcl interpreter cannot be initialised.
	 */
	protected this()
	{
		this._interpreter = Tcl_CreateInterp();

		if (Tcl_Init(this._interpreter) != TCL_OK)
		{
			throw new Exception(Tcl_GetStringResult(this._interpreter).to!(string));
		}
	}

	/**
	 * Delete the interpreter.
	 */
	protected ~this()
	{
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
		return Tcl_DeleteCommand(this._interpreter, name.toStringz);
	}
}
