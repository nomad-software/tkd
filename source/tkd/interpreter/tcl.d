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
import std.regex : Captures, regex, replaceAll;
import std.stdio;
import std.string;
import tcltk.tcl;
import tkd.interpreter.logger;

/**
 * Simple wrapper for the Tcl interpreter.
 */
class Tcl
{
	/*
	 * An instance of the native tcl interpreter.
	 */
	protected Tcl_Interp* _interpreter;

	/**
	 * An instance of this tcl interpreter.
	 */
	private static Tcl _instance;

	/*
	 * The logger.
	 */
	protected Logger _log;

	/*
	 * Create the interpreter and initialise it.
	 *
	 * Throws:
	 *     Exception if Tcl interpreter cannot be initialised.
	 */
	protected this()
	{
		debug (log) this._log = new Logger("debug.log");
		debug (log) this._log.info("Inititalising Tcl");

		this._interpreter = Tcl_CreateInterp();

		if (Tcl_Init(this._interpreter) != TCL_OK)
		{
			string result = Tcl_GetStringResult(this._interpreter).to!(string);
			throw new Exception(format("Tcl interpreter could not be initialised. %s", result));
		}
	}

	/*
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
	 * Escape harmful characters in arguments that are to be used in a script.
	 *
	 * Params:
	 *     args = An array of arguments to escape.
	 *
	 * Returns:
	 *     Escaped arguments.
	 */
	public string[] escape(string[] args)
	{
		foreach (ref arg; args)
		{
			arg = this.escape(arg);
		}
		return args;
	}

	/**
	 * Escape harmful characters in the passed argument that is to be used in a 
	 * script.
	 *
	 * Params:
	 *     arg = The argument to escape.
	 *
	 * Returns:
	 *     The argument.
	 */
	public string escape(string arg)
	{
		string replacer(Captures!(string) m)
		{
			final switch(m.hit)
			{
				case `\`:
					return `\\`;

				case `"`:
					return `\"`;

				case `$`:
					return `\$`;

				case `[`:
					return `\[`;

				case `]`:
					return `\]`;
			}
			assert(false);
		}
		return arg.replaceAll!(replacer)(regex(`\\|"|\$|\[|\]`));
	}

	/**
	 * Evaluate a script fragment using the interpreter.
	 *
	 * Params:
	 *     script = The script to evaluate, including any format placeholders.
	 *     args = variadic list of arguments to provide data for any format placeholders.
	 */
	public void eval(A...)(string script, A args)
	{
		foreach (ref arg; args)
		{
			static if (is(typeof(arg) == string))
			{
				arg = this.escape(arg);
			}
		}

		debug (log) this._log.eval(script, args);

		static if (A.length)
		{
			script = format(script, args);
		}

		int result = Tcl_EvalEx(this._interpreter, script.toStringz, -1, 0);

		if (result == TCL_ERROR)
		{
			string error = Tcl_GetStringResult(this._interpreter).to!(string);

			debug (showTclErrors)
			{
				writeln(error);
			}

			debug (log) this._log.warning(error);
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
		static if (A.length)
		{
			result = format(result, args);
		}

		debug (log) this._log.info("Setting interpreter result '%s'", result);
		Tcl_SetResult(this._interpreter, result.toStringz, TCL_STATIC);
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
		debug (log) this._log.info("Getting interpreter result '%s'", result);
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
		debug (log) this._log.info("Creating command %s", name);
		return Tcl_CreateCommand(this._interpreter, name.toStringz, commandProcedure, data, deleteProcedure);
	}

	/**
	 * Delete a command in the Tcl interpreter.
	 *
	 * Params:
	 *     name = The name of the command to delete.
	 */
	public void deleteCommand(string name)
	{
		debug (log) this._log.info("Deleting command %s", name);

		int result = Tcl_DeleteCommand(this._interpreter, name.toStringz);

		if (result == TCL_ERROR)
		{
			string error = Tcl_GetStringResult(this._interpreter).to!(string);

			debug (showTclErrors)
			{
				writeln(error);
			}

			debug (log) this._log.warning(error);
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
	public void setVariable(T)(string name, T value)
	{
		debug (log) this._log.info("Setting variable %s <- '%s'", name, value);
		Tcl_SetVar(this._interpreter, name.toStringz, value.to!(string).toStringz, TCL_GLOBAL_ONLY);
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
		debug (log) this._log.info("Getting variable %s -> '%s'", name, result);
		return result;
	}

	/**
	 * Delete a variable from the interpreter.
	 *
	 * Params:
	 *     name = The name of the variable to delete.
	 */
	public void deleteVariable(string name)
	{
		debug (log) this._log.info("Deleting variable %s", name);

		int result = Tcl_UnsetVar(this._interpreter, name.toStringz, TCL_GLOBAL_ONLY);

		if (result == TCL_ERROR)
		{
			string error = Tcl_GetStringResult(this._interpreter).to!(string);

			debug (showTclErrors)
			{
				writeln(error);
			}

			debug (log) this._log.warning(error);
		}
	}

}
