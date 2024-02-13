FROM ubuntu:rolling

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:longsleep/golang-backports
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update
RUN apt-get install -y golang-go neovim
RUN apt-get install -y tmux curl
RUN apt-get install -y openssh-server zsh neovim git
RUN apt-get install -y bat exa fd-find fzf
RUN apt-get install -y clangd

RUN mkdir -p /run/sshd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN echo 'root:toshi402' | chpasswd
RUN mkdir -p /root/.ssh && echo "StrictHostKeyChecking no" > /root/.ssh/config
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFo4OsarTtr/o22Wp+ge2CCB2N3KyNjI9DDLhjiBAqAE" > /root/.ssh/authorized_keys
WORKDIR /root
SHELL ["/usr/bin/zsh", "-c"]
RUN chsh -s /usr/bin/zsh
RUN go install github.com/x-motemen/ghq@latest
ENV GOPATH /root/go
ENV PATH $PATH:$GOPATH/bin
RUN echo aa$HOME
RUN --mount=type=ssh ghq get git@github.com:toshikimiyagawa/dotfiles.git
RUN --mount=type=ssh ghq get git@github.com:toshikimiyagawa/atcoder-workspace.git
RUN --mount=type=ssh ghq get git@github.com:atcoder/ac-library.git
RUN curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
RUN rm .zshrc .zimrc
RUN ln -s ghq/github.com/toshikimiyagawa/dotfiles/.zshrc
RUN ln -s ghq/github.com/toshikimiyagawa/dotfiles/.zimrc
RUN ln -s ghq/github.com/toshikimiyagawa/dotfiles/.config
RUN ln -s ghq/github.com/toshikimiyagawa/dotfiles/.fzf.zsh
RUN ln -s ghq/github.com/toshikimiyagawa/dotfiles/.atcodertools.toml
RUN source /root/.zim/zimfw.zsh install

RUN git config --global user.email "toshi402@gmail.com"
RUN git config --global user.name "Toshiki Miyagawa"

EXPOSE 22
ENTRYPOINT [ "/usr/sbin/sshd", "-D"]
