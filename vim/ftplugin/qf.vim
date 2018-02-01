
if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1
setlocal stl=%t\ %1*\ %{line('$')}\ %*\ match\ for\ %1*%{g:SearchPattern}%*
