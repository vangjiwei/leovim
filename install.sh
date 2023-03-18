#!/usr/bin/env bash
############################  SETUP PARAMETERS
app_name='leovim'
[ -z "$APP_PATH" ] && APP_PATH="$PWD"
############################  BASIC SETUP TOOLS

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
        msg "An error occurred in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }
    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi
    return 0
}

variable_set() {
    if [ -z "$1" ]; then
        error "You must have your HOME environmental variable set to continue."
    fi
}

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
}
############################ SETUP FUNCTIONS
create_vimrc(){
    local vimrc="$1"
    [ -f $vimrc ] && rm -f $vimrc
    cat << EOF > $vimrc
if filereadable(expand("~/.vimrc.test"))
    source ~/.vimrc.test
else
    source ~/.leovim.conf/init.vim
endif
EOF
    success "Setted up $vimrc"
}

create_symlinks() {
    local source_path="$1"
    local target_path="$2"
    lnif  "$source_path"  "$target_path"
    ret="$?"
    success "Setted up symlinks from $source_path to $target_path"
}

setup_plug() {
    local system_shell="$SHELL"
    export SHELL='/bin/sh'
    echo
    msg "Starting update/install plugins for $1"
    "$1" +PackSync +qall
    export SHELL="$system_shell"
    success "Successfully updated/installed plugins for $1"
}

############################ MAIN()
variable_set "$HOME"

mkdir -p "$HOME/.leovim.d/tags"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.local/bin"

# my config
cp -n $APP_PATH/scripts/bashrc   $HOME/.bashrc
cp -n $APP_PATH/scripts/inputrc  $HOME/.inputrc
cp -n $APP_PATH/scripts/configrc $HOME/.configrc

# cp nvim start command
cp -n $APP_PATH/scripts/z.sh   $HOME/.local/bin
cp -n $APP_PATH/scripts/nv.sh  $HOME/.local/bin
cp -n $APP_PATH/scripts/nvi.sh $HOME/.local/bin

# LEOVIM command
echo "#!/usr/bin/env bash" > $HOME/.local/bin/LEOVIM
echo "export LEOVIM_CONF=$HOME/.leovim.conf" >> $HOME/.local/bin/LEOVIM
echo 'cd $LEOVIM_CONF && git pull' >> $HOME/.local/bin/LEOVIM
echo '$SHELL' >> $HOME/.local/bin/LEOVIM && chmod 755 $HOME/.local/bin/LEOVIM

# set variable
update_vim_plug='0'
ret='0'

echo
if [ "$APP_PATH" == "$HOME/.leovim.conf" ]; then
    success "leovim has been already installed in $HOME/.leovim.conf"
elif [ ! -L "$HOME/.leovim.conf" ]; then
    success "leovim is going to be linked to $HOME/.leovim.conf"
    create_symlinks "$APP_PATH" "$HOME/.leovim.conf"
else
    success "leovim has been already linked to $HOME/.leovim.conf"
fi

echo
create_symlinks "$APP_PATH/clean.sh"           "$HOME/.leovim.clean"
create_symlinks "$APP_PATH/jetbrains/idea.vim" "$HOME/.ideavimrc"


echo
create_vimrc "$HOME/.vimrc"
create_vimrc "$HOME/.gvimrc"
create_vimrc "$HOME/.config/nvim/init.vim"
create_vimrc "$HOME/.config/nvim/ginit.vim"


if program_exists "vim"; then
    setup_plug "vim"
fi

if program_exists "nvim"; then
    setup_plug "nvim"
fi

echo
if [ -f $HOME/.vimrc.local ];then
    success "$HOME/.vimrc.local exists. You can modify it."
else
    cp $APP_PATH/scripts/local.vim $HOME/.vimrc.local
    success "$HOME/.vimrc.local does not exist, copy it."
    if program_exists "vim"; then
        vim $HOME/.vimrc.local
    fi
fi
msg "\nThanks for installing leoatchina's vim config"
msg "© `date +%Y` https://github.com/leoatchina/leovim"
