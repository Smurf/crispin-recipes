# Set root password
%pre --interpreter /bin/bash 
exec < /dev/tty6 > /dev/tty6 2> /dev/tty6
chvt 6

read -s -p "Enter root password   : " rootpw

sleep 1

hash=$(echo "$rootpw" | sha256sum | cut -d ' ' -f 1);

echo "rootpw --iscrypted $hash" > /tmp/root-config.ks

chvt 1
exec < /dev/tty1 > /dev/tty1 2> /dev/tty1

%end

%include /tmp/root-config.ks
