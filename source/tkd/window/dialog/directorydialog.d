/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.window.dialog.directorydialog;

/**
 * Imports.
 */
import std.regex;
import tkd.window.dialog.dialog;
import tkd.window.window;

/**
 * Pops up a dialog box for the user to select a directory.
 *
 * Example:
 * ---
 * auto dialog = new DirectoryDialog("Select a directory")
 * .setInitialDirectory("~")
 * .setDirectoryMustExist(true)
 * .show();
 *
 * string directory = dialog.getResult();
 * ---
 *
 * Result:
 *     The full path of the directory selected.
 *
 * See_Also:
 *     $(LINK2 ./dialog.html, tkd.dialog.dialog) $(BR)
 */
class DirectoryDialog : Dialog
{
	/**
	 * The initial directory to start in the dialog.
	 */
	private string _initialDirectory;

	/**
	 * Whether or not the choosen directory must exist in the file system.
	 */
	private bool _directoryMustExist;

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     parent = The parent window of the dialog.
	 *     title = The title of the dialog.
	 */
	this(Window parent, string title = "Directory")
	{
		super(parent, title);
	}

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     title = The title of the dialog.
	 */
	this(string title = "Directory")
	{
		this(null, title);
	}

	/**
	 * Set the initial directory in the dialog.
	 *
	 * Params:
	 *     directory = The initial directory.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto setInitialDirectory(this T)(string directory)
	{
		this._initialDirectory = directory;

		return cast(T) this;
	}

	/**
	 * Set if the directory must exist.
	 *
	 * Params:
	 *     mustExist = Determins if the directory must exist.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto setDirectoryMustExist(this T)(bool mustExist)
	{
		this._directoryMustExist = mustExist;

		return cast(T) this;
	}

	/**
	 * Show the dialog.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto show(this T)()
	{
		if (this._parent)
		{
			this._tk.eval("tk_chooseDirectory -parent %s -title {%s} -initialdir {%s} -mustexist %s", this._parent.id, this._title, this._initialDirectory, this._directoryMustExist);
		}
		else
		{
			this._tk.eval("tk_chooseDirectory -title {%s} -initialdir {%s} -mustexist %s", this._title, this._initialDirectory, this._directoryMustExist);
		}

		string result = this._tk.getResult!(string);

		if (match(result, r"^bad window path name").empty)
		{
			this._results = [result];
		}

		return cast(T) this;
	}
}
