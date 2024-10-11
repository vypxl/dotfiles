run_segment() {
  dir=$(tmux display -p -F "#{pane_current_path}")
  abbr=$(echo $dir | awk "{ sub(\"^$HOME\", \"~\"); print}")
  abbr=$(echo $abbr | awk '
    BEGIN { FS = OFS = "/" }
    {
      for (i = 1; i < NF; i++) {
        k = 1
        if (substr($i, 1, 1) == ".") { k = 2 }
        if (length($i) > k) {
          $i = substr($i, 1, k)
        }
      }
      print
    }
  ')

  echo $abbr
}
