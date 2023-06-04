localpath=$(git rev-parse --show-toplevel)

new_dir=${localpath}/infrastructure/elastic-beanstalk-app/app

rm -rf ${new_dir}
mkdir  ${new_dir}
cp -R static templates main.py Procfile requirements.txt ${new_dir}

cd ${new_dir}
zip -rX9q "../app.zip" .
cd ..
chmod 666 "app.zip"