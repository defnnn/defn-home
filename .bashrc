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
  if [[ -f "$shome/work/block/script/profile" ]]; then
    source "$shome/work/block/script/profile"
  fi

  if tty >/dev/null 2>&1; then
    require
    configure_cue
  fi
}

bashrc || echo WARNING: "Something's wrong with .bashrc"
set +exfu
