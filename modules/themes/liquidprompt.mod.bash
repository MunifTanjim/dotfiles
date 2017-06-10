LP_GIT_IGNORE_UNTRACKED=${LP_GIT_IGNORE_UNTRACKED:-"true"}
LP_GIT_DETAILS=${LP_GIT_DETAILS:-"status"}

function git_status_summary {
  awk '
  BEGIN {
    untracked=0;
    unstaged=0;
    staged=0;
  }
  {
    if (!after_first && $0 ~ /^##.+/) {
      print $0
      seen_header = 1
    } else if ($0 ~ /^\?\? .+/) {
      untracked += 1
    } else {
      if ($0 ~ /^.[^ ] .+/) {
        unstaged += 1
      }
      if ($0 ~ /^[^ ]. .+/) {
        staged += 1
      }
    }
    after_first = 1
  }
  END {
    if (!seen_header) {
      print
    }
    print untracked "\t" unstaged "\t" staged
  }'
}

function _lp_git_status_details {
  local details=''
  [[ "${LP_GIT_IGNORE_UNTRACKED}" = "true" ]] && local git_status_flags='-uno'
  local status_lines=$((git status --porcelain ${git_status_flags} -b 2> /dev/null ||
                        git status --porcelain ${git_status_flags}    2> /dev/null) | git_status_summary)
  local status=$(awk 'NR==1' <<< "$status_lines")
  local counts=$(awk 'NR==2' <<< "$status_lines")
  IFS=$'\t' read untracked_count unstaged_count staged_count <<< "$counts"
  if [[ "${untracked_count}" -gt 0 || "${unstaged_count}" -gt 0 || "${staged_count}" -gt 0 ]]; then
    [[ "${staged_count}" -gt 0 ]] && details+=" S:${staged_count}"
    [[ "${unstaged_count}" -gt 0 ]] && details+=" U:${unstaged_count}"
    [[ "${untracked_count}" -gt 0 ]] && details+=" ?:${untracked_count}"
  fi
  echo $details
}

function _lp_git_diff_details {
  local details=''
  local shortstat="$(LC_ALL=C \git diff --shortstat HEAD 2>/dev/null)"
  if [[ -n "$shortstat" ]]; then
    local u_stat # shorstat of *unstaged* changes
    u_stat="$(LC_ALL=C \git diff --shortstat 2>/dev/null)"
    u_stat=${u_stat/*changed, /} # removing "n file(s) changed"

    local i_lines # inserted lines
    if [[ "$u_stat" = *insertion* ]]; then
      i_lines=${u_stat/ inser*}
    else
      i_lines=0
    fi

    local d_lines # deleted lines
    if [[ "$u_stat" = *deletion* ]]; then
      d_lines=${u_stat/*\(+\), }
      d_lines=${d_lines/ del*/}
    else
      d_lines=0
    fi

    details+="+$i_lines/-$d_lines"
  fi
  echo $details
}

# Set a color depending on the branch state:
# - green if the repository is up to date
# - yellow if there is some commits not pushed
# - red if there is changes to commit
#
# Add the number of pending commits and the impacted lines.
_lp_git_branch_color()
{
    (( LP_ENABLE_GIT )) || return

    local branch
    branch="$(_lp_git_branch)"
    if [[ -n "$branch" ]]; then

        local end
        end="${LP_COLOR_CHANGES}$(_lp_git_head_status)${NO_COL}"

        if LC_ALL=C \git status --porcelain 2>/dev/null | \grep -q '^??'; then
            end="$LP_COLOR_CHANGES$LP_MARK_UNTRACKED$end"
        fi

        # Show if there is a git stash
        if \git rev-parse --verify -q refs/stash >/dev/null; then
            end="$LP_COLOR_COMMITS$LP_MARK_STASH$end"
        fi

        local remote
        remote="$(\git config --get branch.${branch}.remote 2>/dev/null)"

        local has_commit=""
        local commit_ahead
        local commit_behind
        if [[ -n "$remote" ]]; then
            local remote_branch
            remote_branch="$(\git config --get branch.${branch}.merge)"
            if [[ -n "$remote_branch" ]]; then
                remote_branch=${remote_branch/refs\/heads/refs\/remotes\/$remote}
                commit_ahead="$(\git rev-list --count $remote_branch..HEAD 2>/dev/null)"
                commit_behind="$(\git rev-list --count HEAD..$remote_branch 2>/dev/null)"
                if [[ "$commit_ahead" -ne "0" && "$commit_behind" -ne "0" ]]; then
                    has_commit="${LP_COLOR_COMMITS}+$commit_ahead${NO_COL}/${LP_COLOR_COMMITS_BEHIND}-$commit_behind${NO_COL}"
                elif [[ "$commit_ahead" -ne "0" ]]; then
                    has_commit="${LP_COLOR_COMMITS}$commit_ahead${NO_COL}"
                elif [[ "$commit_behind" -ne "0" ]]; then
                    has_commit="${LP_COLOR_COMMITS_BEHIND}-$commit_behind${NO_COL}"
                fi
            fi
        fi

        local ret
        local details="$(_lp_git_${LP_GIT_DETAILS}_details)"

        if [[ -n "$details" ]]; then
            if [[ -n "$has_commit" ]]; then
                # Changes to commit and commits to push
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$details${NO_COL},$has_commit)"
            else
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$details${NO_COL})" # changes to commit
            fi
        elif [[ -n "$has_commit" ]]; then
            # some commit(s) to push
            if [[ "$commit_behind" -gt "0" ]]; then
                ret="${LP_COLOR_COMMITS_BEHIND}${branch}${NO_COL}($has_commit)"
            else
                ret="${LP_COLOR_COMMITS}${branch}${NO_COL}($has_commit)"
            fi
        else
            ret="${LP_COLOR_UP}${branch}" # nothing to commit or push
        fi
        echo -nE "$ret$end"
    fi
}

