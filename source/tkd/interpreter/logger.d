/**
 * Logger module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.interpreter.logger;

/**
 * Imports.
 */
import std.datetime;
import std.process;
import std.stdio;
import std.string;

/**
 * A simple class to provide logging support.
 */
class Logger
{
	/**
	 * Level of importance of the text to write to the logger.
	 */
	private enum Level
	{
		/**
		 * The eval level is for evaluated commands.
		 */
		eval,

		/**
		 * The information level used for info messages.
		 */
		information,

		/**
		 * The warning level used for warning messages.
		 */
		warning,

		/**
		 * The error level used for error messages.
		 */
		error,
	}

	/**
	 * The open log file.
	 */
	private File _log;

	/**
	 * Constructor.
	 *
	 * If a log file is not passed, log instead to stdout.
	 *
	 * Params:
	 *     logFile = The log file for logging.
	 */
	final public this(string logFile = null) nothrow
	{
		try
		{
			if (logFile is null)
			{
				this._log = stdout;
			}
			else
			{
				this._log = File(logFile, "w");
			}
		}
		catch (Exception ex)
		{
			assert(false, ex.msg);
		}
	}

	/**
	 * Get the current timestamp for the log.
	 *
	 * Returns:
	 *     The current timestamp.
	 */
	final private string getTimestamp() nothrow
	{
		try
		{
			auto time = Clock.currTime();
			return format("%d/%02d/%02d %d:%02d:%02d", time.year, time.month, time.day, time.hour, time.minute, time.second);
		}
		catch (Exception ex)
		{
			assert(false, ex.msg);
		}
	}

	/**
	 * Write text to the log.
	 *
	 * Params:
	 *     text = The text to write to the log.
	 *     level = The level of the text.
	 */
	final private void log(A...)(Level level, string text, A args) nothrow
	{
		string levelText;

		switch(level)
		{
			case Level.eval:
				levelText = "EVAL";
				break;

			case Level.warning:
				levelText = "WARN";
				break;

			case Level.error:
				levelText = "ERROR";
				break;

			default:
				levelText = "INFO";
				break;
		}

		try
		{
			static if (A.length)
			{
				text = format(text, args);
			}

			this._log.writefln("%s %s: %s", this.getTimestamp(), levelText, text);
			this._log.flush();
		}
		catch (Exception ex)
		{
			assert(false, ex.msg);
		}
	}

	/**
	 * Write eval text to the log.
	 *
	 * Params:
	 *     text = The format of the text to write to the log.
	 *     args = The arguments that the format defines (if any).
	 */
	final public void eval(A...)(string text, A args) nothrow
	{
		this.log(Level.eval, text, args);
	}

	/**
	 * Write info text to the log.
	 *
	 * Params:
	 *     text = The format of the text to write to the log.
	 *     args = The arguments that the format defines (if any).
	 */
	final public void info(A...)(string text, A args) nothrow
	{
		this.log(Level.information, text, args);
	}

	/**
	 * Write warning text to the log.
	 *
	 * Params:
	 *     text = The format of the text to write to the log.
	 *     args = The arguments that the format defines (if any).
	 */
	final public void warning(A...)(string text, A args) nothrow
	{
		this.log(Level.warning, text, args);
	}

	/**
	 * Write error text to the log.
	 *
	 * Params:
	 *     text = The format of the text to write to the log.
	 *     args = The arguments that the format defines (if any).
	 */
	final public void error(A...)(string text, A args) nothrow
	{
		this.log(Level.error, text, args);
	}

}
