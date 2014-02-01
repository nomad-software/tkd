/**
 * TkApplication module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.tkdapplication;

/**
 * Private imports.
 */
import tkd.interpreter;
import tkd.store;

/**
 * Public imports.
 */
public import tkd.element;
public import tkd.widget;
public import tkd.image;

/**
 * Base class of all Tk gui applications.
 */
abstract class TkdApplication
{
	/**
	 * The Tk interpreter.
	 */
	private Tk _tk;

	/**
	 * Storage for elements.
	 */
	protected Store!(Button) button;
	protected Store!(Frame) frame;

	/**
	 * constructor.
	 *
	 * Throws:
	 *     Exception if Tcl/Tk cannot be initialised.
	 */
	public this()
	{
		this._tk = Tk.getInstance();
		this.initInterface();
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
	public void exit()
	{
		this._tk.eval("destroy .");
	}

	/**
	 * All element creation and layout should take place within this method.
	 * This method is called by the constructor to create the initial GUI.
	 */
	abstract protected void initInterface();
}
