# docker
alias dc=docker-compose
alias dd="dc down"
alias testb='dc exec backend npm run test:i $1'
alias testbw='dc exec backend npm run test:i $1 -- --watch'
alias playground='docker-compose exec backend npm run integration'

# aws
alias sts='aws sts get-session-token --serial-number arn:aws:iam::__AWS_ACCOUNT_ID__:mfa/__USER_NAME__ --profile dev --token-code'
alias mfa='echo k2 && cd /c/repos/mfa-docker-aws && dc up'
alias mfahon='echo hon && cd /c/repos/mfa-docker-aws-s3 && dc up'
function stsx() {
    command=`aws sts get-session-token --serial-number arn:aws:iam::__AWS_ACCOUNT_ID__:mfa/__USER_NAME__ --profile dev --token-code $1 | jq -r '"export AWS_ACCESS_KEY_ID=" + .Credentials.AccessKeyId + " && export AWS_SECRET_ACCESS_KEY=" + .Credentials.SecretAccessKey + " && export AWS_SESSION_TOKEN=" + .Credentials.SessionToken'`
    eval $command
    echo $command
    echo 'GOD!!'
}

# git
alias gitf='git fetch --prune'
alias gitbalus="git branch |egrep -v '\*master|develop|main|gaya20'|xargs git branch -d"

# shell commands
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias more=/proc/cygdrive/c/Windows/System32/more.com

export LANG=ja_JP.UTF-8

# eval $(dircolors -b ~/.dircolors)


complete -C '/c/Program\ Files/Amazon/AWSCLIV2/aws_completer' aws

#node version management
eval "$(fnm env --use-on-cd --shell=bash)"
 # 別ドライブで作業するときパスが通らなくなる問題の解消
# export PATH=$PATH:$HOME/.fnm/aliases/default

# Convert and set Windows environment variables to LINUX-style PATH.
export PATH=$PATH:`cygpath -u $PATH`