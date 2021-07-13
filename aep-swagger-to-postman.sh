#!/bin/bash

echo ""
echo "============================================================================================================="
echo ""
echo " Usage: ./aep-swagger-to-postman.sh <Git repo to PR from>"
echo " Example: ./aep-swagger-to-postman.sh git@github.com:davidjgonzalez/experience-platform-postman-samples.git" 
echo ""
echo "============================================================================================================="

if [ -z "$1" ]
then

echo ""
echo "You must provide the Git repository where the Postman files will be written to as the first command line parameter"
echo ""
echo "============================================================================================================="

else

dt=$(date '+%Y-%m-%d_%H-%M');

echo ""
echo " Conversion job Id: $dt"
echo " Git repository where the Postman files will be written to: $1";
echo ""
echo "============================================================================================================="
echo ""

rm -rf /tmp/swagger-to-postman
mkdir -p /tmp/swagger-to-postman
cd /tmp/swagger-to-postman
git clone --depth=1 git@github.com:AdobeAtAdobe/kirby_docs.git docs
git clone --depth=1 git@github.com:davidjgonzalez/swagger-to-postman-collections app
git clone git@github.com:adobe/experience-platform-postman-samples.git samples
cd /tmp/swagger-to-postman/samples && git remote add stage $1
rm -rf /tmp/swagger-to-postman/samples/apis/experience-platform/*.json
rm -rf /tmp/swagger-to-postman/samples/apis/experience-platform/*.zip
cd /tmp/swagger-to-postman/app && npm install
/tmp/swagger-to-postman/app/app.js --input /tmp/swagger-to-postman/docs/acpdr/swagger-specs --output /tmp/swagger-to-postman/samples/apis/experience-platform
cd /tmp/swagger-to-postman/samples/apis/experience-platform && zip "Experience Platform APIs - All Postman Collections.zip" *.json
cd /tmp/swagger-to-postman/samples && git add . && git commit -a -m "Postman collections generated from Swagger specs ($dt)" && git push stage master:postman-collections-$dt

echo ""
echo "============================================================================================================="
echo " Done!"
echo " Now go make a PR with your updates from $1!"
echo "============================================================================================================="

fi
