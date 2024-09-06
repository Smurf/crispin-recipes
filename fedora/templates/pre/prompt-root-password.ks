%pre --interpreter /bin/bash 
# Set root password

#exec < /dev/tty6 > /dev/tty6 2> /dev/tty6
#chvt 6

cat > /tmp/hashpw.py << EOF
import hashlib
import base64
import os
import getpass

def generate_openssl_passwd6(password):
    # Generate a random salt of 8 bytes
    salt = os.urandom(8)

    # Create a SHA512 hash object
    hash_obj = hashlib.sha512()

    # Combine the password and salt, and hash them
    hash_obj.update(password.encode('utf-8'))  # Encode password to bytes
    hash_obj.update(salt)

    # Derive the final hash using a 64-bit salt
    final_hash = hash_obj.digest()

    # Concatenate the salt and hash, and encode in Base64
    encoded_hash = base64.b64encode(salt + final_hash).decode('utf-8')

    # Add the '$6$' prefix to indicate SHA512-crypt
    return f"$6${encoded_hash}"

bad_pw = True
while bad_pw:
    password = getpass.getpass("Root password:")
    confirm = getpass.getpass("Verify password:")
    if(password == confirm):
        bad_pw = False
    else:
        print("Passwords did not match. Try again.")

print(generate_openssl_passwd6(password))
EOF

hashed_pw=$(python3 /tmp/hashpw.py | tail -n 1)
echo "rootpw --iscrypted $hashed_pw" > /tmp/root-config.ks
echo "rootpw --iscrypted $hashed_pw" 
read -p "PAUSED"
#chvt 1
#exec < /dev/tty1 > /dev/tty1 2> /dev/tty1
%end

%include /tmp/root-config.ks
