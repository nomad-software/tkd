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
		this._tk = Tk.getInstance();

		version (linux)
		{
			// The default linux theme is a bit ropey so use the Clam theme as 
			// the new default.
			this.setTheme(Theme.clam);
		}

		this._mainWindow = new Window();
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
	 * Exit the application.
	 */
	public void exit()
	{
		this.mainWindow.destroy();
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
	 */
	private this()
	{
		super();
		this.overrideGeneratedId(".");
	}

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

	/**
	 * Set the opacity of the window.
	 *
	 * Params:
	 *     opacity = A number between 0.0 and 1.0 specifying the transparency.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setOpacity(this T)(double opacity)
	{
		assert(opacity >= 0 && opacity <= 1, "Opacity must be between 0.0 and 1.0.");

		this._tk.eval("wm attributes %s -alpha %s", this.id, opacity);

		return cast(T) this;
	}

	/**
	 * Handle setting the window to fullscreen.
	 *
	 * Params:
	 *     fullscreen = A boolean specifying if the window should be fullscreen or not.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setFullscreen(this T)(bool fullscreen)
	{
		this._tk.eval("wm attributes %s -fullscreen %s", this.id, fullscreen);

		return cast(T) this;
	}

	/**
	 * Handle setting the window to be the top-most. This makes the window not 
	 * able to be lowered behind any others.
	 *
	 * Params:
	 *     topmost = A boolean specifying if the window should be top-most or not.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setTopmost(this T)(bool topmost)
	{
		this._tk.eval("wm attributes %s -topmost %s", this.id, topmost);

		return cast(T) this;
	}

	version (Windows)
	{
		/**
		 * Handle disabling the window. Windows only.
		 *
		 * Params:
		 *     disabled = A boolean specifying if the window should be disabled or not.
		 *
		 * Returns:
		 *     This widget to aid method chaining.
		 */
		public auto setDisabled(this T)(bool disabled)
		{
			this._tk.eval("wm attributes %s -disabled %s", this.id, disabled);

			return cast(T) this;
		}

		/**
		 * Handle changing the window to a tool window.
		 *
		 * Params:
		 *     toolWindow = A boolean specifying if the window should be a tool window or not.
		 *
		 * Returns:
		 *     This widget to aid method chaining.
		 */
		public auto setToolWindow(this T)(bool toolWindow)
		{
			this._tk.eval("wm attributes %s -toolwindow %s", this.id, toolWindow);

			return cast(T) this;
		}
	}

	version (OSX)
	{
		/**
		 * Set the modified state of the window.
		 *
		 * Params:
		 *     modified = A boolean specifying if the window should show it's been modified or not.
		 *
		 * Returns:
		 *     This widget to aid method chaining.
		 */
		public auto setModified(this T)(bool modified)
		{
			this._tk.eval("wm attributes %s -modified %s", this.id, modified);

			return cast(T) this;
		}

		/**
		 * Set the notify state of the window. On Mac OS it usually bounces the 
		 * dock icon.
		 *
		 * Params:
		 *     modified = A boolean specifying if the window should show a notification or not.
		 *
		 * Returns:
		 *     This widget to aid method chaining.
		 */
		public auto setNotify(this T)(bool modified)
		{
			this._tk.eval("wm attributes %s -notify %s", this.id, modified);

			return cast(T) this;
		}
	}

	/**
	 * Restore the window's state to before it was minimised.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto deiconify(this T)()
	{
		this._tk.eval("wm deiconify %s", this.id);

		return cast(T) this;
	}

	/**
	 * Minimise the window.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto iconify(this T)()
	{
		this._tk.eval("wm iconify %s", this.id);

		return cast(T) this;
	}

	/**
	 * Get the platform specific window id.
	 *
	 * Caveats:
	 *     This is only available after the main window's interface has been 
	 *     initialised and once this window has been fully created by the 
	 *     operating system.
	 *
	 * Returns:
	 *     The platform window id.
	 */
	public @property string platformId()
	{
		this._tk.eval("wm frame %s", this.id);

		return this._tk.getResult!(string);
	}

}
