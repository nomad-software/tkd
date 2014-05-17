/**
 * Element module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.element;

/**
 * Imports.
 */
import core.memory;
import std.array;
import std.conv;
import std.digest.crc;
import std.random;
import std.string;
import tcltk.tk;
import tkd.interpreter;

/**
 * The ui element base class.
 */
abstract class Element
{
	/*
	 * The Tk interpreter.
	 */
	protected Tk _tk;

	/*
	 * The parent of this element if nested within another.
	 */
	protected Element _parent;

	/*
	 * An optional identifier that overrides the generated id.
	 */
	protected string _manualIdentifier;

	/*
	 * Internal element identifier.
	 */
	protected string _elementId;

	/*
	 * The unique hash of this element.
	 */
	protected string _hash;

	/**
	 * Construct the element.
	 *
	 * Params:
	 *     parent = An optional parent of this element.
	 */
	public this(Element parent)
	{
		this._tk        = Tk.getInstance();
		this._parent    = parent;
		this._elementId = "element";
		this._hash      = this.generateHash();
	}

	/**
	 * Construct the element.
	 */
	public this()
	{
		this(null);
	}

	/**
	 * The unique id of this element.
	 *
	 * Returns:
	 *     The string id.
	 */
	public @property string id() nothrow
	{
		if (this._manualIdentifier !is null)
		{
			return this._manualIdentifier;
		}

		string parentId;

		if (this._parent !is null && this._parent.id != ".")
		{
			parentId = this._parent.id;
		}

		return parentId ~ "." ~ this._elementId ~ "-" ~ this._hash;
	}

	/**
	 * The parent element if any.
	 *
	 * Returns:
	 *     The parent element or null.
	 */
	public @property Element parent()
	{
		return this._parent;
	}

	/*
	 * Override the unique id of this element.
	 *
	 * Params:
	 *     identifier = The overriden identifier.
	 */
	protected void overrideGeneratedId(string identifier) nothrow
	{
		this._manualIdentifier = identifier;
	}

	/*
	 * Generate the unique hash for this element.
	 *
	 * Returns:
	 *     The string hash.
	 */
	protected string generateHash()
	{
		string text = Random(unpredictableSeed).front.to!(string);
		return hexDigest!(CRC32)(text).array.to!(string);
	}

	/*
	 * Generate the unique hash for this element.
	 *
	 * Params:
	 *     text = The format of the text to generate a hash of.
	 *     args = The arguments that the format defines (if any).
	 *
	 * Returns:
	 *     The string hash.
	 */
	protected string generateHash(A...)(string text, A args)
	{
		return hexDigest!(CRC32)(format(text, args)).array.to!(string);
	}

	/*
	 * Get the internal name for a command.
	 *
	 * Params:
	 *     uniqueData = An extra seed for the internal command name hash.
	 *
	 * Returns:
	 *     The internal name of the command.
	 */
	protected string getCommandName(string uniqueData = null)
	{
		return format("command-%s", this.generateHash("command%s%s", uniqueData, this.id));
	}

	/*
	 * Create a command.
	 *
	 * Params:
	 *     callback = The callback to register as a command.
	 *     uniqueData = An extra seed for the internal command name hash.
	 *
	 * Returns:
	 *     The internal command name.
	 *
	 * See_Also:
	 *     $(LINK2 ./element.html#CommandCallback, tkd.element.element.CommandCallback)
	 */
	protected string createCommand(CommandCallback callback, string uniqueData = null)
	{
		Tcl_CmdProc commandCallbackHandler = function(ClientData data, Tcl_Interp* tclInterpreter, int argc, const(char)** argv)
		{
			CommandArgs args = *cast(CommandArgs*)data;

			try
			{
				T getCommandParameter(T)(const(char)** argv, int index)
				{
					string raw = argv[index].to!(string);

					if (raw != "??")
					{
						return raw.to!(T);
					}

					return T.init;
				}

				if (argc == 9)
				{
					args.event.button  = getCommandParameter!(int)(argv, 1);
					args.event.keyCode = getCommandParameter!(int)(argv, 2);
					args.event.x       = getCommandParameter!(int)(argv, 3);
					args.event.y       = getCommandParameter!(int)(argv, 4);
					args.event.wheel   = getCommandParameter!(int)(argv, 5);
					args.event.key     = getCommandParameter!(string)(argv, 6);
					args.event.screenX = getCommandParameter!(int)(argv, 7);
					args.event.screenY = getCommandParameter!(int)(argv, 8);
				}
				else if (argc == 2)
				{
					args.dialog.font = getCommandParameter!(string)(argv, 1);
				}

				args.callback(args);
			}
			catch (Throwable ex)
			{
				string error = "Error occurred in command callback. ";
				error ~= ex.msg ~ "\n";
				error ~= "Element: " ~ args.element.id ~ "\n";

				Tcl_SetResult(tclInterpreter, error.toStringz, TCL_STATIC);
				return TCL_ERROR;
			}

			return TCL_OK;
		};

		Tcl_CmdDeleteProc deleteCallbackHandler = function(ClientData data)
		{
			GC.removeRoot(data);
			GC.clrAttr(data, GC.BlkAttr.NO_MOVE);
		};

		string command = this.getCommandName(uniqueData);

		CommandArgs* args = cast(CommandArgs*)GC.malloc(CommandArgs.sizeof, GC.BlkAttr.NO_MOVE);
		GC.addRoot(args);

		(*args)            = CommandArgs.init;
		(*args).element    = this;
		(*args).uniqueData = uniqueData;
		(*args).callback   = callback;
		(*args).name       = command;

		this._tk.createCommand(command, commandCallbackHandler, args, deleteCallbackHandler);

		return command;
	}
}

/**
 * Alias representing a command callback.
 */
alias void delegate(CommandArgs args) CommandCallback;

/**
 * The CommandArgs struct passed to the CommandCallback on invocation.
 */
struct CommandArgs
{
	/**
	 * The element that issued the command.
	 */
	Element element;

	/**
	 * Any unique extra data.
	 */
	string uniqueData;

	/**
	 * The callback which was invoked as the command.
	 */
	CommandCallback callback;

	/**
	 * The name of this command to be used for re-arming an idle callback.
	 */
	string name;

	/**
	 * Data populated from a event binding created using the bind method.
	 */
	static struct Event
	{
		/**
		 * The number of any button that was pressed.
		 */
		int button;

		/**
		 * The key code of any key pressed.
		 */
		int keyCode;

		/**
		 * The horizontal position of the mouse relative to the widget.
		 */
		int x;

		/**
		 * The vertical position of the mouse relative to the widget.
		 */
		int y;

		/**
		 * Mouse wheel delta.
		 */
		int wheel;

		/**
		 * Key symbol of any key pressed.
		 */
		string key;

		/**
		 * The horizontal position of the mouse relative to the screen.
		 */
		int screenX;

		/**
		 * The vertical position of the mouse relative to the screen.
		 */
		int screenY;
	}

	Event event;

	/**
	 * Data populated from dialog interaction.
	 */
	static struct Dialog
	{
		/**
		 * Font information populated from dialog interaction.
		 */
		string font;
	}

	Dialog dialog;
}
