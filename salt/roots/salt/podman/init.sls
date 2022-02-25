/etc/modules-load.d/squashfs.conf:
  file.append:
    - text:
      - squashfs

/etc/modules-load.d/loop.conf:
  file.append:
    - text:
      - loop

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
    - target: /tmp/podman

podman_deployed:
  cmd.run:
    - cwd: /tmp/podman
    - env:
      - BUILDTAGS: "selinux seccomp"
    - name: |
        make
        make install PREFIX=/usr
    - require:
      - git: https://github.com/containers/podman.git