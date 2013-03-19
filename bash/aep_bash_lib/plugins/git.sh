function aep_current_git_branch()
{
    git branch --no-color | grep -E '^\*' | awk '{print $2}' \
        || echo "default_value"
}

# git aliases
alias ga='git add'
alias gb='git branch'
alias gca='git commit -v -a'
alias gst='git status'
alias gd='git diff'
alias gds='git diff --stat'
alias gl='git pull'
alias ggpull='git pull origin "$(aep_current_git_branch)"'
alias ggpush='git push origin "$(aep_current_git_branch)"'
alias gpsup='git push --set-upstream origin "$(aep_current_git_branch)"'
alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --stat'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --all'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gw='git worktree'
alias gwl='git worktree list'
alias gshow='git show --ws-error-highlight=all'
alias gbauthor='git for-each-ref --format="%(authorname): %(refname:short)" refs/remotes/'
