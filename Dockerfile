FROM archlinux

RUN echo "[multilib]" >> /etc/pacman.conf &&\
    echo "Include =/etc/pacman.d/mirrorlist" >> /etc/pacman.conf &&\
    pacman --noconfirm -Syyu &&\
    pacman --noconfirm -S steam
RUN pacman --noconfirm -S git fakeroot binutils sudo &&\
    useradd -m steam &&\
    usermod -aG wheel steam &&\
    sed "s/^# \(%wheel ALL=(ALL) NOPASSWD: ALL\)/\1/g" -i /etc/sudoers &&\
    cat /etc/sudoers
USER steam
WORKDIR /home/steam
RUN git clone https://aur.archlinux.org/steamcmd.git &&\
    cd steamcmd &&\
    makepkg --syncdeps --install --needed --noconfirm &&\
    mkdir /home/steam/.steam
VOLUME /home/steam/.steam
ENTRYPOINT ["sh", "-c", "steamcmd"]
