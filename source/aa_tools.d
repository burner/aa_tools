module aa_tools;

import std.traits : KeyType, ValueType, isImplicitlyConvertible;

auto nestedAccess(AA,Args...)(ref AA aa, Args args) {
	static assert(__traits(isAssociativeArray, AA)
			, AA.stringof ~ " must be an AssociativeArray");
	static assert(Args.length > 0, "No args provided");

	alias AAEEC = KeyType!(AA);
	static assert(isImplicitlyConvertible!(Args[0],AAEEC)
			, AA.stringof ~ " key type " ~ AAEEC.stringof
			~ " does not match index type " ~ Args[0].stringof);

	static if(args.length == 1) {
		auto ret = args[0] in aa;
		return ret;
	} else {
		auto ret = args[0] in aa;
		return ret is null
			? null
			: nestedAccess(*ret, args[1 .. $]);
	}
}

void nestedInsert(AA,T,Args...)(ref AA aa, auto ref T toInsert, Args args) {
	static assert(__traits(isAssociativeArray, AA)
			, AA.stringof ~ " must be an AssociativeArray");
	static assert(Args.length > 0, "No args provided");

	alias AAEEC = KeyType!(AA);
	static assert(isImplicitlyConvertible!(Args[0],AAEEC)
			, AA.stringof ~ " key type " ~ AAEEC.stringof
			~ " does not match index type " ~ Args[0].stringof);
	static if(args.length == 1) {
		aa[args[0]] = toInsert;
		auto ret = args[0] in aa;
	} else {
		auto ret = args[0] in aa;
		if(ret is null) {
			aa[args[0]] = ValueType!(AA).init;
			ret = args[0] in aa;
		}
		nestedInsert(*ret, toInsert, args[1 .. $]);
	}
}

@safe unittest {
	long[string][bool] aa;
	long* p = nestedAccess(aa, true, "Hello World");
	assert(p is null);
	aa[true] = long[string].init;
	aa[true]["Hello World"] = 10;

	p = nestedAccess(aa, true, "Hello World");
	assert(p !is null);
	assert(*p == 10);
}

@safe unittest {
	long[string][bool] aa;
	nestedInsert(aa, 10, true, "Hello World");
	long* p = nestedAccess(aa, true, "Hello World");
	assert(p !is null);
	assert(*p == 10);
}

@safe unittest {
	long[string][bool][long] aa;
	nestedInsert(aa, 10, 1337, true, "Hello World");
	long* p = nestedAccess(aa, 1337, true, "Hello World");
	assert(p !is null);
	assert(*p == 10);
}
