bin/ollama serve &

pid=&!

sleep 5

echo "Pulling deepseek-r1:8b model"
ollama pull deepseek-r1:8b


wait $pid