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

		/**
		 * The critical level used for error messages.
		 */
		critical,
	}

	/**
	 * The open log file.
	 */
	private File _logFile;

	/**
	 * Constructor.
	 *
	 * If a log file is not passed, log instead to stdout.
	 *
	 * Params:
	 *     logFile = The log file for logging.
	 */
	public this(string logFile = null) nothrow
	{
		try
		{
			if (logFile)
			{
				this._logFile = File(logFile, "a");
			}
			else
			{
				this._logFile = stdout;
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
	private string getTimestamp() nothrow
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
	private void log(string text, Level level) nothrow
	{
		string levelText;

		switch(level)
		{
			case Level.warning:
				levelText = "WARN";
				break;
		
			case Level.error:
				levelText = "ERROR";
				break;
		
			case Level.critical:
				levelText = "CRIT";
				break;
		
			default:
				levelText = "INFO";
				break;
		}

		try
		{
			this._logFile.writefln("%s %s: %s", this.getTimestamp(), levelText, text);
			this._logFile.flush();
		}
		catch (Exception ex)
		{
			assert(false, ex.msg);
		}
	}

	/**
	 * Write info text to the log.
	 *
	 * Params:
	 *     text = The format of the text to write to the log.
	 *     args = The arguments that the format defines (if any).
	 */
	public void info(A...)(string text, A args) nothrow
	{
		try
		{
			this.log(format(text, args), Level.information);
		}
		catch (Exception ex)
		{
			assert(false, ex.msg);
		}
	}

	/**
	 * Write warning text to the log.
	 *
	 * Params:
	 *     text = The format of the text to write to the log.
	 *     args = The arguments that the format defines (if any).
	 */
	public void warning(A...)(string text, A args) nothrow
	{
		try
		{
			this.log(format(text, args), Level.warning);
		}
		catch (Exception ex)
		{
			assert(false, ex.msg);
		}
	}

	/**
	 * Write error text to the log.
	 *
	 * Params:
	 *     text = The format of the text to write to the log.
	 *     args = The arguments that the format defines (if any).
	 */
	public void error(A...)(string text, A args) nothrow
	{
		try
		{
			this.log(format(text, args), Level.error);
		}
		catch (Exception ex)
		{
			assert(false, ex.msg);
		}
	}

	/**
	 * Write error text to the log.
	 *
	 * Params:
	 *     text = The format of the text to write to the log.
	 *     args = The arguments that the format defines (if any).
	 */
	public void critical(A...)(string text, A args) nothrow
	{
		try
		{
			this.log(format(text, args), Level.critical);
		}
		catch (Exception ex)
		{
			assert(false, ex.msg);
		}
	}

}
