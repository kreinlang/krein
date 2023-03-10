module Modules.process;

import std.stdio;
import std.conv;
import std.uni;
import std.file;
import std.array;
import std.process;

import Modules.files;

import Object.datatype;
import Object.strings;
import Object.boolean;
import Object.numbers;
import Object.lists;
import Object.bytes;
import Object.classes;


class Wait: DataType{
    Pid pid;

    this(Pid pid){
        this.pid = pid;
    }

    override DataType __call__(DataType[] params){
        return new Number(wait(this.pid));
    }

    override string __str__() { return "pid (spawn object)"; }
}


class Kill: DataType{
    Pid pid;

    this(Pid pid){
        this.pid = pid;
    }

    override DataType __call__(DataType[] params){
        kill(this.pid);
        return new None(); 
    }

    override string __str__() { return "kill (pid method)"; }
}


class Fetch: DataType{
    File[string] info;

    this(File[string] info){
        this.info = info;
    }

    override DataType __call__(DataType[] params){
        List list = new List([]);

        list.__act__(new String(readText(this.info["stdout"].name)));
        list.__act__(new String(readText(this.info["stderr"].name)));

        return list;
    }

    override string __str__() { return "fetch (spawn method)"; }
}

class stdinWrite: DataType{
    Pid pid;

    this(Pid pid){
        this.pid = pid;
    }

    override DataType __call__(DataType[] params){
        if (params.length) {
            stdin.writeln(params[0].__str__);
        }
        return new None();
    }

    override string __str__() { return "write (stdinn method)"; }
}

class stdinFlush: DataType{
    Pid pid;

    this(Pid pid){
        this.pid = pid;
    }

    override DataType __call__(DataType[] params){
        stdin.flush();
        return new None();
    }

    override string __str__() { return "flush (stdinn method)"; }
}

class stdinClose: DataType{
    Pid pid;

    this(Pid pid){
        this.pid = pid;
    }

    override DataType __call__(DataType[] params){
        stdin.close();
        return new None();
    }

    override string __str__() { return "close (stdin method)"; }
}


class PID: DataType{
    DataType[string] attributes;

    this(Pid pid, File[string] output){
        this.attributes = [
            "wait": new Wait(pid),
            "kill": new Kill(pid),
            "fetch": new Fetch(output),
            "stdin": new Obj_("stdin", [
                    "write": new stdinWrite(pid),
                    "flush": new stdinFlush(pid),
                    "close": new stdinClose(pid),
                ])
        ];
    }

    override DataType[string] attrs() { return this.attributes; }

    override string __str__() { return "pid (spawn object)"; }
}


class Spawn: DataType {
    File[string] log;
    bool shell;

    this(){
        this.log = ["stdin": stdin, "stderr": stderr, "stdout": stdout];
        this.shell = false;
    }

    override DataType __call__(DataType[] params){
        if (params.length){
            string cmd = params[0].__str__;

            if (params.length > 1 && params[1].__type__ == "dict") {
                DataType[string] opt = params[1].__heap__;

                foreach (string i; opt.keys()){
                    if (i in this.log){
                        if (opt[i].__type__ == "0xeff2aec56"){
                            this.log[i] = File(opt[i].attrs["file"].__str__, "w+");
                        }
                    } else if (i == "shell") {
                        this.shell = opt[i].capable;
                    }
                }
            }

            if (this.shell){
                return new PID(spawnShell(cmd, this.log["stdin"], this.log["stdout"], this.log["stderr"]), this.log);
            }

            return new PID(spawnProcess(cmd, this.log["stdin"], this.log["stdout"], this.log["stderr"]), this.log);
        }

        return new None();
    }

    override string __str__() {
        return "spawn (process method)";
    }
}


class FILE: DataType{
    override DataType __call__(DataType[] params){

        if (params.length) {
            return new Obj_("std-File0xeff", ["file": params[0]]);
        }

        return new None();
    }

    override string __str__() {
        return "file (process method)";
    }
}


class Exec: DataType{
    override DataType __call__(DataType[] params){
        if (params.length){
            auto pid = execute(params[0].__str__.split);

            return new Obj_(to!string(pid.status), [
                            "status": new Number(pid.status),
                            "output": new String(pid.output),
                        ]);
        }
        return new None();
    }

    override string __str__() {
        return "exec (process method)";
    }
}


class ExecShell: DataType{
    override DataType __call__(DataType[] params){
        if (params.length){
            auto pid = executeShell(params[0].__str__);

            return new Obj_(to!string(pid.status), [
                            "status": new Number(pid.status),
                            "output": new String(pid.output),
                        ]);
        }
        return new None();
    }

    override string __str__() {
        return "execShell (process method)";
    }
}


class Process: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "spawn": new Spawn(),
            "exec": new Exec(),
            "execShell": new ExecShell(),
            "FILE": new FILE(),
            "DEVNULL": new String("devnull"),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "process (syscall wrapper)";
    }
}

