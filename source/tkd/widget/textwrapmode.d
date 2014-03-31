/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.textwrapmode;

/**
 * The wrap mode of the text widget.
 */
enum TextWrapMode : string
{
	none      = "none", /// No wrapping takes place.
	character = "char", /// The text is wrapped with the breaks mid word.
	word      = "word", /// The text is wrapped broken on words.
}
