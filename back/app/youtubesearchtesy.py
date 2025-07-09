from youtubesearchpython import VideosSearch

search = VideosSearch("Black Skinhead Rage Against the Machine official", limit=1)
result = search.result()
first_video_url = result['result'][0]['link']
print("🎬 유튜브 링크:", first_video_url)
