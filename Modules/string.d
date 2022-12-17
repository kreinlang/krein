module Modules.string;


import std.conv;
import std.stdio;
import std.array;
import std.string;
import std.algorithm;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.numbers;
import Object.lists;



class Trim: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(chomp(params[0].__str__, params[1].__str__));
    	
        return new String(chomp(params[0].__str__));
    }

    override string __str__() { return "trim (string method)"; }
}


class Strip: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(strip(params[0].__str__, params[1].__str__));
    	
        return new String(strip(params[0].__str__));
    }

    override string __str__() { return "strip (string method)"; }
}


class Lstrip: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(stripLeft(params[0].__str__, params[1].__str__));
    	
        return new String(stripLeft(params[0].__str__));
    }

    override string __str__() { return "lstrip (string method)"; }
}


class Rstrip: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(stripRight(params[0].__str__, params[1].__str__));
    	
        return new String(stripRight(params[0].__str__));
    }

    override string __str__() { return "rstrip (string method)"; }
}


class Wrap: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(wrap(params[0].__str__, cast(int)params[1].number2));
    	
        return new String(wrap(params[0].__str__, 5));
    }

    override string __str__() { return "wrap (string method)"; }
}


class IndexOf: DataType {
    override DataType __call__(DataType[] params){
        return new Number(indexOf(params[0].__str__, params[1].__str__));
    }

    override string __str__() { return "indexOf (string method)"; }
}


class Replace: DataType {
    override DataType __call__(DataType[] params){
        return new Number(indexOf(params[0].__str__, params[1].__str__));
    }

    override string __str__() { return "indexOf (string method)"; }
}


DataType toStr(string i){
	return new String(strip(i));
}


class SplitLines: DataType{
    override DataType __call__(DataType[] params){
        auto arr = splitLines(params[0].__str__);
        alias linz = map!(toStr);

        return new List(linz(arr).array);
    }

    override string __str__() { return "splitLines (string method)"; }
}


class Split: DataType{
    override DataType __call__(DataType[] params){
        alias linz = map!(toStr);

    	if (params.length > 1){
        	auto arr = split(params[0].__str__, params[1].__str__);
       		return new List(linz(arr).array);
    	
    	} else {
        	auto arr = params[0].__str__.split;
	        return new List(linz(arr).array);
    	}

    	return new None();
    }

    override string __str__() { return "split (string method)"; }
}


class StringM: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "trim": new Trim(),
            "wrap": new Wrap(),
            "strip": new Strip(),
            "split": new Split(),
            "lstrip": new Lstrip(),
            "rstrip": new Rstrip(),
            "indexOf": new IndexOf(),
            "splitLines": new SplitLines(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "string (builtin module)";
    }
}


