%pre --interpreter /bin/bash 
# Set root password

exec < /dev/tty6 > /dev/tty6 2> /dev/tty6
chvt 6

echo "Setting root password."
cat > /tmp/hashpw.py << EOF
import hashlib, getpass, sys, base64, os

iterations = 5000  # Match the iteration count used by openssl passwd -6
salt = hashlib.sha512(os.urandom(64)).hexdigest().encode()  # Generate random salt

pw = getpass.getpass("root password:")
combined = salt + pw.encode()  # Combine password and salt

h = hashlib.new("sha512")
for _ in range(iterations):
    h.update(combined)

con = getpass.getpass("confirm root password:")
encoded_hash = base64.b64encode(h.digest()).decode()  # Encode in base64

print(encoded_hash) if pw == con else sys.exit(1)
EOF

hashed_pw=$(python3 /tmp/hashpw.py)
echo "rootpw --iscrypted \$6\$$hashed_pw" > /tmp/root-config.ks
echo "rootpw --iscrypted $hashed_pw" 
read -p "PAUSED"
chvt 1
exec < /dev/tty1 > /dev/tty1 2> /dev/tty1
%end

%include /tmp/root-config.ks
