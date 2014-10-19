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
import std.file : chdir, thisExePath;
import std.path : dirName;
import std.regex : match;
import std.string;
import tkd.interpreter;

/**
 * Public imports.
 */
public import tkd.element;
public import tkd.image;
public import tkd.widget;
public import tkd.window;

/**
 * Base class of all Tkd gui applications.
 *
 * Example:
 * ---
 * import tkd.tkdapplication;
 *
 * class Application : TkdApplication
 * {
 * 	private void exitCommand(CommandArgs args)
 * 	{
 * 		this.exit();
 * 	}
 * 
 * 	override protected void initInterface()
 * 	{
 * 		auto frame = new Frame(2, ReliefStyle.groove)
 * 			.pack(10);
 * 
 * 		auto label = new Label(frame, "Hello World!")
 * 			.pack(10);
 * 
 * 		auto exitButton = new Button(frame, "Exit")
 * 			.setCommand(&this.exitCommand)
 * 			.pack(10);
 * 	}
 * }
 * 
 * void main(string[] args)
 * {
 * 	auto app = new Application();
 * 	app.run();
 * }
 * ---
 */
abstract class TkdApplication
{
	/**
	 * The Tk interpreter.
	 */
	private Tk _tk;

	/**
	 * The main window of the application.
	 */
	private Window _mainWindow;

	/**
	 * constructor.
	 *
	 * Throws:
	 *     Exception if Tcl/Tk interpreter cannot be initialised.
	 */
	public this()
	{
		// On Windows the Tcl/Tk library folder might be included in the 
		// executable's directory to make the entire application self-contained 
		// (using a local library and Tcl/Tk DLL's). So always set the current 
		// working directory to that of the executable's. Tcl/Tk should then 
		// always find it if it's there.
		version (Windows)
		{
			thisExePath().dirName().chdir();
		}

		this._tk = Tk.getInstance();

		// Fix to remove hard-coded background colors from widgets.
		version (Windows)
		{
			this._tk.eval("ttk::style configure TEntry -fieldbackground {SystemWindow}");
			this._tk.eval("ttk::style configure TSpinbox -fieldbackground {SystemWindow}");
			this._tk.eval("ttk::style configure Treeview -fieldbackground {SystemWindow}");
		}

		this._mainWindow = Window.getMainWindow();
		this.initInterface();
	}

	/**
	 * Get the main window of the application.
	 *
	 * Returns:
	 *     The main window.
	 */
	public @property Window mainWindow()
	{
		return this._mainWindow;
	}

	/**
	 * Set the overall theme of the user interface.
	 *
	 * Params:
	 *     theme = The theme to use.
	 *
	 * See_also:
	 *     $(LINK2 ./theme.html, tkd.theme) $(BR)
	 */
	public void setTheme(string theme)
	{
		this._tk.eval("ttk::style theme use %s", theme);
	}

	/**
	 * Run the application.
	 */
	public void run()
	{
		this._tk.run();
	}

	/**
	 * This method is used to bring the application 'up to date' by entering 
	 * the event loop repeatedly until all pending events (including idle 
	 * callbacks) have been processed.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto update(this T)()
	{
		this._tk.eval("update");

		return cast(T) this;
	}

	/**
	 * Exit the application.
	 */
	public void exit()
	{
		this.mainWindow.destroy();
	}

	/**
	 * Associates the virtual event with the binding, so that the virtual event 
	 * will trigger whenever the binding occurs. Virtual events may be any 
	 * string value and binding may have any of the values allowed for the 
	 * binding argument of the $(LINK2 ./element/uielement.html#UiElement.bind, 
	 * bind) method. If the virtual event is already defined, the new binding 
	 * adds to the existing bindings for the event.
	 *
	 * Params:
	 *     virtualEvent = The virtual event to create.
	 *     binding = The binding that triggers this event.
	 *
	 * See_Also:
	 *     $(LINK2 ./element/uielement.html, tkd.element.uielement)
	 */
	public void addVirtualEvent(this T)(string virtualEvent, string binding)
	{
		assert(!std.regex.match(virtualEvent, r"^<<.*?>>$").empty, "Virtual event must take the form of <<event>>");

		this._tk.eval("event add %s %s", virtualEvent, binding);
	}

	/**
	 * Deletes each of the bindings from those associated with the virtual 
	 * event. Virtual events may be any string value and binding may have any 
	 * of the values allowed for the binding argument of the $(LINK2 
	 * ./uielement.html#UiElement.bind, bind) method. Any bindings not 
	 * currently associated with virtual events are ignored. If no binding 
	 * argument is provided, all bindings are removed for the virtual event, so 
	 * that the virtual event will not trigger anymore.
	 *
	 * Params:
	 *     virtualEvent = The virtual event to create.
	 *     binding = The binding that triggers this event.
	 *
	 * See_Also:
	 *     $(LINK2 ./element/uielement.html, tkd.element.uielement)
	 */
	public void deleteVirtualEvent(this T)(string virtualEvent, string binding = null)
	{
		assert(!std.regex.match(virtualEvent, r"^<<.*?>>$").empty, "Virtual event must take the form of <<event>>");

		this._tk.eval("event delete %s %s", virtualEvent, binding);
	}

	/**
	 * All element creation and layout should take place within this method.
	 * This method is called by the constructor to create the initial GUI.
	 */
	abstract protected void initInterface();
}
