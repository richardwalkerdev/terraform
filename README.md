git init
git config --global user.email "<EMAIL>"
git config --global user.name "<NAME>"
git add .
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:richardwalkerdev/terraform.git
git push -u origin main
