" expand stock detection so that it'll detect 'Dockerfile-prod' or
" 'prod.dockerfile'
au BufRead,BufNewFile [Dd]ockerfile set filetype=dockerfile
au BufRead,BufNewFile [Dd]ockerfile* set filetype=dockerfile
au BufRead,BufNewFile *.[Dd]ockerfile set filetype=dockerfile
