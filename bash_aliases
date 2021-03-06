#~/.bash_aliases
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias exot=exit
alias exut=exit
alias ack='ack-grep'
alias ks=ls
alias ll='ls -ltr'
alias la='ls -la'
alias snv=svn
function ifind() {
    find . -iname "*$1*" 2>/dev/null
}
function rebuild_drupal_tags() {
    local root_dir=$1
    local tagfile_name=$2
    if [[ -z $root_dir || -z $tagfile_name ]]; then
        echo "Usage: rebuild_drupal_tags root_dir tagfile_name"
        return 1
    fi
    pushd .
    cd ~/.vim/tags
    ctags --PHP-kinds=+cf --exclude="\.svn" --langmap=php:.php.module.inc.install.lib -R -o $tagfile_name $root_dir
    popd
}

function deploy_configs() {
    # Quick function to deploy shell configs
    local src_dir=$1
    if [[ -z $src_dir ]]; then
        echo "Usage: deploy_configs src_dir"
        return 1
    fi
    cp -r $src_dir/.zsh* $src_dir/.bash* ~/
    return 0
}

function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1;;
            *.tar.gz)   tar xzf $1;;
            *.bz2)      bunzip2 $1;;
            *.rar)      rar x $1;;
            *.gz)       gunzip $1;;
            *.tar)      tar xf $1;;
            *.tbz2)     tar xjf $1;;
            *.tgz)      tar xzf $1;;
            *.zip)      unzip $1;;
            *.Z)        uncompress $1;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Aliases for XAMPP
alias lampstart='sudo /opt/lampp/lampp start'
alias lampstop='sudo /opt/lampp/lampp stop'
alias lamprestart='sudo /opt/lampp/lampp restart'
# Aliases for Tomcat
alias tomcatstart='/opt/apache-tomcat/bin/startup.sh'
alias tomcatstop='/opt/apache-tomcat/bin/shutdown.sh'
# vim:set filetype=sh: 
