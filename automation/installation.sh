#center text
#source: https://gist.github.com/TrinityCoder/911059c83e5f7a351b785921cf7ecdaa
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






# installation of packages:
print_centered "=" "="
print_centered "Installing/updating required packages"
print_centered "=" "="
sudo apt-get update



#installation of tools:
#create tools directory & output directory:
print_centered "=" "="
print_centered "Created Security Tools Directory & Test Result Directory"

mkdir -v security_tools 2> /dev/null
cd security_tools 
mkdir -v test_results 2> /dev/null

while [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v python3)" ] || [ ! -x "$(command -v ./dockle)" ] || [ ! -x "$(command -v ./trivy)" ] || [ ! -x "$(command -v snyk)" ]; 
do

if [ ! -x "$(command -v npm)" ]
then
print_centered "=" "="
print_centered "npm Installation:"
print_centered "=" "="
sudo apt install npm


elif [ ! -x "$(command -v python3)" ]
then
print_centered "=" "="
print_centered "python3 Installation"
print_centered "=" "="
sudo apt-get install -y python3 python3-pip rpm git
sudo apt install python-pip
pip3 install json2html

elif [ ! -x "$(command -v ./dockle)" ]
then
#1 Dockle Installation & Extraction:
#source:https://github.com/goodwithtech/dockle#debianubuntu
print_centered "=" "="
print_centered "1. Dockle Installation & Extraction:"
print_centered "=" "="
export VERSION=$(
 curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
 grep '"tag_name":' | \
 sed -E 's/.*"v([^"]+)".*/\1/' \
) && curl -L -o dockle_Linux-64bit.tar.gz https://github.com/goodwithtech/dockle/releases/download/v${VERSION}/dockle_${VERSION}_Linux-64bit.tar.gz && tar zxf dockle_Linux-64bit.tar.gz

elif [ ! -x "$(command -v ./trivy)" ]
then
#2 Trivy Installation & Extraction:
#source: https://www.infoq.com/news/2020/04/trivy-docker-harbor/ (ignore build code)
print_centered "=" "="
print_centered "2. Trivy Installation & Extraction:"
print_centered "=" "="
 export VERSION=$(curl --silent "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && curl -L -o trivy_Linux-64bit.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_Linux-64bit.tar.gz && tar zxf trivy_Linux-64bit.tar.gz
 

elif [ ! -x "$(command -v snyk)" ]
then

#3 Some other tool, snyk 
print_centered "=" "="
print_centered "3. snyk Installation:"
print_centered "=" "="
sudo npm install -g snyk

elif [ -x "$(command -v snyk)" ] && [ -x "$(command -v ./dockle)" ] && [ -x "$(command -v ./trivy)" ] && [ -x "$(command -v python3)" ] && [ -x "$(command -v npm)" ]
then
break
fi
done
#Removal of unnecessary files
rm -r LICENSE README.md contrib
print_centered "=" "="
print_centered "End of Installation"
print_centered "=" "="

cd ..
./automation.sh











