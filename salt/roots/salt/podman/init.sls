podman-deps:
  pkg.installed:
    - pkgs:
      - perl-Pod-Escapes
      - perl-Mozilla-CA
      - mercurial
      - libffi-devel
      - criu-libs
      - gcc
      - perl-Time-Local
      - libmetalink
      - libbtrfs
      - kernel-srpm-macros
      - fpc-srpm-macros
      - container-selinux
      - perl-Pod-Perldoc
      - perl-Text-Tabs+Wrap
      - rust-srpm-macros
      - perl-lib
      - perl-constant
      - libmpc
      - perl-IO-Socket-IP
      - perl-HTTP-Tiny
      - python-srpm-macros
      - libgpg-error-devel
      - glib2-devel
      - git-core-doc
      - containernetworking-plugins
      - golang-bin
      - perl-Class-Struct
      - perl-Getopt-Std
      - ocaml-srpm-macros
      - git-core
      - libselinux-devel
      - iptables-legacy
      - pcre2-utf32
      - libassuan-devel
      - perl-mro
      - python3-libselinux
      - perl-DynaLoader
      - perl-URI
      - libnftnl
      - perl-File-stat
      - crun
      - device-mapper-devel
      - kernel-headers
      - pcre-cpp
      - pkgconf-pkg-config
      - kernel-modules
      - golang-github-cpuguy83-md2man
      - perl-Exporter
      - pcre-utf16
      - guile22
      - golang-src
      - glibc-static
      - libseccomp
      - linux-firmware
      - perl-MIME-Base64
      - perl-IPC-Open3
      - apr-util
      - libslirp
      - perl-Getopt-Long
      - utf8proc
      - perl-Git
      - zip
      - perl-Socket
      - glibc
      - systemd-devel
      - perl-podlators
      - libgpg-error
      - glibc-common
      - go-srpm-macros
      - perl-if
      - glibc-devel
      - libselinux-utils
      - criu
      - perl-Pod-Usage
      - pcre2-devel
      - perl-Carp
      - yajl
      - perl-Symbol
      - nim-srpm-macros
      - perl-POSIX
      - perl-overloading
      - perl-IO
      - lua-srpm-macros
      - sysprof-capture-devel
      - qt5-srpm-macros
      - libnet
      - rpmautospec-rpm-macros
      - apr-util-openssl
      - gpgme
      - perl-AutoLoader
      - perl-File-Path
      - perl-Errno
      - perl-libs
      - perl-PathTools
      - redhat-rpm-config
      - perl-File-Find
      - pcre-devel
      - nftables
      - pcre2-utf16
      - golang
      - perl-Term-ANSIColor
      - perl-overload
      - libsepol-devel
      - perl-interpreter
      - perl-Net-SSLeay
      - gnat-srpm-macros
      - efi-srpm-macros
      - libbtrfsutil
      - btrfs-progs
      - perl-subs
      - libxcrypt-static
      - apr-util-bdb
      - annobin-plugin-gcc
      - perl-Text-ParseWords
      - kernel-core
      - dwz
      - perl-IO-Socket-SSL
      - perl-Storable
      - perl-Digest
      - libserf
      - perl-Term-Cap
      - subversion
      - btrfs-progs-devel
      - gc
      - libtool-ltdl
      - apr
      - perl-Pod-Simple
      - libsepol
      - zlib-devel
      - ghc-srpm-macros
      - perl-libnet
      - perl-Scalar-List-Utils
      - pkgconf-m4
      - libbsd
      - make
      - wget
      - perl-TermReadKey
      - gpgme-devel
      - containers-common
      - libpkgconf
      - subversion-libs
      - libseccomp-devel
      - perl-SelectSaver
      - fuse-overlayfs
      - pcre-utf32
      - perl-Digest-MD5
      - glibc-langpack-en
      - annobin-docs
      - perl-base
      - glib2
      - pkgconf
      - openblas-srpm-macros
      - perl-parent
      - perl-NDBM_File
      - perl-Fcntl
      - libxcrypt-devel
      - glibc-headers-x86
      - emacs-filesystem
      - glibc-gconv-extra
      - perl-File-Basename
      - git
      - perl-Data-Dumper
      - perl-File-Temp
      - libblkid-devel
      - perl-Encode
      - unzip
      - fonts-srpm-macros
      - libselinux
      - binutils
      - cpp
      - perl-FileHandle
      - perl-srpm-macros
      - perl-B
      - conmon
      - libmount-devel
      - perl-Error
      - python3-gpg
      - slirp4netns
      - binutils-gold
      - perl-vars

https://go.googlesource.com/go.git:
  git.latest:
    - rev: go1.17.7
    - target: /opt/go

go_deployed:
  cmd.run:
    - cwd: /opt/go/src
    - name: |
        ./all.bash
    - require:
      - git: https://go.googlesource.com/go.git

/etc/bashrc:
  file.append:
    - text:
      - export PATH=/opt/go/bin:$PATH

https://github.com/containers/conmon.git:
  git.latest:
    - rev: v2.1.0
    - target: /opt/conmon

conmon_deployed:
  cmd.run:
    - cwd: /opt/conmon
    - prepend_path: /opt/go/bin
    - name: |
        make
        make podman
    - require:
      - git: https://github.com/containers/conmon.git

/etc/modules-load.d/squashfs.conf:
  file.append:
    - text:
      - squashfs

/etc/modules-load.d/loop.conf:
  file.append:
    - text:
      - loop

https://github.com/opencontainers/runc.git:
  git.latest:
    - rev: v1.1.0
    - target: /opt/go/src/github.com/opencontainers/runc

runc_deployed:
  cmd.run:
    - cwd: /opt/go/src/github.com/opencontainers/runc
    - prepend_path: /opt/go/bin
    - env:
      - BUILDTAGS: "selinux seccomp"
    - name: |
        make
        cp runc /usr/bin/runc
    - require:
      - git: https://github.com/opencontainers/runc.git

/etc/containers:
  file.directory:
    - user: root
    - group: root
    - mode: "755"


/etc/containers/registries.conf:
  file.managed:
    - source: https://src.fedoraproject.org/rpms/containers-common/raw/main/f/registries.conf
    - skip_verify: True

/etc/containers/default-policy.json:
  file.managed:
    - source: https://src.fedoraproject.org/rpms/containers-common/raw/main/f/default-policy.json
    - skip_verify: True

https://github.com/containers/podman.git:
  git.latest:
    - rev: v4.0.0
    - target: /opt/podman

podman_deployed:
  cmd.run:
    - cwd: /opt/podman
    - prepend_path: /opt/go/bin
    - env:
      - BUILDTAGS: "selinux seccomp"
    - name: |
        make
        make install PREFIX=/usr
    - require:
      - git: https://github.com/containers/podman.git

