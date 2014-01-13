/**
 * TkApplication module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.tkapplication;

/**
 * Private imports.
 */
import std.algorithm;
import std.array;
import std.conv;
import std.digest.crc;
import tkd.tk;

/**
 * Public imports.
 */
public import tkd.widget.button;
public import tkd.widget.frame;
public import tkd.widget.widget;

/**
 * Base class of all Tk gui applications.
 */
abstract class TkApplication
{
	/**
	 * The Tk interpreter.
	 */
	private Tk _tk;

	/**
	 * Storage for all the widgets created to allow access to all.
	 */
	private Widget[string] _widgets;

	/**
	 * constructor.
	 *
	 * Throws:
	 *     Exception if Tcl/Tk cannot be initialised.
	 */
	public this()
	{
		this._tk = Tk.getInstance();
		this.initWidgets();
	}

	/**
	 * Run the application.
	 */
	public void run()
	{
		this._tk.run();
	}

	/**
	 * Exit the application.
	 */
	public void exit(int exitCode = 0)
	{
		this._tk.eval("destroy .");
	}

	/**
	 * Handle storing widgets as properties of this class. If a widget property 
	 * doesn't exist when assigning a widget to it, this method is called. This 
	 * 'magic' is done is to allow widgets to be accessed across methods once 
	 * created in the initWidgets method.
	 *
	 * Params:
	 *     name = The property name of the accessed widget.
	 *     widget = The widget object assigned to the property name.
	 *     file = The file name where this action occurred for error reporting.
	 *     line = The line number where this action occurred for error reporting.
	 *
	 * See_Also:
	 *     http://dlang.org/operatoroverloading.html#Dispatch
	 */
	public void opDispatch(string name)(Widget widget, string file = __FILE__, size_t line = __LINE__)
	{
		if (name in this._widgets)
		{
			throw new Exception("Widget already exists.", file, line);
		}

		this._widgets[name] = widget;
	}

	/**
	 * Handle retrieving widgets as properties of this class. If a widget 
	 * property is accessed but doesn't exist, this method is called.
	 *
	 * Params:
	 *     name = The property name of the accessed widget.
	 *     file = The file name where this action occurred for error reporting.
	 *     line = The line number where this action occurred for error reporting.
	 *
	 * Returns:
	 *     The widget matching the property name.
	 *
	 * See_Also:
	 *     http://dlang.org/operatoroverloading.html#Dispatch
	 */
	public Widget opDispatch(string name)(string file = __FILE__, size_t line = __LINE__)
	{
		if (name in this._widgets)
		{
			return this._widgets[name];
		}
		throw new Exception("Widget not found.", file, line);
	}

	/**
	 * All widget creation and layout should take place within this method.
	 * This method is call by the constructor to create the initial gui.
	 */
	abstract protected void initWidgets();
}
