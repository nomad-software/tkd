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
 * Base class of all Tkd gui applications.
 *
 * Example:
 * ---
 * class Application : TkdApplication
 * {
 * 	private void button_quit_command(Widget widget, CommandArgs args)
 * 	{
 * 		this.exit();
 * 	}
 * 
 * 	override protected void initInterface()
 * 	{
 * 		this.frame.root   = new Frame();
 * 		this.button.exit  = new Button(this.frame.root, "Exit");
 * 		this.button.exit.setCommand(&this.button_quit_command);
 * 
 * 		this.frame.root.pack();
 * 		this.button.exit.pack();
 * 	}
 * }
 *
 * void main(string[] args)
 * {
 * 	auto app = new Application();
 * 	app.run();
 * }
 * ---
 *
 */
abstract class TkdApplication
{
	/**
	 * The Tk interpreter.
	 */
	private Tk _tk;

	/**
	 * Automatic storage for buttons.
	 */
	protected Store!(Button) button;

	/**
	 * Automatic storage for checkbuttons.
	 */
	protected Store!(CheckButton) checkbutton;

	/**
	 * Automatic storage for frames.
	 */
	protected Store!(Frame) frame;

	/**
	 * Automatic storage for images.
	 */
	protected Store!(Image) image;

	/**
	 * constructor.
	 *
	 * Throws:
	 *     Exception if Tcl/Tk interpreter cannot be initialised.
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
