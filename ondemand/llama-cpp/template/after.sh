# Wait for the Tensorboard server to start
echo "Waiting for Tensorboard server to open port ${port}..."
echo "TIMING - Starting wait at: $(date)"

READY=0
for i in {1..9000}; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
	    http://${host}:${port}/node/${host}/${port}/v1/models || true)
  echo "HTTP status: $STATUS"
  if [ "$STATUS" = "200" ]; then
    READY=1
    break
  fi
  sleep 1
done
if wait_until_port_used "${host}:${port}" 60; then
  echo "Discovered Tensorboard server listening on port ${port}!"
  echo "TIMING - Wait ended at: $(date)"
else
  echo "Timed out waiting for Tensorboard server to open port ${port}!"
  echo "TIMING - Wait ended at: $(date)"
  pkill -P ${SCRIPT_PID}
  clean_up 1
fi
sleep 2
