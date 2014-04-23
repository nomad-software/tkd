#tkd
**GUI toolkit for the D programming language**

---

## Overview

Tkd is a fully cross-platform GUI toolkit based on
[Tcl/Tk](http://www.tcl.tk/). Tkd allows you to build GUI applications easily
and with the knowledge of a consistent, native look and feel on every platform.

### Why Tcl/Tk?

Tkd development was initiated based on the performance and uptake of the
[Tkinter](https://wiki.python.org/moin/TkInter) toolkit distributed as a
standard part of the [Python](https://www.python.org/) programming language.
Tkinter allows developers easy access to GUI programming with very little
learning. Being the _de facto_ GUI toolkit of Python has introduced more
developers to GUI application programming and increased the popularity of the
language as a whole. Tkd is an attempt to provide D with the same resource.

### Supported platforms

* Windows
* Linux
* Mac OSX

## Documentation

There is full HTML documentation within the repository inside the [docs](https://github.com/nomad-software/tkd/tree/master/docs/) directory.

### Example

```c++
import tkd.tkdapplication;                               // Import Tkd.

class Application : TkdApplication                       // Extend TkdApplication.
{
	private void exitCommand(CommandArgs args)           // Create a callback.
	{
		this.exit();                                     // Exit the application.
	}

	override protected void initInterface()              // Initialise user interface.
	{
		auto frame = new Frame(2, ReliefStyle.groove)    // Create a frame.
			.pack(10);                                   // Place the frame.

		auto label = new Label(frame, "Hello World!")    // Create a label.
			.pack(10);                                   // Place the label.

		auto exitButton = new Button(frame, "Exit")      // Create a button.
			.setCommand(&this.exitCommand);              // Use the callback.
			.pack(10);                                   // Place the button.
	}
}

void main(string[] args)
{
	auto app = new Application();                        // Create the application.
	app.run();                                           // Run the application.
}
```

### Supported GUI widgets

| Widget                                                                                                                     | Description   |
| :------------------------------------------------------------------------------------------------------------------------- | :------------ |
| [Button](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/button.html)           | A button widget displays a textual label and/or image, and evaluates a command when pressed. |
| [Canvas](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/canvas.html)           | Canvas widgets implement structured graphics. A canvas displays any number of items, which may be things like rectangles, circles, lines, and text. Items may be manipulated (e.g. moved or re-colored) and commands may be associated with items in much the same way that the bind command allows commands to be bound to widgets. |
| [CheckButton](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/checkbutton.html) | A checkbutton widget is used to show or change a setting. It has two states, selected and deselected. The state of the checkbutton may be linked to a value. |
| [ComboBox](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/combobox.html)       | A combobox combines a text field with a pop-down list of values; the user may select the value of the text field from among the values in the list. |
| [Entry](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/entry.html)             | An entry widget displays a one-line text string and allows that string to be edited by the user. |
| [Frame](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/frame.html)             | A frame widget is a container, used to group other widgets together. |
| [Label](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/label.html)             | A label widget displays a textual label and/or image. |
| [LabelFrame](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/labelframe.html)   | A label frame widget is a container used to group other widgets together. It has an optional label, which may be a plain text string or another widget. |
| [MenuButton](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/menubutton.html)   | A menu button widget displays a textual label and/or image, and displays a menu when pressed. |
| [NoteBook](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/notebook.html)       | A notebook widget manages a collection of panes and displays a single one at a time. Each pane is associated with a tab, which the user may select to change the currently-displayed pane. |
| [PanedWindow](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/panedwindow.html) | A paned window widget displays a number of subwindows, stacked either vertically or horizontally. The user may adjust the relative sizes of the subwindows by dragging the sash between panes. |
| [ProgressBar](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/progressbar.html) | A progress bar widget shows the status of a long-running operation. |
| [RadioButton](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/radiobutton.html) | Radio button widgets are used in groups to show or change a set of mutually-exclusive options. |
| [Scale](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/scale.html)             | A scale widget is typically used to control the numeric value that varies uniformly over some range. A scale displays a slider that can be moved along over a trough, with the relative position of the slider over the trough indicating the value. |
| [Scrollbar](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/scrollbar.html)     | Scrollbar widgets are typically linked to an associated window that displays a document of some sort, such as a file being edited or a drawing. A scrollbar displays a thumb in the middle portion of the scrollbar, whose position and size provides information about the portion of the document visible in the associated window. The thumb may be dragged by the user to control the visible region. Depending on the theme, two or more arrow buttons may also be present; these are used to scroll the visible region in discrete units. |
| [Separator](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/separator.html)     | A separator widget displays a horizontal or vertical separator bar. |
| [SizeGrip](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/sizegrip.html)       | A sizegrip widget (also known as a grow box) allows the user to resize the containing toplevel window by pressing and dragging the grip. |
| [SpinBox](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/spinbox.html)         | A spinbox widget is an entry widget with built-in up and down buttons that are used to either modify a numeric value or to select among a set of values. |
| [Text](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/text.html)               | A text widget displays one or more lines of text and allows that text to be edited. Text widgets support embedded widgets or embedded images. |
| [TreeView](http://htmlpreview.github.io/?https://github.com/nomad-software/tkd/master/docs/tkd/widget/treeview.html)       | The treeview widget displays a hierarchical collection of items. Each item has a textual label, an optional image, and an optional list of data values. |

## Building

It's recommended to use the [dub](http://code.dlang.org/about) build tool to
build all Tkd projects.

## Examples

There are a few examples in this package which can be built using dub. Clone
this repository and use the following commands to build the examples to see
what's possible.
```
dub --config=example5
```
## Dependencies

### Source code

Tkd requires other D source libraries to correctly use and link against
pre-existing C libraries. The source dependencies are as follows:

 * https://github.com/nomad-software/tcltk
 * https://github.com/nomad-software/x11 (Linux only)

Dub handles these automatically and during a build acquires them. While
building, the tcltk repository is configured to link against the required
Tcl/Tk libraries, hence they need to be installed for the application to
function.

### Libraries

Tkd requires version **8.6.1** of the Tcl/Tk libraries or greater installed.

#### Windows

On Windows you can download and install
[ActiveTcl](http://www.activestate.com/activetcl/downloads) from ActiveState
which is a fully supported professional library. This will install all needed
Tcl/Tk DLL's and initialization scripts. Once this is installed, building and
linking with dub will give immediate results. ActiveTcl also comes with a
[silent
install](http://community.activestate.com/faq/unattended-installation-a) option
if you want to include it as part of an installation.

If however you don't want to install Tcl/Tk and want the application to be
self-contained, you can copy the DLL's and the initialization script library
directory into the root of the finished application. These files can be
conveniently found in the `dist` folder within the
[tcktk](https://github.com/nomad-software/tcltk) repository. Your finished
application's directory would then look something like this:
```
project
├── app.exe
├── tcl86.dll
├── tk86.dll
├── zlib1.dll
└── library
    └── *.tcl files
```
I'm hoping once [this](https://github.com/rejectedsoftware/dub/issues/299) dub
issue is resolved this will become the default option on Windows and dub will
copy all required DLL's and files to the application's directory on every dub
build.

#### Linux/Mac OSX

On Linux and Mac OSX things are a little easier as both operating systems have
Tcl/Tk installed by default. If however they do not have the latest version,
the libraries can be updated via their respective package managers or install
ActiveTcl. The linked libraries are **libtcl** and **libtk**.

## Notes

### Widgets

#### Canvas

The postscript methods of this widget havn't been implemented yet due to time.
This means no exporting to postscript files or printing is available from this
widget. This can be added in the future if there is need.

#### Text

The extended text editing functionality of this widget has not been implement
because there are better, more modern editor widgets available separately. This
control is not indended to be used as a fully featured text editor.
