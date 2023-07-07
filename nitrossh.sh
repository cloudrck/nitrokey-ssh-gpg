# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ GnuPG configuration                                                       ║
# ║ Use GnuPG's gpg-agent(1) for SSH keys instead of ssh-agent(1)             ║
# ║                                                                           ║
# ║ You can source this manually, or add the code below to your ~/.bashrc     ║
# ║ (or whatever shell you use)                                               ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Start gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent &> /dev/null; then
    gpg-connect-agent /bye &> /dev/null
fi

unset SSH_AGENT_PID

# Tell ssh to use the gpg-agent
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# TTY magic to update the gpg-agent with the correct TTY you are using rather
# than where gpg-agent happened to have been started.
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
