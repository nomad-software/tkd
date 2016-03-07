/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.window.dialog.filedialog;

/**
 * Imports.
 */
import std.regex;
import std.string;
import tkd.window.dialog.dialog;
import tkd.window.window;

/**
 * Pops up a dialog box for the user to select a color.
 *
 * See_Also:
 *     $(LINK2 ./dialog.html, tkd.dialog.dialog) $(BR)
 */
abstract class FileDialog : Dialog
{
	/*
	 * The default extension for the file.
	 */
	protected string _defaultExtension;

	/*
	 * A list of allowed file types.
	 */
	protected string[] _fileTypes;

	/*
	 * The initial directory to start in the dialog.
	 */
	protected string _initialDirectory;

	/*
	 * The initial file to use in the dialog.
	 */
	protected string _initialFile;

	/*
	 * A variable to hold the state of the selected file type.
	 */
	protected string _typeVariable;

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     parent = The parent window of the dialog.
	 *     title = The title of the dialog.
	 */
	this(Window parent, string title)
	{
		this._typeVariable = format("variable-%s", this.generateHash("%s%s", this._elementId, this.id));
		super(parent, title);

		// Fix to hide hidden files by default on Posix systems. This also
		// enables a checkbutton to show them again within the dialog.
		version (Posix)
		{
			this._tk.eval("catch {tk_getOpenFile foo bar}");
			this._tk.eval("set ::tk::dialog::file::showHiddenVar 0");
			this._tk.eval("set ::tk::dialog::file::showHiddenBtn 1");
		}
	}

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     title = The title of the dialog.
	 */
	this(string title)
	{
		this(null, title);
	}

	/**
	 * Set the default extension.
	 *
	 * Params:
	 *     extension = The default extension.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto setDefaultExtension(this T)(string extension)
	{
		this._defaultExtension = extension;

		return cast(T) this;
	}

	/**
	 * Add an allowed file type. If a filetype combobox exists in the file 
	 * dialog on the particular platform, this adds entries to it. When the 
	 * user choose a filetype in the combobox, only the files of that type are 
	 * listed. If no types are added or if the filetypes combobox is not 
	 * supported by the particular platform then all files are listed 
	 * regardless of their types.
	 *
	 * Filetypes must be added in the correct format, i.e. all fields are 
	 * enclosed within curly braces and separated by a space. Extensions must 
	 * contain a dot. The format is described below in which the carats 
	 * indicate essential required space.
	 * ----
	 * {{Description} {.ext1 .ext2 .ext3 ...}}
	 *               ^      ^     ^     ^
	 * ----
	 *
	 * Params:
	 *     fileType = The file type to add.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto addFileType(this T)(string fileType)
	{
		assert(!std.regex.match(fileType, r"^\{\{.*?\} \{.*?\}\}$").empty,
				"File type must take the form of '{{Description} {.ext1 .ext2 .ext3 ...}}'. Braces and spaces are important!");

		this._fileTypes ~= fileType;

		return cast(T) this;
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
	 * Set the initial file in the dialog.
	 *
	 * Params:
	 *     file = The initial file.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto setInitialFile(this T)(string file)
	{
		this._initialFile = file;

		return cast(T) this;
	}
}
