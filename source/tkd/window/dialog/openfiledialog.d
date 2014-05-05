/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.window.dialog.openfiledialog;

/**
 * Imports.
 */
import std.array;
import std.regex;
import tkd.window.dialog.filedialog;
import tkd.window.window;

/**
 * Pops up a dialog box for the user to open a file.
 *
 * Example:
 * ---
 * auto dialog = new OpenFileDialog("Open a file")
 * 	.setMultiSelection(false)
 * 	.setDefaultExtension(".txt")
 * 	.addFileType("{{All files} {*}}")
 * 	.addFileType("{{Text files} {.txt}}")
 * 	.setInitialDirectory("~")
 * 	.setInitialFile("file.txt")
 * 	.show();
 *
 * string fileToOpen = dialog.getResult();
 * ---
 *
 * Result:
 *     The full path of the file selected.
 *
 * See_Also:
 *     $(LINK2 ./filedialog.html, tkd.dialog.filedialog) $(BR)
 */
class OpenFileDialog : FileDialog
{
	/*
	 * Allows the user to choose multiple files from the Open dialog.
	 */
	protected bool _selectMultiple;

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     parent = The parent window of the dialog.
	 *     title = The title of the dialog.
	 */
	this(Window parent, string title = "Open")
	{
		super(parent, title);
	}

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     title = The title of the dialog.
	 */
	this(string title = "Open")
	{
		this(null, title);
	}

	/**
	 * Set whether to enable mutli-selection.
	 *
	 * Params:
	 *     enable = Enables multi-selections.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto setMultiSelection(this T)(bool enable)
	{
		this._selectMultiple = enable;

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
			this._tk.eval("tk_getOpenFile -parent %s -title {%s} -multiple %s -defaultextension {%s} -filetypes {%s} -initialdir {%s} -initialfile {%s} -typevariable %s", this._parent.id, this._title, this._selectMultiple, this._defaultExtension, this._fileTypes.join(" "), this._initialDirectory, this._initialFile, this._typeVariable);
		}
		else
		{
			this._tk.eval("tk_getOpenFile -title {%s} -multiple %s -defaultextension {%s} -filetypes {%s} -initialdir {%s} -initialfile {%s} -typevariable %s", this._title, this._selectMultiple, this._defaultExtension, this._fileTypes.join(" "), this._initialDirectory, this._initialFile, this._typeVariable);
		}

		string result = this._tk.getResult!(string);

		if (match(result, r"^bad window path name").empty)
		{
			if (this._selectMultiple)
			{
				auto regexResult = matchAll(result, r"\{.*?\}");
				result           = result.replaceAll(regex(r"\{.*?\}"), "");
				this._results   ~= result.split();

				foreach (match; regexResult)
				{
					this._results ~= match.hit;
				}

				this.removeBracesFromResults;
			}
			else
			{
				this._results = [result];
			}
		}

		return cast(T) this;
	}

	/**
	 * Get multiple dialog results.
	 *
	 * Returns:
	 *     The multiple results of the dialog.
	 */
	public string[] getResults()
	{
		assert(this._selectMultiple, "You need to set multi-selection on to retrieve more than one result.");

		return this._results;
	}
}
