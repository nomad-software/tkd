/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.combobox;

/**
 * Imports.
 */
import tkd.element.uielement;
import tkd.widget.common.exportselection;
import tkd.widget.common.height;
import tkd.widget.common.justify;
import tkd.widget.common.postcommand;
import tkd.widget.common.width;
import tkd.widget.common.values;
import tkd.widget.widget;

/**
 * Class representing a combo box widget.
 *
 * Additional_Commands:
 *     These are common commands that can be used with this widget.
 *     $(P
 *         $(LINK2 ./common/exportselection.html, Exportselection) $(BR)
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/justify.html, Justify) $(BR)
 *         $(LINK2 ./common/postcommand.html, PostCommand) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
 *         $(LINK2 ./common/values.html, Values) $(BR)
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class ComboBox : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "combobox";

		this._tk.eval("ttk::combobox %s", this.id);

		this.setState(["readonly"]);
	}

// public void clear()
// {
// 	this._tk.eval("%s.entry selection clear", this.id);
// }

	/**
	 * Mixin common commands.
	 */
	mixin ExportSelection;
	mixin Height;
	mixin Justify;
	mixin PostCommand;
	mixin Width;
	mixin Values;
}
