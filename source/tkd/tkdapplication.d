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
import tkd.theme;

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
 * As shown in the above example, the TkdApplication class supports automatic 
 * declaration for all widget types so they don't have to be declared 
 * beforehand. e.g. you can refer to all buttons through the magic property 
 * `this.button`, all frames through the magic property `this.frame` etc.
 */
abstract class TkdApplication
{
	/**
	 * The Tk interpreter.
	 */
	private Tk _tk;

	/**
	 * constructor.
	 *
	 * Throws:
	 *     Exception if Tcl/Tk interpreter cannot be initialised.
	 */
	public this()
	{
		this._tk = Tk.getInstance();

		version (linux)
		{
			// The default linux theme is a bit ropey so use the Clam theme as 
			// the new default.
			this.setTheme(Theme.clam);
		}

		this.initInterface();
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

/**
 * The Window class creates a new toplevel window.
 *
 * A window is similar to a frame except that it is created as a top-level 
 * widget. The primary purpose of a toplevel is to serve as a container for 
 * dialog boxes and other collections of widgets.
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-F10&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./element/uielement.html, tkd.element.uielement)
 */
class Window : UiElement
{
	/**
	 * Constructor.
	 *
	 * Params:
	 *     title = The title of the window.
	 */
	public this(string title)
	{
		this._elementId = "window";
		this._tk.eval("toplevel %s", this.id);

		this.setTitle(title);
	}

	/**
	 * Set the title of the window.
	 *
	 * Params:
	 *     title = The title of the window.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setTitle(this T)(string title)
	{
		this._tk.eval("wm title %s \"%s\"", this.id, title);

		return cast(T) this;
	}
}
