/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.dialog.savefiledialog;

/**
 * Imports.
 */
import std.array;
import std.regex;
import tkd.dialog.filedialog;

/**
 * Pops up a dialog box for the user to save a file.
 *
 * Example:
 * ---
 * auto dialog = new SaveFileDialog("Save a file")
 * 	.setConfirmOverwrite(true)
 * 	.setDefaultExtension(".txt")
 * 	.addFileType("{{All files} {*}}")
 * 	.addFileType("{{Text files} {.txt}}")
 * 	.setInitialDirectory("~")
 * 	.setInitialFile("file.txt")
 * 	.show();
 *
 * string fileToWrite = dialog.getResult();
 * ---
 *
 * Result:
 *     The full path of the file selected.
 *
 * See_Also:
 *     $(LINK2 ./filedialog.html, tkd.dialog.filedialog) $(BR)
 */
class SaveFileDialog : FileDialog
{
	/*
	 * Configures how the Save dialog reacts when the selected file already 
	 * exists, and saving would overwrite it.
	 */
	private bool _confirmOverwrite = true;

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     parent = The parent window of the dialog.
	 *     title = The title of the dialog.
	 */
	this(Window parent, string title = "Save")
	{
		super(parent, title);
	}

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     title = The title of the dialog.
	 */
	this(string title = "Save")
	{
		this(null, title);
	}

	/**
	 * Configures how the Save dialog reacts when the selected file already 
	 * exists, and saving would overwrite it. A true value requests a 
	 * confirmation dialog be presented to the user. A false value requests 
	 * that the overwrite take place without confirmation. Default value is 
	 * true.
	 *
	 * Params:
	 *     confirm = Show a dialog to confirm overwriting any file.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto setConfirmOverwrite(this T)(bool confirm)
	{
		this._confirmOverwrite = confirm;

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
			this._tk.eval("tk_getSaveFile -parent %s -title {%s} -confirmoverwrite %s -defaultextension {%s} -filetypes {%s} -initialdir {%s} -initialfile {%s} -typevariable %s", this._parent.id, this._title, this._confirmOverwrite, this._defaultExtension, this._fileTypes.join(" "), this._initialDirectory, this._initialFile, this._typeVariable);
		}
		else
		{
			this._tk.eval("tk_getSaveFile -title {%s} -confirmoverwrite %s -defaultextension {%s} -filetypes {%s} -initialdir {%s} -initialfile {%s} -typevariable %s", this._title, this._confirmOverwrite, this._defaultExtension, this._fileTypes.join(" "), this._initialDirectory, this._initialFile, this._typeVariable);
		}

		string result = this._tk.getResult!(string);

		if (match(result, r"^bad window path name").empty)
		{
			this._results = [result];
		}

		return cast(T) this;
	}
}
