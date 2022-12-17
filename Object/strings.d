module Object.strings;

import std.uni;
import std.conv;
import std.stdio;
import std.array;
import std.range;
import std.digest;
import std.algorithm;

import Object.bytes;
import Object.numbers;
import Object.boolean;
import Object.datatype;


class Encode: DataType{
	string data;
	this(string data){ this.data = data; }

	override DataType __call__(DataType[] params){ return new Chars(cast(char[])this.data); }

	override string __str__(){return "encode (string method)";}}


class Lower: DataType{
	string data;
	this(string data){ this.data = data; }

	override DataType __call__(DataType[] params){ return new String(toLower(this.data)); }

	override string __str__(){return "lower (string method)";}
}


class Upper: DataType{
	string data;
	this(string data){ this.data = data; }

	override DataType __call__(DataType[] params){ return new String(toUpper(this.data)); }
	
	override string __str__(){return "upper (string method)";}
}


class Replace: DataType{
	string data;
	this(string data){ this.data = data; }

	override DataType __call__(DataType[] params){
		return new String((this.data).replace(params[0].__str__, params[1].__str__));
	}
	override string __str__(){return "replace (string attr)";}
}


class Hex: DataType{
	string data;
	this(string data){ this.data = data; }

	override DataType __call__(DataType[] params){
		string new_string = toHexString(cast(ubyte[])this.data);
		return new String(new_string);
	}

	override string __str__(){return "hex (string method)";}
}


class Hex_toStr: DataType{
	string data;
	this(string data){ this.data = data; }

	override DataType __call__(DataType[] params){
		string new_str = this.data.chunks(2).map!(i => cast(char) i.to!ubyte(16)).array;
		
		return new String(new_str);
	}

	override string __str__(){return "hexTostr (string method)";}
}




class String: DataType{
	string data;
	DataType[string] attributes;

	this(string data){
		this.data = data;
		this.attributes = [
					"hex": new Hex(data),
					"hexTostr": new Hex_toStr(data),
					"lower": new Lower(data),
					"upper": new Upper(data),
					"encode": new Encode(data),
					"replace": new Replace(data),
				];
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){ return this.data; }
	
	override DataType __length__(){ return new Number(to!double(this.data.length)); }

	override DataType __iter__(int index){
		if (index < this.data.length){
			string idx;
			return new String(idx~this.data[index]);
		}

		return new EOI();
	}

	override DataType __call__(DataType[] i){
		int x = to!int(i[0].number);

		if (x < this.data.length){
			return new String(to!string(this.data[x]));
		}

		return new None();
	}

	override ulong[] __listrepr__(){
		ulong[] ret;

		for(ulong i = 1; i < this.data.length+1; i++)
			ret ~= i;

		return ret;
	}

	override string __json__(){
		return "\"" ~ this.data ~ "\"";
	}

	override bool capable(){
		if (this.data.length == 0){
			return false;
		}
		return true;
	}

	override string __type__(){ return "string"; }
}
