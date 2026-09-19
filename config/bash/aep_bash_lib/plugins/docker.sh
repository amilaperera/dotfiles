# Docker bash plugin

# Docker completion
if command -v docker &>/dev/null; then
    # Try common paths for docker bash completion
    for _docker_completion in \
        /usr/share/bash-completion/completions/docker \
        /etc/bash_completion.d/docker \
        /usr/local/share/bash-completion/completions/docker; do
        if [[ -f "$_docker_completion" ]]; then
            source "$_docker_completion"
            break
        fi
    done
    unset _docker_completion
fi

# Aliases inspired by ohmyzsh docker plugin
alias dbl='docker build'
alias dcin='docker container inspect'
alias dcls='docker container ls'
alias dclsa='docker container ls -a'
alias dcprune='docker container prune'
alias dib='docker image build'
alias dii='docker image inspect'
alias dils='docker image ls'
alias dipu='docker image push'
alias dipru='docker image prune -a'
alias dirm='docker image rm'
alias dit='docker image tag'
alias dlo='docker container logs'
alias dnc='docker network create'
alias dncn='docker network connect'
alias dndcn='docker network disconnect'
alias dni='docker network inspect'
alias dnls='docker network ls'
alias dnprune='docker network prune'
alias dnrm='docker network rm'
alias dpo='docker container port'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dpu='docker pull'
alias dr='docker container run'
alias drit='docker container run -it'
alias drm='docker container rm'
alias dsprune='docker system prune'
alias dst='docker container start'
alias drs='docker container restart'
alias dsta='docker stop $(docker ps -q)'
alias dstp='docker container stop'
alias dsts='docker stats'
alias dtop='docker top'
alias dvi='docker volume inspect'
alias dvls='docker volume ls'
alias dvprune='docker volume prune'
alias dxc='docker container exec'
alias dxcit='docker container exec -it'

# Enter a running container
de() {
    docker exec -it "$1" "${2:-/bin/bash}"
}

