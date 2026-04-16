unmap <Space>
nmap <Space> <nop>

" Điều hướng Colemak-DH (n-e-i = j-k-l)
unmap n
unmap e
unmap i
unmap u
unmap l
unmap N
unmap E
unmap I
unmap U
unmap L

nmap n j
vmap n j
nmap e k
vmap e k
nmap i l
vmap i l

" Cuộn trang & Search căn giữa
nmap <C-d> <C-d>zz
nmap <C-u> <C-u>zz
nmap m nzzzv
nmap M Nzzzv

" Insert, Undo, Black hole delete
nmap u i
nmap U I
nmap l u
nmap x "_x

" Thay đổi số
nmap + <C-a>
nmap - <C-x>

" File & Window management
exmap save obcommand editor:save-file
nmap <Space>w :save<CR>

exmap quit obcommand app:close-viewer
nmap <Space>q :quit<CR>

exmap vsplit obcommand editor:open-vertical-column
nmap sv :vsplit<CR>

" Tabs (Yêu cầu plugin Cycle Through Panes)
exmap nextTab obcommand cycle-through-panes:cycle-through-panes
exmap prevTab obcommand cycle-through-panes:cycle-through-panes-reverse
nmap <Tab> :nextTab<CR>
nmap <S-Tab> :prevTab<CR>

" Utilities
nmap <Esc> :noh<CR>

exmap openLink obcommand editor:open-link-in-new-leaf
nmap gx :openLink<CR>

exmap moveLineDown obcommand editor:swap-line-down
exmap moveLineUp obcommand editor:swap-line-up
nmap <A-n> :moveLineDown<CR>
nmap <A-e> :moveLineUp<CR>map <A-e> :moveLineUp
