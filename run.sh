#!/bin/bash

git clone https://github.com/sreedharm07/$COMPONENT.git
cd $COMPONENT/schema

if ["$DB_TYPE" == "my-sql"]; then
  mysql -h $(aws ssm get-parameter  --name rds.${ENV}.endpoint --with-decryption | jq .Parameter.Value | sed -e 's/"//g')-u$(aws ssm get-parameter  --name rds.${ENV}.mysqluname --with-decryption | jq .Parameter.Value | sed -e 's/"//g') -p$(aws ssm get-parameter  --name rds.${ENV}.mysqlpassword --with-decryption | jq .Parameter.Value | sed -e 's/"//g') < $COMPONENT.sql
fi

if ["$DB_TYPE" == "MONGODB"]; then
  curl -o  rds-combined-ca-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
  mongo --ssl --host  $(aws ssm get-parameter  --name db.${ENV}.backend --with-decryption | jq .Parameter.Value | sed -e 's/"//g'):27017 --sslCAFile rds-combined-ca-bundle.pem --username $(aws ssm get-parameter  --name db.${ENV}.username --with-decryption | jq .Parameter.Value | sed -e 's/"//g') --password $(aws ssm get-parameter  --name db.${ENV}.password --with-decryption | jq .Parameter.Value | sed -e 's/"//g') $COMPONENT.js
fi