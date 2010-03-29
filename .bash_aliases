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

# Aliases for XAMPP
alias lampstart='sudo /opt/lampp/lampp start'
alias lampstop='sudo /opt/lampp/lampp stop'
alias lamprestart='sudo /opt/lampp/lampp restart'
# Aliases for Tomcat
alias tomcatstart='/opt/apache-tomcat/bin/startup.sh'
alias tomcatstop='/opt/apache-tomcat/bin/shutdown.sh'
# vim:set filetype=sh: 
