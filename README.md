# LMS + CRS Monorepo

## TL;DR

```bash
docker compose up -d
```

## Services

* LMS Service: [http://localhost:3001/lsm/api/v1](http://localhost:3001/lsm/api/v1)
* Course Recommendation Service: [http://localhost:3002/crs/api/v1](http://localhost:3002/crs/api/v1)

## Seed Data

After starting the services, you can populate them with example data:

```bash
bash script/seed.sh
```

## Tests

```bash
make lms-test
make crs-test
```

## Consoles

```bash
make lms-console
make crs-console
```

## Docs

* Architecture and design: [docs/architecture.md](docs/architecture.md)
* API usage and cURL examples: [docs/curl-examples.md](docs/curl-examples.md)
