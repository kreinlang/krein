module Object.lists;

import std.stdio;
import std.conv;
import std.uni;
import std.algorithm;

import Object.datatype;
import Object.strings;
import Object.boolean;
import Object.numbers;


class Link: DataType{
	List data;

	this(List data){
		this.data = data;
	}

	override string __str__(){
		return "[ref]";
	}
}


class Push: DataType{
	List list;
	this(List list){ this.list = list; }

	override DataType __call__(DataType[] params){
		if (params[0] == this.list)
			this.list.data ~= new Link(this.list);
		else
			this.list.data ~= params[0];

		return new None();
	}

	override string __str__(){ return "push (array method)";}
}


class Pop: DataType{
	List list;

	this(List list){
		this.list = list;
	}

	override DataType __call__(DataType[] params){
		auto index = this.list.data.length - 1;
		DataType popped;

		if (params.length)
			index = cast(int)params[0].number2;

		popped = this.list.data[index];
		this.list.data = remove(this.list.data, index);

		return popped;
	}

	override string __str__(){ return "pop (array method)";}
}


class Reverse: DataType{
	List list;

	this(List list){
		this.list = list;
	}

	override DataType __call__(DataType[] params){
		this.list.data = this.list.data.reverse;
		return new None();
	}

	override string __str__(){ return "reverse (array method)";}
}


class Dup: DataType{
	List list;

	this(List list){
		this.list = list;
	}

	override DataType __call__(DataType[] params){ return new List(this.list.data.dup); }

	override string __str__(){ return "dup (array method)"; }
}



class List: DataType{
	DataType[] data;
	DataType[string] attributes;

	this(DataType[] data){
		this.data = data;
		this.attributes = [
							"push": new Push(this),
							"dup": new Dup(this),
							"pop": new Pop(this),
							"reverse": new Reverse(this),
						  ];
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType[] __array__(){
		return this.data;
	}

	override DataType __iter__(int index){
		if (index < this.data.length){
			return this.data[index];
		}

		return new EOI();
	}

	override string __type__(){
		return "array";
	}

	override void __act__(DataType i) {
		this.data ~= i;
	}

	override string __str__(){
		return this.__json__;
	}


	override string __json__(){
		string str = "[";
		DataType cur;
		DataType[] dt = this.data;

		if (dt.length){
			for(int i = 0; i < dt.length-1; i++)		
				str ~= dt[i].__json__ ~ ", ";
		
			cur = dt[data.length-1];
			str ~= cur.__json__;
		}

		return str ~ "]";
	}


	override DataType __call__(DataType[] i){
		int x = to!int(i[0].number);

		if (x < this.data.length)
			return this.data[x];

		return new EOI();
	}

	override DataType __index__(DataType[] i){
		int x = to!int(i[0].number);

		if (x < this.data.length){
			this.data[x] = i[1];
		}

		return new None();
	}

	override DataType __length__(){
		return new Number(to!double(this.data.length));
	}

	override ulong[] __listrepr__(){
		ulong[] ret;

		for(ulong i = 1; i < this.data.length+1; i++){
			ret ~= i;
		}

		return ret;
	}

	override bool capable(){
		if (this.data.length == 0){
			return false;
		}
		return true;
	}
}

