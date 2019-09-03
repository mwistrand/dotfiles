  let g:neomake_javascript_enabled_makers = findfile('.jshintrc', '.;') != '' ? ['jshint'] : ['eslint']
