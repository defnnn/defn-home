#PATH="$(echo $PATH | tr ':' '\n' | sort -u | grep -v "$HOME" | grep -v "${PKG_HOME:-dont-find-anything}" | perl -ne '$m||={}; $$m{$_}++; if ($$m{$_}) { print "$_"; }' | perl -pe 's{\s+$}{:}')"
PATH="$(echo $PATH | tr ':' '\n' | sort -u | grep -v "$HOME" | grep -v "${PKG_HOME:-dont-find-anything}" | perl -pe 's{\s+$}{:}')"

function configure_cue {
  : ${SHLVL_INITIAL:=0}

  function guess_scheme {
    case "${TERM_PROGRAM:-}" in
      Apple_Terminal)
        echo slight
        ;;
      *)
        echo "${CUE_SCHEME:-${ITERM_PROFILE:-sdark}}"
        ;;
    esac
  }

  : ${CUE_SCHEME:="$(cat ~/.cue-scheme 2>&- || true)"}
  export CUE_SCHEME
  case "$(guess_scheme)" in
    slight) slight || true ;;
    *)      sdark  || true ;;
  esac
}

function bashrc {
  local shome="$(cd -P -- "$(dirname "${BASH_SOURCE}")" && pwd -P)"

  pushd ~/work/block > /dev/null
  source "script/profile"
  popd > /dev/null

  pushd "$shome" > /dev/null
  require
  popd > /dev/null

  if tty >/dev/null 2>&1; then
    configure_cue
  fi
}

bashrc || echo WARNING: "Something's wrong with .bashrc"

case "${TERM:-}" in
  screen*)
    TERM="screen-256color"
    ;;
  *)
    TERM="xterm-256color"
    ;;
esac
export TERM
