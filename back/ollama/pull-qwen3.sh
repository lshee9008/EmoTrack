bin/ollama serve &

pid=&!

sleep 5

echo "Pulling qwen3:4b model"
ollama pull qwen3:4b


wait $pid