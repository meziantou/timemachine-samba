#!/bin/bash
set -e


: "${SMB_USER:=timemachine}"
: "${SMB_PASSWORD:=changeme}"
: "${TM_SIZE:=2T}"


echo "Configuring Samba user: ${SMB_USER}"


if ! id "${SMB_USER}" >/dev/null 2>&1; then
    useradd \
        --system \
        --no-create-home \
        --shell /usr/sbin/nologin \
        "${SMB_USER}"
fi


echo "${SMB_USER}:${SMB_PASSWORD}" | chpasswd


if ! pdbedit -L | grep -q "^${SMB_USER}:"; then
    (echo "${SMB_PASSWORD}"; echo "${SMB_PASSWORD}") \
        | smbpasswd -a -s "${SMB_USER}"
fi


envsubst \
    < /etc/samba/smb.conf.template \
    > /etc/samba/smb.conf


echo "Starting Samba"

exec smbd \
    --foreground \
    --no-process-group \
    --debug-stdout