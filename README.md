# GreenScreen
This is a docker image for [groupon/greenscreen](https://github.com/groupon/greenscreen)

# Usage
```bash
docker run -tid -p 4994:4994 -e CAST_APPID="your_chromcast_appID" -e COUCH_HOST="http://couchdb" -e COUCH_PORT="5984" -e COUCH_DB="gscreen" -e COUCH_USER="gscreen" -e COUCH_PASS="gscreen" fengal/greenscreen-alpine
```