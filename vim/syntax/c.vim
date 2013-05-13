" Add highlighting for function definition in C++
function! EnhanceCppSyntax()
	syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
	hi def link cppFuncDef Special
	endfunction
autocmd Syntax cpp call EnhanceCppSyntax()
