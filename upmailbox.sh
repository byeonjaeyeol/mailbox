echo "env_file : " $1;

find . -name '*.pid' -exec rm {} \;

docker-compose --env-file $1 -f docker-compose-mailbox.yml up