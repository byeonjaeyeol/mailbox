docker-compose -f docker-compose-mailbox.yml down

find . -name '*.pid' -exec rm {} \;