localpath=$(git rev-parse --show-toplevel)

new_dir=${localpath}/infrastructure/heroku-app/app

rm -rf ${new_dir}
mkdir  ${new_dir}
cp -R static templates blogs main.py Procfile requirements.txt runtime.txt ${new_dir}