#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C.UTF-8
umask 022

if [[ $EUID -ne 0 ]]; then
    printf 'The isolated user-management section requires root.\n' >&2
    exit 1
fi

scratch=$(mktemp -d /tmp/linux-basics.XXXXXXXX)
cleanup() {
    case "$scratch" in
        /tmp/linux-basics.????????) rm -rf -- "$scratch" ;;
    esac
}
trap cleanup EXIT
lab_home="$scratch/home"
mkdir "$lab_home"
cd "$scratch"

run() {
    printf '$'
    printf ' %q' "$@"
    printf '\n'
    "$@"
}

section() {
    printf '\n=== %s | B24040323 徐翊涵 ===\n' "$1"
}

install_dynamic() {
    local binary=$1 lib
    cp -L --parents "$binary" "$account_root"
    while IFS= read -r lib; do
        cp -L --parents "$lib" "$account_root"
    done < <(ldd "$binary" | awk '$2 == "=>" && $3 ~ /^\// {print $3} $1 ~ /^\// {print $1}')
}

student_id=0323
name=徐翊涵
test_user="NY$student_id"
printf 'Experiment 1 | B24040323 徐翊涵\n'
printf 'Environment: %s (WSL Ubuntu)\n' "$(. /etc/os-release; printf '%s' "$PRETTY_NAME")"

section '1. Directory operations'
run pwd
run cd "$lab_home"
run mkdir "$student_id"
run cd "$student_id"
run mkdir cs
run ls
run rmdir cs
run ls
test ! -e cs

section '2. File operations'
run cd "$lab_home"
run touch "$name.txt"
run ls
printf '$ echo "hello world" > %s.txt\n' "$student_id"
echo "hello world" > "$student_id.txt"
run cat "$student_id.txt"
run cp "$name.txt" "${student_id}_copy.txt"
run mv "$name.txt" "${student_id}_newname.txt"
run ls
cmp "${student_id}_copy.txt" "${student_id}_newname.txt"
test ! -e "$name.txt"
test "$(cat "$student_id.txt")" = 'hello world'

section '3. User and group operations'
account_root="$scratch/accounts"
mkdir -p "$account_root"/{dev,etc/pam.d,home,root}
chmod 0755 "$account_root"
mknod -m 0666 "$account_root/dev/null" c 1 3
printf '%s\n' 'root:x:0:0:root:/root:/bin/bash' > "$account_root/etc/passwd"
printf '%s\n' 'root:x:0:' > "$account_root/etc/group"
printf '%s\n' 'root:!:0:0:99999:7:::' > "$account_root/etc/shadow"
printf '%s\n' 'root:!::' > "$account_root/etc/gshadow"
chmod 0600 "$account_root"/etc/{shadow,gshadow}
printf '%s\n' 'passwd: files' 'group: files' 'shadow: files' > "$account_root/etc/nsswitch.conf"
pam_rootok=(/lib/*/security/pam_rootok.so)
pam_permit=(/lib/*/security/pam_permit.so)
printf '%s\n' "auth required $pam_rootok" "account required $pam_permit" \
    "session required $pam_permit" > "$account_root/etc/pam.d/su"
for binary in /bin/bash /usr/bin/{su,whoami,id,touch,ls} "$pam_rootok" "$pam_permit"; do
    install_dynamic "$binary"
done

run whoami
printf 'Using a temporary root and account database.\n'
run groupadd --root "$account_root" student
run useradd --root "$account_root" --badname --create-home --shell /bin/bash "$test_user"
run usermod --root "$account_root" --gid student "$test_user"
LC_ALL=C TZ=CST-8 run chroot "$account_root" /usr/bin/su "$test_user" -c "cd ~; whoami; id; touch $test_user.txt; ls -l $test_user.txt"
test "$(stat -c '%u:%g' "$account_root/home/$test_user/$test_user.txt")" = \
    "$(awk -F: -v user="$test_user" '$1 == user {print $3 ":" $4}' "$account_root/etc/passwd")"

section '4. File permissions'
run touch demo
for change in 777 a-x go-w g+w a= +t u+s u+rx g+rws; do
    run chmod "$change" demo
    run ls -l demo
done
test "$(stat -c '%A' demo)" = '-r-srwS--T'

section '5. Archive and extraction'
run mkdir others
run touch others/example-a.txt others/example-b.txt
run tar -czvf backup.tar.gz others
run ls -l
run mkdir restored
run tar -xzvf backup.tar.gz -C restored
run ls -l restored/others
diff -r others restored/others

section '6. Text search'
cat > textfile <<'EOF'
no, I study in njupt.
this line ends with 00
this line ends with .00
I am 25 years old.
He is 15. It is 16.00
wy is the short of my name.
EOF
run cat textfile
run grep '^n' textfile
run grep '\.00$' textfile
run grep '5\..' textfile
run grep '^[wy]' textfile
test "$(grep -c '\.00$' textfile)" -eq 2
test "$(grep -c '5\..' textfile)" -eq 1
printf '\nAll six command sections completed.\n'
