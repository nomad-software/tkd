/**
 * Window module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.window.window;

/**
 * Private imports.
 */
import std.conv;
import std.string;
import tkd.element.element : CommandCallback;
import tkd.element.uielement;
import tkd.widget.common.color;
import tkd.image.image;
import tkd.interpreter;

/**
 * The Window class creates a new toplevel window.
 *
 * A window is similar to a frame except that it is created as a top-level 
 * widget. The primary purpose of a toplevel is to serve as a container for 
 * dialog boxes and other collections of widgets.
 *
 * Example:
 * ---
 * auto window = new Window("New window")
 * 	.setGeometry(640, 480, 10, 10)
 * 	.setDefaultIcon(new Png!("icon.png"))
 * 	.setMaxSize(1024, 768)
 * 	.setProtocolCommand(WindowProtocol.deleteWindow, delegate(CommandArgs args){ ... });
 * ---
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
 *     $(LINK2 ../element/uielement.html, tkd.element.uielement)
 */
class Window : UiElement
{
	/**
	 * The main window of the application.
	 */
	static private Window _mainWindow;

	/*
	 * Constructor.
	 *
	 * This constructor is mainly for internal use. When creating a window 
	 * using this constructor what you are really doing is creating a new 
	 * reference to the main application window.
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
	 *     parent = The window to act as a parent.
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
			// This tip was gathered from the following post, if it proves not 
			// to be cross-platform there are other tips in this post that 
			// could be used.
			// http://stackoverflow.com/questions/8929031/grabbing-a-new-window-in-tcl-tk
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
	 *     This window to aid method chaining.
	 */
	public auto setTitle(this T)(string title)
	{
		this._tk.eval("wm title %s {%s}", this.id, title);

		return cast(T) this;
	}

	/**
	 * Set the opacity of the window.
	 *
	 * Params:
	 *     opacity = A number between 0.0 and 1.0 specifying the transparency.
	 *
	 * Returns:
	 *     This window to aid method chaining.
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
	 *     This window to aid method chaining.
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
	 *     This window to aid method chaining.
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
		 *     This window to aid method chaining.
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
		 *     This window to aid method chaining.
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
		 *     This window to aid method chaining.
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
		 *     This window to aid method chaining.
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
	 *     This window to aid method chaining.
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
	 *     This window to aid method chaining.
	 */
	public auto iconify(this T)()
	{
		this._tk.eval("wm iconify %s", this.id);

		return cast(T) this;
	}

	/**
	 * Set the size and postition of the window.
	 *
	 * Params:
	 *     width = The width of the window.
	 *     height = The height of the window.
	 *     xPos = The horizontal position of the window.
	 *     yPos = The vertical position of the window.
	 *
	 * Returns:
	 *     This window to aid method chaining.
	 */
	public auto setGeometry(this T)(int width, int height, int xPos, int yPos)
	{
		this._tk.eval("wm geometry %s %sx%s+%s+%s", this.id, width, height, xPos, yPos);
		
		return cast(T) this;
	}

	/**
	 * Set the default icon for this window. This is applied to all future 
	 * child windows as well.
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
	 *     This window to aid method chaining.
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
	 *     This window to aid method chaining.
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
	 *     This window to aid method chaining.
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
	 *     This window to aid method chaining.
	 */
	public auto setMinSize(this T)(int width, int height)
	{
		this._tk.eval("wm minsize %s %s %s", this.id, width, height);

		return cast(T) this;
	}

	/**
	 * This command is used to manage window manager protocols such as 
	 * WM_DELETE_WINDOW. Protocol is the name of an atom corresponding to a 
	 * window manager protocol, such as WM_DELETE_WINDOW or WM_SAVE_YOURSELF or 
	 * WM_TAKE_FOCUS.
	 *
	 * Params:
	 *     protocol = The protocol to respond to.
	 *     callback = The callback to invoke when the protocol is encountered.
	 *
	 * Returns:
	 *     This window to aid method chaining.
	 *
	 * Callback_Arguments:
	 *     These are the fields within the callback's $(LINK2 
	 *     ../element/element.html#CommandArgs, CommandArgs) parameter which 
	 *     are populated by this method when the callback is executed. 
	 *     $(P
	 *         $(PARAM_TABLE
	 *             $(PARAM_ROW CommandArgs.element, The window that executed the callback.)
	 *             $(PARAM_ROW CommandArgs.uniqueData, The protocol that was responded to.)
	 *             $(PARAM_ROW CommandArgs.callback, The callback which was executed.)
	 *         )
	 *     )
	 *
	 * See_Also:
	 *     $(LINK2 ../element/element.html#CommandCallback, tkd.element.element.CommandCallback) $(BR)
	 *     $(LINK2 ../tkdapplication.html#WindowProtocol, tkd.tkdapplication.WindowProtocol) $(BR)
	 */
	public auto setProtocolCommand(this T)(string protocol, CommandCallback callback)
	{
		string command = this.createCommand(callback, protocol);
		this._tk.eval("wm protocol %s %s %s", this.id, protocol, command);

		return cast(T) this;
	}

	/**
	 * Remove a previously set protocol command.
	 *
	 * Params:
	 *     protocol = The protocol which will have the command removed.
	 *
	 * Returns:
	 *     This window to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../tkdapplication.html#WindowProtocol, tkd.tkdapplication.WindowProtocol)
	 */
	public auto removeProtocolCommand(this T)(string protocol)
	{
		this._tk.deleteCommand(this.getCommandName(protocol));
		this._tk.eval("wm protocol %s %s {}", this.id, protocol);

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
	 *     This window to aid method chaining.
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
	 *     This window to aid method chaining.
	 */
	public auto withdraw(this T)()
	{
		this._tk.eval("wm withdraw %s", this.id);

		return cast(T) this;
	}

	/**
	 * Wait until this window has been destroyed.
	 *
	 * Returns:
	 *     This window to aid method chaining.
	 */
	public auto wait(this T)()
	{
		this._tk.eval("tkwait window %s", this.id);

		return cast(T) this;
	}

	/**
	 * Set a callback to be executed after a delay and after processing all 
	 * other events. The callback is executed only once and discarded. This is 
	 * useful for refreshing the GUI at regular intervals when monitoring 
	 * something or to schedule a future action.
	 *
	 * Params:
	 *     callback = The delegate function to be executed on idle.
	 *     msDelay  = The delay in millisecond before executing the given callback.
	 *
	 * Returns:
	 *     This window to aid method chaining.
	 *
	 * Example:
	 * ----
	 * InputStream stream = ...; // A data provider.
	 *
	 * this.mainWindow.setIdleCommand(delegate(CommandArgs args){
	 *
	 * 	// Use data.
	 * 	if (!stream.empty && stream.finished)
	 * 	{
	 * 		performStep(stream.next);
	 * 	}
	 *
	 * 	// Re-arm this callback and wait for more data.
	 * 	this.mainWindow.setIdleCommand(args.callback, 10_000);
	 *
	 * }, 10_000);
	 *
	 * ----
	 * Caveats:
	 *     The callback executed by this method is not asynchronous and could 
	 *     halt the GUI from processing events if it takes a long time to 
	 *     finish.
	 */
	public auto setIdleCommand(this T)(CommandCallback callback, int msDelay = 1)
	{
		assert(msDelay > 0, "The delay in milliseconds should be greater than zero.");

		string command = this.createCommand(callback, "idle");
		this._tk.eval("after idle [list after %s %s]", msDelay.to!(string), command);

		return cast(T) this;
	}

	/**
	 * Get the main window of the application. This is just a convenience 
	 * method and shouldn't really be used. Instead use the $(LINK2 
	 * ../tkdapplication.html#TkdApplication.mainWindow, mainWindow) property 
	 * of the $(LINK2 ../tkdapplication.html, TkdApplication) class.
	 *
	 * Returns:
	 *     A reference to the main window of the application.
	 *
	 * See_Also:
	 *     $(LINK2 ../tkdapplication.html, tkd.tkdapplication)
	 */
	static public Window getMainWindow()
	{
		if (this._mainWindow is null)
		{
			this._mainWindow = new Window();
		}

		return this._mainWindow;
	}
    
    mixin Color;
}

/**
 * Window manager protocols.
 *
 * Caveats:
 *     This list is incomplete.
 */
enum WindowProtocol : string
{
	deleteWindow = "WM_DELETE_WINDOW", /// Issued when the window is to be deleted.
	saveYourself = "WM_SAVE_YOURSELF", /// Issued when the window is required to save itself.
	takeFocus    = "WM_TAKE_FOCUS",    /// Issued then the window is focused.
}
