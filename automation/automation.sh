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

#pullimage function
pull(){
	 #Pulling Image:
	 print_centered "=" "="
	 print_centered "Pulling Selected Image:" 
	 print_centered "=" "="
	 docker pull $DOCKERIMAGE

}



#dockle function
dockle(){
	 #Dockle Output:
	 print_centered "=" "="
	 print_centered "Dockle Result:"
	 print_centered "=" "="
	 ./dockle --exit-code 1 -f json --output test_results/dockle_results.json $DOCKERIMAGE
	 ./dockle $DOCKERIMAGE
}

#trivy function
trivy(){
	 #Trivy Output:
	 print_centered "=" "="
	 print_centered "Trivy Result:"
	 print_centered "=" "="
	 # To save the trivy result as trivy_results.json
	 ./trivy -f json -o test_results/trivy_results.json $DOCKERIMAGE
	 # To show Trivy test output 
	 ./trivy $DOCKERIMAGE
     
}

#snyk
snyk_monitor(){
	 print_centered "=" "="
	 print_centered "Do you want to monitor your scan results online?" 
	 print_centered "[Y]es or [N]o"
	 print_centered "=" "="
	 while read n
	 do
	 if [ $n = "Y" ]
	 then 
	 print_centered "=" "="
	 print_centered "Authentication, you will be redirected to snyk website."
	 snyk auth
	 print_centered "=" "="
	 print_centered "snyk Result:"
	 print_centered "=" "="
	 snyk container monitor $DOCKERIMAGE
	 break
	 
	 elif [ $n = "N" ]
	 then 
	 print_centered "=" "="
	 print_centered "End of scanning, view compiled output at output.html."
	 print_centered "=" "="
	 break
	 
	 else
	 print_centered "Invalid Option, Please re-enter"
	 
	 fi	
	 done
}
  	


#path to tools directory
cd security_tools 2> /dev/null


#check whether tools are installed based on whether command/program exists.
https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script

if  [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v python3)" ] || [ ! -x "$(command -v ./dockle)" ] || [ ! -x "$(command -v ./trivy)" ] || [ ! -x "$(command -v snyk)" ]
then
	print_centered "=" "="
  	print_centered "You do not have all required tools installed."
  #run installation script:
  	cd ~/automation
 	./installation.sh
else
print_centered "=" "=" 
print_centered "Please Select an Option:"
print_centered "1. Scan Local Image"
print_centered "2. Scan image from Docker Hub"
print_centered "=" "="


 
while read n
do
  if [ $n = 1 ]
  then
  print_centered "=" "="
  print_centered "Displaying Local Image:"
  print_centered "=" "="
  
  #display existing docker images:
  docker images
  
  #enter desired local image:
  print_centered "=" "="
  print_centered "Enter Image Name:"
  print_centered "=" "="
  
  read DOCKERIMAGE
  
  trivy
  dockle
  snyk_monitor
  break
    
  elif [ $n = 2 ]
  then
  print_centered "=" "="
  print_centered "Enter Image Name:"
  print_centered "=" "="
  read DOCKERIMAGE
  pull
  trivy
  dockle
  snyk_monitor
  break 
  
  else
  print_centered "Invalid Option, Please re-enter"
  
  fi
done
  	
fi


























