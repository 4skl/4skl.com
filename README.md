# 4skl's blog  
* For now the `main` branch is considered to be `dev` branch, once it'll be stable enough it'll be considered as the `prod` branch. And a `dev` branch will be created.  

## Dev setup  

### Requirements

- Docker
- Docker-compose
- VSCode
- VSCode Devcontainer extension
- Other VSCode extensions (see `.devcontainer/devcontainer.json`)  

Just open the project in VSCode and it'll ask you to open it in a devcontainer.

## Deploy

```sh
docker-compose up --build --force-recreate -d
```  
or
```sh
docker-compose up -d
```

## Utils

todo: add more utils
```sh
# Generate fixtures from prod (note: exlude contenttypes, auth.Permission and sessions.session; we exclude sessions to avoid leaking it in the repository, anyway it's not useful to have it in the fixtures too since the django secret key is changing at each deploy)
docker exec -it 4sklcom-django-1 python manage.py dumpdata --natural-foreign --natural-primary -e contenttypes -e auth.Permission -e sessions.session --indent 4 > ./skl_backend/fixtures/initial_data.json

# Get fixtures from prod
scp :~/4skl.com/skl_backend/fixtures/initial_data.json ./skl_backend/fixtures/initial_data.json

# Copy media from prod to dev
scp -r :~/4skl.com/media ./media

# Reset git to HEAD (remove all changes), used to reset prod after changing media files and copying them to dev with scp for example (note: use django admin, or command to get the fixture accordingly)
git reset --hard HEAD

```

## TODO

- [x] Create django models, urls, serializers and views
- [x] Setup admin user + create fixture with data
- [~] Create frontend using backend REST API
- [x] Checkout devcontainer for dev setup
- [ ] Setup prod env with docker-compose, and prepare for prod + branch to dev once done
- [ ] Deploy to VPS and setup nginx + ssl