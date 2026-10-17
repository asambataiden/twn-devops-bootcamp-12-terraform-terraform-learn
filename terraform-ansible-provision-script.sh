
#!/bin/sh
set -eu

: "${EC2_PUBLIC_IP:?EC2_PUBLIC_IP is required}"
: "${SSH_KEY_PATH:?SSH_KEY_PATH is required}"
: "${ANSIBLE_USER:?ANSIBLE_USER is required}"

if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "ERROR: SSH private key file not found." >&2
  exit 1
fi

echo "Waiting for EC2 SSH readiness: $EC2_PUBLIC_IP"

attempts=0
max_attempts=60

until ssh \
  -i "$SSH_KEY_PATH" \
  -o BatchMode=yes \
  -o IdentitiesOnly=yes \
  -o ConnectTimeout=5 \
  -o StrictHostKeyChecking=accept-new \
  "$ANSIBLE_USER@$EC2_PUBLIC_IP" \
  "true" >/dev/null 2>&1
do
  attempts=$((attempts + 1))

  if [ "$attempts" -ge "$max_attempts" ]; then
    echo "ERROR: EC2 SSH readiness timeout." >&2
    exit 1
  fi

  echo "SSH not ready ($attempts/$max_attempts)."
  sleep 5
done

echo "SSH authentication successful."
echo "Starting Ansible deployment..."

ansible-playbook \
  --inventory "${EC2_PUBLIC_IP}," \
  --private-key "$SSH_KEY_PATH" \
  --user "$ANSIBLE_USER" \
  deploy-docker.yaml

echo "Ansible deployment completed successfully."
