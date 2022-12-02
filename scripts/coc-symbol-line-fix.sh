for each in `find ~/.local -type f | grep coc-symbol-line | grep vim$`; do
  echo "change $each encoding to unix by vim"
  vim -u 'NONE' -c 'set ff=unix | wq! ' $each
done
