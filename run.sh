#!/usr/bin/bash

# clear
dmd krein.d Ast/eval.d Ast/config.d Ast/parser.d Ast/lexer.d Ast/node.d Ast/shell.d Object/datatype.d Object/strings.d Object/numbers.d Object/boolean.d Object/functions.d Object/lists.d Object/dictionary.d Object/bytes.d Object/classes.d Modules/exceptions.d Modules/utils.d Modules/files.d Modules/path.d Modules/math.d Modules/random.d Modules/time.d Modules/socket.d Modules/env.d Modules/net.d Modules/process.d Modules/thread.d Modules/json.d Modules/string.d

./krein main.k
