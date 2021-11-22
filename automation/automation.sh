#https://www.geeksforgeeks.org/how-to-display-random-ascii-art-on-linux-terminal/
python3 << END
import random
import os
i = random.randrange(3) + 1 
website= "https://raw.githubusercontent.com/yufongg/ascii_image/main/ascii_image/" + str(i) + ".txt"
os.system("curl " +  website)
END

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
	 
	 #trivy formating
	cd ~/automation/format
	cp trivy_format.sh ~/automation/security_tools
	cd ~/automation/security_tools
	./trivy image --format template --template "@trivy_format.sh" -o trivy_report.html $DOCKERIMAGE
	rm trivy_format.sh
	mv trivy_report.html ~/automation/format/scan_results

	#move back to security_tools directory
	cd ~/automation/security_tools
	
     
}

#dockle function
dockle(){
	 #Dockle Output:
	 print_centered "=" "="
	 print_centered "Dockle Result:"
	 print_centered "=" "="
	 ./dockle -f json --output test_results/dockle_results.json $DOCKERIMAGE
	 ./dockle $DOCKERIMAGE
	 
	#formating dockle
	cd ~/automation/format
	python3 dockle_format.py > scan_results/dockle_report.html	 
}

#snyk
snyk_monitor(){
	 print_centered "=" "="
	 print_centered "Do you want to monitor your scan results online? It will import scanning results online" 
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
	 break
	 
	 else
	 print_centered "Invalid Option, Please re-enter"
	 
	 fi	
	 done
	 

}
  	
#Example:

#path to tools directory
cd security_tools 2> /dev/null


#check whether tools are installed based on whether command/program exists.
#source:https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script#:~:text=To%20check%20if%20something%20is,then%20run%20this%20tool%20again."&text=The%20executable%20check%20is%20needed,name%20is%20found%20in%20%24PATH%20.

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
  export DOCKERIMAGE
  
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




#output.html
cd ~/automation/format/scan_results

#remove previous version of file
FILE=output.html
if test -f "$FILE"; then
    rm $FILE
fi

#append 3 files together for finalized output
echo "<h1>$DOCKERIMAGE - Dockle Results:</h1>" > title.html

cat trivy_report.html title.html dockle_report.html> output.html > output.html

rm title.html


#instance
print_centered "=" "="
print_centered "Are you running the script on a EC2 Instance [Y/N]"
print_centered "=" "="
while read n
do
if [ $n = "Y" ]
then
print_centered "=" "=" 
print_centered "Exporting output.html to S3 Bucket"
print_centered "=" "="
aws s3 cp output.html s3://fypraphael
break

elif [ $n = "N" ]
then 
break

else
print_centered "Invalid Option, Please re-enter"

fi
done

sleep 2

print_centered "=" "=" 
print_centered "End of scanning, please view output at output.html"
print_centered "=" "="
































