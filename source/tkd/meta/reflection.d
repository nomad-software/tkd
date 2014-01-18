/**
 * Mdule containing handy reflection functions.
 */
module tkd.meta.reflection;

/**
 * Imports.
 */
import std.traits;

/**
 * Get an enum member by its value.
 *
 * Params:
 *     value = The value of the enum member to get.
 *
 * Returns:
 *     The enum member that matches the value. If no match is made return the first member.
 */
T getEnumMemberByValue(T, A)(A value) if (is(T == enum))
{
	foreach (member; EnumMembers!(T))
	{
		if (value == member)
		{
			return member;
		}
	}
	return T.init;
}

unittest
{
	import dunit.toolkit;

	enum E
	{
		one,
		two,
	}

	1.getEnumMemberByValue!(E)().assertEqual(E.two);
	3.getEnumMemberByValue!(E)().assertEqual(E.one);
}
