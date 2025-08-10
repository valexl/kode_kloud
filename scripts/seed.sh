#!/usr/bin/env bash
set -e

root_dir="$(cd "$(dirname "$0")/.." && pwd)"

docker compose -f "$root_dir/docker-compose.yml" up -d

wait_for() {
  url="$1"
  for i in $(seq 1 120); do
    code="$(curl -s -o /dev/null -w "%{http_code}" "$url")"
    if echo "$code" | grep -qE "200|404"; then
      return 0
    fi
    sleep 1
  done
  echo "Service not responding: $url"
  exit 1
}

wait_for "http://localhost:3001/lsm/api/v1/courses"
wait_for "http://localhost:3002/crs/api/v1/users/00000000-0000-0000-0000-000000000000/next-course"

gen_uuid() {
  if command -v uuidgen >/dev/null 2>&1; then
    uuidgen | tr "[:upper:]" "[:lower:]"
  else
    date +%s | md5 | cut -c1-32 | sed -E "s/(.{8})(.{4})(.{4})(.{4})(.{12})/\1-\2-\3-\4-\5/"
  fi
}

req() {
  method="$1"; url="$2"; data="${3:-}"
  if [ -n "$data" ]; then
    code="$(curl -sS -o /tmp/resp.json -w "%{http_code}" -X "$method" "$url" -H "Content-Type: application/json" -d "$data")"
  else
    code="$(curl -sS -o /tmp/resp.json -w "%{http_code}" -X "$method" "$url" -H "Content-Type: application/json")"
  fi
  if [ "$code" -lt 200 ] || [ "$code" -ge 300 ]; then
    echo "HTTP $code $method $url"
    cat /tmp/resp.json; echo
    exit 1
  fi
  cat /tmp/resp.json
}

parse_id() {
  if command -v jq >/dev/null 2>&1; then
    jq -r '.id' 2>/dev/null | tr -d '\r\n'
  else
    sed -E 's/.*"id":"?([^",}]+).*/\1/' | tr -d '\r\n'
  fi
}

created_courses=()

create_course() {
  title="$1"; description="$2"
  id="$(req POST "http://localhost:3001/lsm/api/v1/courses" "{\"course\":{\"title\":\"$title\",\"description\":\"$description\"}}" | parse_id)"
  if [[ "$id" =~ ^[0-9a-f-]{36}$ ]]; then
    created_courses+=("$id")
  fi
  printf "%s\n" "$id"
}

create_lesson() {
  title="$1"; description="$2"; course_id="$3"
  id="$(req POST "http://localhost:3001/lsm/api/v1/lessons" "{\"lesson\":{\"title\":\"$title\",\"description\":\"$description\",\"course_id\":\"$course_id\"}}" | parse_id)"
  printf "%s\n" "$id"
}

user_id="$(gen_uuid)"

c1="$(create_course "Math 101" "Basic math course")"
c2="$(create_course "Physics 101" "Introduction to physics")"
c3="$(create_course "Chemistry 101" "Basic chemistry")"
c4="$(create_course "History 101" "Introduction to world history")"

l1c1="$(create_lesson "Lesson 1" "Intro" "$c1")"
l2c1="$(create_lesson "Lesson 2" "Deep dive" "$c1")"
l1c2="$(create_lesson "Lesson 1" "Intro" "$c2")"
l2c2="$(create_lesson "Lesson 2" "Deep dive" "$c2")"
l1c3="$(create_lesson "Lesson 1" "Intro" "$c3")"
l2c3="$(create_lesson "Lesson 2" "Deep dive" "$c3")"

req POST "http://localhost:3001/lsm/api/v1/courses/$c1/lessons/$l1c1/start" "{\"user_id\":\"$user_id\"}" >/dev/null
req POST "http://localhost:3001/lsm/api/v1/courses/$c1/lessons/$l1c1/complete" "{\"user_id\":\"$user_id\"}" >/dev/null
req POST "http://localhost:3001/lsm/api/v1/courses/$c1/lessons/$l2c1/start" "{\"user_id\":\"$user_id\"}" >/dev/null
req POST "http://localhost:3001/lsm/api/v1/courses/$c1/lessons/$l2c1/complete" "{\"user_id\":\"$user_id\"}" >/dev/null

req POST "http://localhost:3001/lsm/api/v1/courses/$c2/lessons/$l1c2/start" "{\"user_id\":\"$user_id\"}" >/dev/null
req POST "http://localhost:3001/lsm/api/v1/courses/$c2/lessons/$l1c2/complete" "{\"user_id\":\"$user_id\"}" >/dev/null
req POST "http://localhost:3001/lsm/api/v1/courses/$c2/lessons/$l2c2/start" "{\"user_id\":\"$user_id\"}" >/dev/null

req POST "http://localhost:3001/lsm/api/v1/courses/$c3/lessons/$l1c3/start" "{\"user_id\":\"$user_id\"}" >/dev/null

courses_count="${#created_courses[@]}"
echo "Created courses: 4"
echo "Lessons in $c1: 2"
echo "Lessons in $c2: 2"
echo "Lessons in $c3: 2"
echo "Lessons in $c4: 0"
echo "User: $user_id finished lessons: $l1c1,$l2c1,$l1c2"
echo "User: $user_id finished courses: $c1"

echo "User stats:"
req GET "http://localhost:3001/lsm/api/v1/users/$user_id/stats"
echo
echo "Next course recommendation:"
req GET "http://localhost:3002/crs/api/v1/users/$user_id/next-course"
echo
