\
import os
from flask import Flask

app = Flask(__name__)

VISITS_KEY = "visits"
REDIS_HOST = os.environ.get("REDIS_HOST", "hello-world-redis-master")
REDIS_PORT = int(os.environ.get("REDIS_PORT", "6379"))

def try_redis_increment():
    try:
        import redis
        r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True, socket_connect_timeout=0.2)
        count = r.incr(VISITS_KEY)
        return count
    except Exception:
        return None

@app.get("/")
def hello():
    count = try_redis_increment()
    if count is None:
        return "Hello, World! (no Redis)\\n"
    return f"Hello, World! visits={count}\\n"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
