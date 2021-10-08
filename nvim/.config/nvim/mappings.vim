" set leader key
let g:mapleader = "\<Space>"

" Reload init.vim file
nnoremap <leader>rl :so ~/.config/nvim/init.vim<CR>
" Shortcut to init.vim file that loads it into buffer
nnoremap <leader>rm :e ~/.config/nvim/init.vim<CR>

" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" Use alt + hjkl to resize windows
nnoremap <M-j>    :resize -2<CR>
nnoremap <M-k>    :resize +2<CR>
nnoremap <M-h>    :vertical resize -2<CR>
nnoremap <M-l>    :vertical resize +2<CR>

" Enter normal/general mode
inoremap fd <Esc>
vnoremap fd <Esc>

" Easy CAPS
inoremap <c-u> <ESC>viwUi
nnoremap <c-u> viwU<Esc>

" TAB in normal/general mode will move to text buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

" Alternate way to save
nnoremap <C-s> :w<CR>
" Use control-c instead of escape
nnoremap <C-c> <Esc>
" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Goto end of line
nnoremap <leader> l $

" Better window/split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
" Switch to Terminal-Normal mode when in embedded terminal
tnoremap <C-w> <C-\><C-n><C-w>

nnoremap <Leader>o o<Esc>^Da
nnoremap <Leader>O O<Esc>^Da

" Clear Netrw from buffer after selecting a directory path
autocmd FileType netrw setl bufhidden=wipe
let g:netrw_fastbrowse = 0

" list buffers to 
nnoremap <Leader>b :ls<CR>:b<Space>

