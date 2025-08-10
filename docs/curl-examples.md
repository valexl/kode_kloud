## Example cURL requests

### Courses CRUD

#### Create courses

```bash
curl -X POST http://localhost:3001/lsm/api/v1/courses \
  -H "Content-Type: application/json" \
  -d '{"course":{"title":"Math 101","description":"Basic math course"}}'
```

#### Get list of courses

```bash
curl -X GET http://localhost:3001/lsm/api/v1/courses \
  -H "Content-Type: application/json"
```

#### Update a course

```bash
curl -X PUT http://localhost:3001/lsm/api/v1/courses/<course_id> \
  -H "Content-Type: application/json" \
  -d '{"course":{"title":"Math 201","description":"Advanced math course"}}'
```

#### Get course by ID (verify update)

```bash
curl -X GET http://localhost:3001/lsm/api/v1/courses/<course_id> \
  -H "Content-Type: application/json"
```

#### Delete a course

```bash
curl -X DELETE http://localhost:3001/lsm/api/v1/courses/<course_id> \
  -H "Content-Type: application/json"
```

#### Get course by ID (verify deletion)

```bash
curl -X GET http://localhost:3001/lsm/api/v1/courses/<course_id> \
  -H "Content-Type: application/json"
```

#### Get list of courses (verify deletion)

```bash
curl -X GET http://localhost:3001/lsm/api/v1/courses \
  -H "Content-Type: application/json"
```

### Lessons CRUD

#### Create a lesson

```bash
curl -X POST http://localhost:3001/lsm/api/v1/lessons \
  -H "Content-Type: application/json" \
  -d '{"lesson":{"title":"Lesson 1","description":"Intro lesson","course_id":"<course_id>"}}'
```

#### Get list of lessons

```bash
curl -X GET http://localhost:3001/lsm/api/v1/lessons \
  -H "Content-Type: application/json"
```

#### Get a lesson by ID

```bash
curl -X GET http://localhost:3001/lsm/api/v1/lessons/<lesson_id> \
  -H "Content-Type: application/json"
```

#### Update a lesson

```bash
curl -X PUT http://localhost:3001/lsm/api/v1/lessons/<lesson_id> \
  -H "Content-Type: application/json" \
  -d '{"lesson":{"title":"Updated Lesson","description":"Advanced part","course_id":"<course_id>"}}'
```

#### Delete a lesson

```bash
curl -X DELETE http://localhost:3001/lsm/api/v1/lessons/<lesson_id> \
  -H "Content-Type: application/json"
```

#### Get lesson by ID (verify deletion)

```bash
curl -X GET http://localhost:3001/lsm/api/v1/lessons/<lesson_id> \
  -H "Content-Type: application/json"
```

#### Get list of lessons (verify deletion)

```bash
curl -X GET http://localhost:3001/lsm/api/v1/lessons \
  -H "Content-Type: application/json"
```

### Lesson Progress

#### Start a lesson

```bash
curl -X POST http://localhost:3001/lsm/api/v1/courses/<course_id>/lessons/<lesson_id>/start \
  -H "Content-Type: application/json" \
  -d '{"user_id":"<user_id>"}'
```

#### Complete a lesson

```bash
curl -X POST http://localhost:3001/lsm/api/v1/courses/<course_id>/lessons/<lesson_id>/complete \
  -H "Content-Type: application/json" \
  -d '{"user_id":"<user_id>"}'
```

### User Stats

#### Get user stats

```bash
curl -X GET http://localhost:3001/lsm/api/v1/users/<user_id>/stats \
  -H "Content-Type: application/json"
```

### Course Recommendation

#### Get next course recommendation

```bash
curl -X GET http://localhost:3002/crs/api/v1/users/<user_id>/next-course \
  -H "Content-Type: application/json"
```
