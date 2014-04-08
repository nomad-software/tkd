/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.style;

/**
 * Standard style values of widgets.
 */
enum Style : string
{
	button      = "TButton",      /// Button widget style.
	canvas      = "Canvas",       /// Canvas widget style.
	checkButton = "TCheckbutton", /// CheckButton widget style.
	comboBox    = "TCombobox",    /// ComboBox widget style.
	entry       = "TEntry",       /// Entry widget style.
	frame       = "TFrame",       /// Frame widget style.
	label       = "TLabel",       /// Label widget style.
	labelFrame  = "TLabelframe",  /// LabelFrame widget style.
	menuButton  = "TMenubutton",  /// MenuButton widget style.
	noteBook    = "TNotebook",    /// NoteBook widget style.
	panedWindow = "TPanedwindow", /// PanedWindow widget style.
	progressBar = "TProgressbar", /// ProgressBar widget style.
	radioButton = "TRadiobutton", /// RadioButton widget style.
	scale       = "TScale",       /// Scale widget style.
	scrollBar   = "TScrollbar",   /// ScrollBar widget style.
	separator   = "TSeparator",   /// Separator widget style.
	sizeGrip    = "TSizegrip",    /// SizeGrip widget style.
	spinBox     = "TSpinbox",     /// SpinBox widget style.
	text        = "Text",         /// Text widget style.
	treeView    = "Treeview",     /// Treeview widget style.

	toolbutton = "Toolbutton",    /// Toolbutton style. Useful for styling widget for use on a toolbar.
}
