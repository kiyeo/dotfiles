call plug#begin('~/.config/nvim/autoload/plugged')
	"Better Syntax Support"
	Plug 'sheerun/vim-polyglot'
	"Conquer of Completion"
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
  "Themes"
  "Plug 'liuchengxu/space-vim-dark' 
  Plug 'w0ng/vim-hybrid'
  "Delete buffers without closing windows or messing up layouts"
  Plug 'moll/vim-bbye'
  "Clang formatter"
  Plug 'rhysd/vim-clang-format'
  "Denite"
  if has('nvim')
    Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/denite.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
call plug#end()
