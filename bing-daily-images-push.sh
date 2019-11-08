update_readme_images() {
  # remove previous images
  fixed_line_number=$(cat README.md | awk '/<!-- Wallpapers -->/{ print NR; exit }')

  tmp_readme=$(head -n $fixed_line_number README.md)
  echo "$tmp_readme\n" > README.md

  # add latest images
  modified_filename_list=$(git status --porcelain | cut -c4-)

  for filename in $modified_filename_list; do
    if [[ $filename == *.jpg ]]; then
      echo "### $filename\n" >> README.md
      echo "![$filename]($filename)\n" >> README.md
    fi
  done
}

git_commit_push_changes() {
  git remote add origin-token https://${GITHUB_TOKEN}@github.com/kijart/bing-daily-images-dl.git > /dev/null 2>&1
  git config --global user.email "kijart+ci@gmail.com"
  git config --global user.name "Travis CI"

  git add .
  git commit --message "Bing daily images (`date +"%Y-%m-%d"`)"

  git push --quiet --set-upstream origin-token HEAD:master
}

update_readme_images
git_commit_push_changes
