# Prerequisites:
1. Add user to docker group              
2. Change file permission to make it executable

# Tools used:
1. Dockle
2. Trivy
3. Snyk monitor

# What it does:
It automatically installs the 3 tools and run scan on local or pull image from dockerhub
Also, it saves output to a json file.

# Sources:
1. Center Text (source: https://gist.github.com/TrinityCoder/911059c83e5f7a351b785921cf7ecdaa)
   


       print_centered() {
          [[ $# == 0 ]] && return 1

          declare -i TERM_COLS="$(tput cols)"
          declare -i str_len="${#1}"
          [[ $str_len -ge $TERM_COLS ]] && {
               echo "$1";
               return 0;
          }

          declare -i filler_len="$(( (TERM_COLS - str_len) / 2 ))"
          [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
          filler=""
          for (( i = 0; i < filler_len; i++ )); do
               filler="${filler}${ch}"
          done

          printf "%s%s%s" "$filler" "$1" "$filler"
          [[ $(( (TERM_COLS - str_len) % 2 )) -ne 0 ]] && printf "%s" "${ch}"
          printf "\n"

          return 0
         }

2. check whether tools are installed based on whether command/program exists. (source: https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script)


          if  [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v python3)" ] || [ ! -x "$(command -v ./dockle)" ] || [ ! -x "$(command -v ./trivy)" ] || [ ! -x "$(command -v snyk)" ]

