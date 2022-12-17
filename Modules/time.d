module Modules.time;

import std.uni;
import std.conv;
import std.stdio;
import std.string;
import std.algorithm;

import core.time;
import core.stdc.time;
import std.datetime;
import core.thread;

import Object.lists;
import Object.classes;
import Object.dictionary;
import Object.strings;
import Object.numbers;
import Object.boolean;
import Object.datatype;



class Now: DataType{
    override DataType __call__(DataType[] params){
        auto ct = Clock.currTime();

        string now = capitalize(to!string(ct.dayOfWeek)) ~ " " ~ to!string(ct.day) ~ " " ~ capitalize(to!string(ct.month)) ~ " " ~ to!string(ct.hour) ~ ":" ~ to!string(ct.minute) ~ ":" ~ to!string(ct.second) ~ " " ~ to!string(ct.year);

        return new String(now);
    }

    override string __str__() {
        return "[Time.Function: #now]";
    }
}


class Sleep: DataType{
    override DataType __call__(DataType[] params){
        if (params.length) {
            Thread.getThis().sleep(dur!"seconds"(params[0].number2));
        }

        return new Number(0);
    }

    override string __str__() {
        return "[Time.Function: #sleep]";
    }
}


class Local: DataType{
    override DataType __call__(DataType[] params){
        
        SysTime lc = Clock.currTime();

        return new Obj_(lc.toString, [
                    "year": new Number(lc.year),
                    "hour": new Number(lc.hour),
                    "min": new Number(lc.minute),
                    "sec": new Number(lc.second),

                    "mday": new Number(lc.day),
                    "yday": new Number(lc.dayOfYear),
                    "wday": new String(capitalize(to!string(lc.dayOfWeek))),

                    "mon": new String(capitalize(to!string(lc.month))),
                    "isleap": bool_sort(lc.isLeapYear),
                ]);

        

        return new Number(0);
    }

    override string __str__() {
        return "[Time.Function: #date]";
    }
}


DataType _ClockType(){
    version (Posix) {
        return new Obj_("[Time.Object: #CT]", [
                "BOOTTIME": new Number(ClockType.bootTime),
            ]);
    }

    return new Obj_("[Time.Object: #CT]", ["BOOTTIME": new Number(1)]);
}


class _Systime: DataType{
    override DataType __call__(DataType[] params){
        auto st = Clock.currTime();
        string epo = to!string(st.toUnixTime()) ~ '.' ~ to!string(st.fracSecs.total!"hnsecs");

        return new Number(to!double(epo));
    }

    override string __str__() {
        return "[Time.Function: #systime]";
    }
}



class Time: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "CT": _ClockType(),
            "now": new Now(),
            "systime": new _Systime(),
            "sleep": new Sleep(),
            "local": new Local(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "[std.Module: #Time]";
    }
}

