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
import std.conv;
import std.string;
import tcltk.tk;
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
	 * It's important to understand that the window will be drawn immediately 
	 * by default. This means that the window will display before any other 
	 * actions take place, including drawing or managing other widgets. This is 
	 * so other methods (such as platformId) that rely on the window being 
	 * drawn don't fail if immediately used afterwards.
	 * 
	 * This behaviour can be overridden by passing false as the waitForWindow 
	 * argument which is useful if you want the entire UI belonging to the new 
	 * window to be drawn before actaully showing it.
	 *
	 * The parent window is responsible for the life of this window. If the 
	 * parent window is destroyed, this one will be too.
	 *
	 * Params:
	 *     window = The window to act as a parent.
	 *     title = The title of the window.
	 *     waitForWindow = Whether to wait for the window to be drawn before continuing.
	 */
	public this(Window parent, string title, bool waitForWindow = true)
	{
		super(parent);
		this._elementId = "window";
		this._tk.eval("toplevel %s", this.id);

		if (waitForWindow)
		{
			this._tk.eval("tkwait visibility %s", this.id);
		}

		this.setTitle(title);
	}

	/**
	 * Constructor.
	 *
	 * It's important to understand that the window will be drawn immediately 
	 * by default. This means that the window will display before any other 
	 * actions take place, including drawing or managing other widgets. This is 
	 * so other methods (such as platformId) that rely on the window being 
	 * drawn don't fail if immediately used afterwards.
	 * 
	 * This behaviour can be overridden by passing false as the waitForWindow 
	 * argument which is useful if you want the entire UI belonging to the new 
	 * window to be drawn before actaully showing it.
	 *
	 * If no parent is specified the new window with be a child of the main 
	 * window.
	 *
	 * Params:
	 *     title = The title of the window.
	 *     waitForWindow = Whether to wait for the window to be drawn before continuing.
	 */
	public this(string title, bool waitForWindow = true)
	{
		this(new Window(), title, waitForWindow);
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
		 * Handle changing the window to a tool window. Windows only.
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
		 * Set the modified state of the window. Mac OSX only.
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
		 * dock icon. Mac OSX only.
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
	 * Restore the window's state to before it was minimised or withdrawn.
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
	 * Returns:
	 *     The platform window id.
	 */
	public @property size_t platformId()
	{
		this._tk.eval("wm frame %s", this.id);

		return this._tk.getResult!(string).chompPrefix("0x").to!(size_t)(16);
	}

	/**
	 * Set the size and postition of the window.
	 *
	 * Params:
	 *     width = The width of the window.
	 *     height = The height of the window.
	 *     xPosition = The horizontal position of the window.
	 *     yPosition = The vertical position of the window.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setGeometry(this T)(int width, int height, int xPosition, int yPosition)
	{
		this._tk.eval("wm geometry %s %sx%s+%s+%s", this.id, width, height, xPosition, yPosition);
		
		return cast(T) this;
	}

	/**
	 * Set the default icon for this window while this is also applied to all 
	 * future created windows as well.
	 *
	 * The data in the images is taken as a snapshot at the time of invocation. 
	 * If the images are later changed, this is not reflected to the titlebar 
	 * icons. Multiple images are accepted to allow different images sizes 
	 * (e.g., 16x16 and 32x32) to be provided. The window manager may scale 
	 * provided icons to an appropriate size.
	 *
	 * Params:
	 *     images = A variadic list of images.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setDefaultIcon(this T)(Image[] images ...)
	{
		string defaultImages;

		foreach (image; images)
		{
			defaultImages ~= format("%s ", image.id);
		}

		this._tk.eval("wm iconphoto %s -default %s", this.id, defaultImages);
		
		return cast(T) this;
	}

	/**
	 * Set the icon for this window, this overrides the default icon.
	 *
	 * Params:
	 *     images = A variadic list of images.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setIcon(this T)(Image[] images ...)
	{
		string defaultImages;

		foreach (image; images)
		{
			defaultImages ~= format("%s ", image.id);
		}

		this._tk.eval("wm iconphoto %s %s", this.id, defaultImages);
		
		return cast(T) this;
	}

	/**
	 * Set the maximum size of the window.
	 *
	 * Params:
	 *     width = The maximum width of the window.
	 *     height = The maximum height of the window.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setMaxSize(this T)(int width, int height)
	{
		this._tk.eval("wm maxsize %s %s %s", this.id, width, height);

		return cast(T) this;
	}

	/**
	 * Set the minimum size of the window.
	 *
	 * Params:
	 *     width = The minimum width of the window.
	 *     height = The minimum height of the window.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setMinSize(this T)(int width, int height)
	{
		this._tk.eval("wm minsize %s %s %s", this.id, width, height);

		return cast(T) this;
	}

	/**
	 * This command is used to manage window manager protocols such as 
	 * WM_DELETE_WINDOW. Name is the name of an atom corresponding to a window 
	 * manager protocol, such as WM_DELETE_WINDOW or WM_SAVE_YOURSELF or 
	 * WM_TAKE_FOCUS.
	 *
	 * Params:
	 *     protocol = The protocol to add the command to.
	 *     callback = The callback to invoke when the protocol is encountered.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./tkdapplication.html#WindowProtocol, tkd.tkdapplication.WindowProtocol)
	 */
	public auto addProtocolCommand(this T)(string protocol, ProtocolCommandCallback callback)
	{
		this.removeProtocolCommand(protocol);

		Tcl_CmdProc commandCallbackHandler = function(ClientData data, Tcl_Interp* tclInterpreter, int argc, const(char)** argv)
		{
			ProtocolCommandArgs args = *cast(ProtocolCommandArgs*)data;

			try
			{
				args.callback(args.window, args);
			}
			catch (Throwable ex)
			{
				string error = "Error occurred in protocol command callback. ";
				error ~= ex.msg ~ "\n";
				error ~= "Window: " ~ args.window.id ~ "\n";

				Tcl_SetResult(tclInterpreter, error.toStringz, TCL_STATIC);
				return TCL_ERROR;
			}

			return TCL_OK;
		};

		Tcl_CmdDeleteProc deleteCallbackHandler = function(ClientData data)
		{
			free(data);
		};

		ProtocolCommandArgs* args = cast(ProtocolCommandArgs*)malloc(ProtocolCommandArgs.sizeof);

		(*args).window   = this;
		(*args).callback = callback;

		string command  = format("command-%s", this.generateHash("command%s%s", this.id, protocol));
		string tkScript = format("wm protocol %s %s %s", this.id, protocol, command);

		this._tk.createCommand(command, commandCallbackHandler, args, deleteCallbackHandler);
		this._tk.eval(tkScript);

		return cast(T) this;
	}

	/**
	 * Remove a previously set protocol command.
	 *
	 * Params:
	 *     protocol = The protocol which will have the command removed.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./tkdapplication.html#WindowProtocol, tkd.tkdapplication.WindowProtocol)
	 */
	public auto removeProtocolCommand(this T)(string protocol)
	{
		string command  = format("command-%s", this.generateHash("command%s%s", this.id, protocol));
		string tkScript = format("wm protocol %s %s {}", this.id, protocol);

		this._tk.deleteCommand(command);
		this._tk.eval(tkScript);

		return cast(T) this;
	}

	/**
	 * Set if the width and height can be resized.
	 *
	 * Params:
	 *     resizeWidth = True to allow width resizing, false to disable.
	 *     resizeHeight = True to allow height resizing, false to disable.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setResizable(this T)(bool resizeWidth, bool resizeHeight)
	{
		this._tk.eval("wm resizable %s %s %s", this.id, resizeWidth, resizeHeight);

		return cast(T) this;
	}

	/**
	 * Determine if this window is above another.
	 *
	 * Params:
	 *     other = The other window to check this one is above.
	 *
	 * Returns:
	 *     true if this window is above other, false if not.
	 */
	public bool isAbove(Window other)
	{
		this._tk.eval("wm stackorder %s isabove %s", this.id, other.id);

		return this._tk.getResult!(int) == 1;
	}

	/**
	 * Determine if this window is below another.
	 *
	 * Params:
	 *     other = The other window to check this one is below.
	 *
	 * Returns:
	 *     true if this window is below other, false if not.
	 */
	public bool isBelow(Window other)
	{
		this._tk.eval("wm stackorder %s isbelow %s", this.id, other.id);

		return this._tk.getResult!(int) == 1;
	}

	/**
	 * Withdraw a window from being displayed/mapped by the window manager.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto withdraw(this T)()
	{
		this._tk.eval("wm withdraw %s", this.id);

		return cast(T) this;
	}
}

/**
 * Alias representing a protocol command callback.
 */
alias void delegate(Window window, ProtocolCommandArgs args) ProtocolCommandCallback;

/**
 * The ProtocolCommandArgs struct passed to the ProtocolCommandCallback on invocation.
 */
struct ProtocolCommandArgs
{
	/**
	 * The window that issued the command.
	 */
	Window window;

	/**
	 * The callback which was invoked as the command.
	 */
	ProtocolCommandCallback callback;
}

/**
 * Window manager protocols.
 *
 * Bugs:
 *     This list is incomplete.
 */
enum WindowProtocol : string
{
	deleteWindow = "WM_DELETE_WINDOW", /// Issued when the window is to be deleted.
	saveYourself = "WM_SAVE_YOURSELF", /// Issued when the window is required to save itself.
	takeFocus    = "WM_TAKE_FOCUS",    /// Issued then the window is focused.
}
